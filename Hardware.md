### Wake-on-Lan
* It works out of box for one of my Intel NUC. 
  * Enabled by default in BIOS
  * NUC supports Wake-on: pumbg (use man ethtool to see the meaning of each letter)
  * NUC wake-on :g (not d)
  * Wake NUC up from another machine (port is 9)
```
  sudo apt install wakeonlan
  wakeonlan -i nuc_ip nuc_mac
``` 
### See Laptop Charging Percent
```
cat /sys/class/power_supply/BAT0/capacity
```
### Prepare WSL 2 for Pytorch on Windows 10
0. Install the latest Nvidia Driver in Windows (Not in WSL)
1. Turn on the "Windows Subsystem for Linux" and "Virtual Machine Platform" features of Windows 10
2. Download [WSL2 Linux kernel update package for x64 machines](https://aka.ms/wsl2kernel) and install
3. Install WSL 2 in CMD Prompt
    ```
    wsl --set-default-version 2
    # Let's see the distribution name of Ubuntu 22.04
    wsl --list --online
    wsl --install -d Ubuntu-22.04
    # Let's check the version of wsl and installed distro
    wsl -l -v
    # In China, ...
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak_`date "+%y_%m_%d"`
    sudo sed -i 's/http:\/\/.*.ubuntu.com/https:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list
    sudo apt update 
    # sudo apt install build-essential # CUDA library installation needs gcc
    ```
### Pytorch + Ubuntu 22.04
1. Install the RTX2060 driver (I am going to use pytorch-cuda=11.8 and the corresponding version of gpu driver is 520)
    ```
    sudo su
    apt install -y nvidia-driver-520
    reboot
    ```
    or 
    ```
    apt install pkg-config libglvnd-dev build-essentials
    systemctl set-default multi-user.target && reboot
    bash NVIDIA-Linux-x86_64-535.113.01.run
    ```
2. We are going to create a single file and mount it as a new filesystem so everything is in one place
    ```
    dd if=/dev/zero of=/var/www/html/pytorch.ext3 bs=1M count=15000 status=progress
    mkfs.ext3 /var/www/html/pytorch.ext3
    mkdir -p ~/software/miniconda3
    sudo mount -o loop /var/www/html/pytorch.ext3 ~/software/miniconda3
    ```
3. Install Pytorch
    ```
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $HOME/software/miniconda3/
    $HOME/software/miniconda3/bin/conda create -y -c nvidia -c pytorch -n torch pytorch torchvision torchaudio pytorch-cuda=11.8
    source $HOME/software/miniconda3/bin/activate torch  
    ```
4. Test Pytorch
    ```
    python -c "import torch; print(torch.cuda.is_available())" 
    python -m torch.utils.collect_env
    wget https://raw.githubusercontent.com/xg590/tutorials/master/ML/pytorch_gpu_test_cnn.py -O pytorch_gpu_test_cnn.py
    python pytorch_gpu_test_cnn.py
    ```
### Disk
* sector (physical block): disk controller IO
* sector is the minimum unit of GUID partition table. 
* logical block: filesystem IO
```
  sudo fdisk -l | grep "Sector size" 
  sudo blockdev --getbsz /dev/sda
```
#### GPT
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/GUID_Partition_Table_Scheme.svg/360px-GUID_Partition_Table_Scheme.svg.png"></img>
* Partition table header (LBA 1)
``` 
  # dd bs=512 skip=1 count=1 if=/dev/sdc 2>/dev/null | hexdump -C 
  00000000  45 46 49 20 50 41 52 54  00 00 01 00 5c 00 00 00  |EFI PART....\...| # second 512 bytes of the disk, 45 46 49 20 50 41 52 54 is the signature
  00000010  49 75 ea e1 00 00 00 00  01 00 00 00 00 00 00 00  |Iu..............|
  00000020  ff ff ef 00 00 00 00 00  00 08 00 00 00 00 00 00  |................|
  00000030  de ff ef 00 00 00 00 00  0d 88 38 00 68 43 4f f7  |..........8.hCO.|
  00000040  af a3 b5 16 0f d2 22 fe  02 00 00 00 00 00 00 00  |......".........|
  00000050  80 00 00 00 80 00 00 00  f2 2c 2e 18 00 00 00 00  |.........,......|
  00000060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
  *
  00000200                                                                       # third 512 bytes (ignore this)
``` 
* Partition entries (LBA 2–33)
```
  # dd bs=512 skip=2 count=32 if=/dev/sdc 2>/dev/null | hexdump -C
  00000000  a2 a0 d0 eb e5 b9 33 44  87 c0 68 b6 b7 26 99 c7  |......3D..h..&..| # first partition
  00000010  a0 3e 3e 61 0c 35 8c 4f  b1 6e 6e 08 8e 7a e7 58  |.>>a.5.O.nn..z.X|
  00000020  00 08 00 00 00 00 00 00  ff 1f 7a 00 00 00 00 00  |..........z.....|
  00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
  *
  00000080  af 3d c6 0f 83 84 72 47  8e 79 3d 69 d8 47 7d e4  |.=....rG.y=i.G}.| # second partition (0x80 is 128 bytes)
  00000090  d8 16 47 92 1a 40 a8 4c  94 65 1f 51 fe fa 7c 0c  |..G..@.L.e.Q..|.|
  000000a0  00 20 7a 00 00 00 00 00  ff f7 ef 00 00 00 00 00  |. z.............|
  000000b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
  *
  00004000
```

#### dd
* seek skips n blocks from the beginning of the output file.
* skip skips n blocks from the beginning of the input file.
```
sdX=sdd
firstLBA=`sfdisk -d /dev/$sdX|grep first-lba|cut -f2 -d:|xargs echo -n` 
lastLBA=` sfdisk -d /dev/$sdX|grep  last-lba|cut -f2 -d:|xargs echo -n` 
echo $firstLBA $lastLBA # 2048 15728606 for someDisk; 34 524254 for virtualDisk

rm GPT.bak
dd bs=512                     count=34 if=/dev/$sdX 2>/dev/null >  GPT.bak # save LBA  0 ~  34
dd bs=512 skip=$((lastLBA+1)) count=33 if=/dev/$sdX 2>/dev/null >> GPT.bak # save LBA -1 ~ -34
```
* Zero
```
dd bs=512                     count=34 if=/dev/zero of=/dev/$sdX
dd bs=512 skip=$((lastLBA+1)) count=33 if=/dev/zero of=/dev/$sdX
dd bs=512                     count=34 if=/dev/$sdX 2>/dev/null | hexdump -C
dd bs=512 skip=$((lastLBA+1)) count=33 if=/dev/$sdX 2>/dev/null | hexdump -C 
```
* restore
``` 
dd bs=512                     count=34 if=GPT.bak         if=GPT.bak of=/dev/$sdX 
dd bs=512 seek=$((lastLBA+1)) count=33 if=GPT.bak skip=34 if=GPT.bak of=/dev/$sdX 
```
#### How can I assure a Linux installation media is genuine
* It is easy to assure the ISO file is genuine
```
$ sha256sum
c396e956a9f52c418397867d1ea5c0cf1a99a49dcf648b086d2fb762330cc88d ubuntu-22.04.1-desktop-amd64.iso
```
* Print out the partition table of the image in ISO file 
```
$ fdisk -l ubuntu-22.04.1-desktop-amd64.iso
Disk ubuntu-22.04.1-desktop-amd64.iso: 3.56 GiB, 3826831360 bytes, 7474280 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 9240A165-D190-4AB6-8A10-46DC207B42EE

Device                              Start     End Sectors  Size Type
ubuntu-22.04.1-desktop-amd64.iso1      64 7465119 7465056  3.6G Microsoft basic data
ubuntu-22.04.1-desktop-amd64.iso2 7465120 7473615    8496  4.1M EFI System
ubuntu-22.04.1-desktop-amd64.iso3 7473616 7474215     600  300K Microsoft basic data
```
* sha256sum the first partition
```
dd if=ubuntu-22.04.1-desktop-amd64.iso bs=512 skip=64 count=7465056 | sha256sum
6e2ae12fcf69a586a3c504a1cf9f9bcd7f99a8c3f8fe71bc13b977de151aaecc
```
* sha256sum sdx1 after the image was burned to SD Card.
```
dd if=/dev/sdb1 bs=512 | sha256sum 
```
### Use eGPU on Windows 10
* Material List
  * Razor Core X 
  * RTX 3060 Ti
  * Intel NUC
* Connection
  * Thunderbolt 3 PCIe x4 connection (rear connector only) is supported according to Intel NUC [datasheet](https://www.intel.com/content/dam/support/us/en/documents/intel-nuc/NUC10i357FN_TechProdSpec.pdf). 
  * Use rear end USB Type-C port.  
* Windows 10 High Performance Mode: Powershell in Admin Privilege [[Credit](https://community.intel.com/t5/Intel-NUCs/RTX-3060Ti-not-working-with-NUC-and-eGPU-Razer-Core-X-Chroma/m-p/1253473)] 
```
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
```
* Install Nvidia Driver  
* Disconnect eGPU: Do it in GPU control panel before cut the power
#### GPU-accelerated Transcoding
* [Ref](https://docs.nvidia.com/video-technologies/video-codec-sdk/ffmpeg-with-nvidia-gpu/)
* \# Prereq
```
sudo apt-get install build-essential nasm yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev
```
* \# Install ffnvcodec
```
git clone https://github.com/FFmpeg/nv-codec-headers.git
cd nv-codec-headers && sudo make install 
```
* \# Compile x264 codec lib
```
wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2
tar jxvf x264-master.tar.bz2
cd x264-master/
./configure --enable-static --disable-opencl
sudo make install
``` 
* \# Install x265 codec lib (instead of compilation)
```
sudo apt install libx265-dev
```
* \# Install FFmpeg
```
git clone https://github.com/FFmpeg/FFmpeg
cd FFmpeg 
./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --enable-static --disable-shared \
            --enable-gpl --enable-libx264 --enable-libx265 \
            --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 
make -j 4
```
### ChromeBox
1. Unscrew four bottom screws
2. Unscrew write-only protect screw
3. Upgrade RAM only at this moment and leave SSD alone
4. Poke the recovery hole while press power button
5. Press ctrl+d to turn off OS verification
6. Poke the recovery hole again so ChromeBox enters development mode
7. Connect to WiFi but do not agree OS legal terms
8. Press ctrl+alt+F2
9. Login with chronos (no password required) and flash ChromeBox with a new firmware
```
curl -L -O https://mrchromebox.tech/setup-kodi.sh && sudo bash setup-kodi.sh
```
10. Regular reboot and install Ubuntu
### MyCloudEx2Ultra
* Use nfs to sync folders. Install nfs client tools
```
sudo apt install nfs-common
```
* See what's on the nfs server
```
$ showmount -e 192.168.xxx.xxx
Export list for 192.168.xxx.xxx:
/mnt/abc 192.168.xxx.0/24
```
* Mount the share
```
sudo mount -t nfs 192.168.xxx.xxx:/mnt/abc /local_mount_point
```
### Power Off a USB drive and reverse the Power Off
* Know which bus the usb thumb is on (Bus 002)
```
$ lsusb -tv
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/6p, 10000M
    ID 1d6b:0003 Linux Foundation 3.0 root hub
    |__ Port 1: Dev 2, If 0, Class=Mass Storage, Driver=usb-storage, 5000M
        ID 0951:1666 Kingston Technology DataTraveler 100 G3/G4/SE9 G2/50
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/8p, 480M
    ID 1d6b:0002 Linux Foundation 2.0 root hub
    ...
```
* Umount and Power Off 
```
sudo udisksctl unmount   -b /dev/sda1 
sudo udisksctl power-off -b /dev/sda
```
* Reverse the Power Off
```
bus=/sys/bus/usb/devices/usb2/bConfigurationValue
cat $bus | sudo tee $bus
```
