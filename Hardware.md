### GPU accelerated Dockerized Pytorch on WSL 2
* Install WSL 2.
```
wsl --list --online # Let's see the distribution name of Ubuntu 22.04
wsl --set-default-version 2
wsl --install Ubuntu-22.04
sudo apt update 
```
* Install Docker and Nvidia Docker 2 in Ubuntu 22.04 (WSL 2)
```
sudo apt install -y docker.io
sudo dockerd # I use screen to keep dockerd running in the background
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
wget -O - https://nvidia.github.io/nvidia-docker/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-docker-keyring.gpg
wget -O - https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
          sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-docker-keyring.gpg] https://#g' | \
          sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update 
sudo apt install -y nvidia-docker2
```
* Update the Nvidia Driver to the latest on our host machine because we are pulling the latest pytorch from nvcr.io. 
```
mkdir test 
wget https://raw.githubusercontent.com/xg590/tutorials/master/ML/pytorch_gpu_test_cnn.py -O test/pytorch_gpu_test_cnn.py
nvidia-docker run -it                                    \
                  --rm                                   \
                  --gpus all                             \
                  --shm-size=1g                          \
                  --ulimit memlock=-1                    \
                  --ulimit stack=$((64 * 1024 * 1024))   \
                  -v ${PWD}/test:/workspace/test         \
                  nvcr.io/nvidia/pytorch:23.03-py3
python -c "import torch ; print(torch.cuda.is_available(), ' | ', torch.cuda.get_device_name(0))" 
python test/pytorch_gpu_test_cnn.py
```
* Some useful links on this topics
  * What is the latest pytorch? : https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags
  * https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-23-03.html
  * https://docs.nvidia.com/deeplearning/frameworks/user-guide/index.html
### CUDA Library (GPU Driver Included) on Ubuntu 22.04.2 (PyTorch will run natively)
* visit https://developer.nvidia.com/cuda-toolkit
* Download the .run file and (ba)sh it. (.run file plus pytorch might be small than dockerized pytorch)
```
sudo apt install build-essential             # Installer needs gcc
sudo sh ./cuda_11.8.0_520.61.05_linux.run    # It will try disable Nouveau kernel driver but installation will fail at the first time
sudo reboot                                  # After the reboot nouveau kernel driver will not be loaded.
sudo sh ./cuda_11.8.0_520.61.05_linux.run    # Installation will succeed

sudo bash cuda_11.8.0_520.61.05_linux.run --silent --driver --toolkit # Tested on WSL 2 
```
* Check the cuda lib and make sure it works
```
export            PATH=/usr/local/cuda-11.8/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH
nvcc --version
```
* PyTorch
```
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $HOME/software/miniconda3/
$HOME/software/miniconda3/bin/conda create -y -c nvidia -c pytorch -n torch pytorch torchvision torchaudio pytorch-cuda=11.8
source $HOME/software/miniconda3/bin/activate torch
cat << EOF >> ~/.bashrc
export            PATH=$PATH:/usr/local/cuda-11.8/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.8/lib64
EOF
```
* Test
```
import torch
torch.cuda.is_available()
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
torch.rand(10, device=device)
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
