### Firmware
* To my experience, bookworm does not work for Raspberry Pi Zero W, but bullseye does. 
* Raspberry Pi OS: [Homepage](https://www.raspberrypi.com/software/operating-systems/)
* Visit [this page](https://mirrors4.tuna.tsinghua.edu.cn/raspberry-pi-os-images/) from Tsinghua Univ or [this page](https://mirror.sjtu.edu.cn/raspberry-pi-os-images/) from Shanghai Jiaotong Univ to download 2024-11-19-raspios-bookworm-armhf-lite.img.xz
  ```
  wget https://mirrors4.tuna.tsinghua.edu.cn/raspberry-pi-os-images/raspios_lite_armhf/images/raspios_lite_armhf-2024-11-19/2024-11-19-raspios-bookworm-armhf-lite.img.xz
  ```
* Visit to download 2024-11-19-raspios-bookworm-armhf-lite.img.xz
  ```
  wget https://mirror.sjtu.edu.cn/raspberry-pi-os-images/raspios_lite_armhf/images/raspios_lite_armhf-2024-11-19/2024-11-19-raspios-bookworm-armhf-lite.img.xz
  wget https://mirror.sjtu.edu.cn/raspberry-pi-os-images/raspios_lite_armhf/images/raspios_lite_armhf-2024-11-19/2024-11-19-raspios-bookworm-armhf-lite.img.xz.sha256
  ```
* Checksum
  ```
  IMG=2025-05-13-raspios-bookworm-armhf-lite.img
  awk '{print $1}' ${IMG}.xz.sha256 | xargs -I % echo % ${IMG}.xz | sha256sum -c
  ```

* <details>
  <summary> Modify Raspbian image on Ubuntu </summary>

  * Unzip a Raspbian OS image
    ```sh
    sudo su
    IMG=2025-05-13-raspios-bookworm-arm64-lite.img

    cat << EOF > raspios.env
    export IMG=$IMG
    export YOUR_SSID=
    export YOUR_WIFI_PASSWORD=
    export AUTHORIZED_KEYS="ssh-ed25519 xxx xxx"
    echo \$IMG \$YOUR_SSID \$YOUR_WIFI_PASSWORD \$AUTHORIZED_KEYS
    EOF
    
    source raspios.env
    xz -dk $IMG.xz
    ```
  * Get offset 
    * startsector of boot partition begins at 8192
    * offset is 8192 * 512 byte/sector
    ```sh
    $ fdisk -l $IMG
    Disk 2025-05-13-raspios-bookworm-arm64-lite.img: 2.57 GiB, 2759852032 bytes, 5390336 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0xd9c86127

    Device                                      Boot   Start     End Sectors  Size Id Type
    2025-05-13-raspios-bookworm-arm64-lite.img1        16384 1064959 1048576  512M  c W95 FAT32 (LBA)
    2025-05-13-raspios-bookworm-arm64-lite.img2      1064960 5390335 4325376  2.1G 83 Linux
    ```
  * Mount system partition (Second partition is EXT4 format)
    ```sh
    mkdir                                            /tmp/raspbian_img
    mount -o offset=$((1064960*512)) $IMG            /tmp/raspbian_img
    mkdir -p                                         /tmp/raspbian_img/home/pi/.ssh
    ssh-keygen -t ed25519 -N '' -C 'pi' -f           /tmp/raspbian_img/home/pi/.ssh/id_ed25519
    cp                                               /tmp/raspbian_img/home/pi/.ssh/id_ed25519 /tmp/
    AUTHORIZED_KEYS=$(                           cat /tmp/raspbian_img/home/pi/.ssh/id_ed25519.pub)
    cp /tmp/raspbian_img/home/pi/.ssh/id_ed25519.pub /tmp/raspbian_img/home/pi/.ssh/authorized_keys
    chown -R 1000:1000                               /tmp/raspbian_img/home/pi/.ssh/
    cat /tmp/raspbian_img/home/pi/.ssh/id_ed25519
    # arm64
    sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g'                    /tmp/raspbian_img/etc/apt/sources.list
    # armhf
    sed -i 's,raspbian.raspberrypi.com,mirrors.tuna.tsinghua.edu.cn/raspbian,g' /tmp/raspbian_img/etc/apt/sources.list
    mkdir -p                                                                    /tmp/raspbian_img/home/pi/.config/pip/
    echo -e "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple" >  /tmp/raspbian_img/home/pi/.config/pip/pip.conf
    chown -R 1000:1000                                                          /tmp/raspbian_img/home/pi/.config/pip/
    umount /tmp/raspbian_img/
    ```
  * Mount boot partition (First partition is FAT32 and it support uid when mount)
    ```sh
    mount -o offset=$((16384*512)) $IMG /tmp/raspbian_img

    cat << EOF > /tmp/raspbian_img/custom.toml
    # Parameters in this file will be used to config the system in the first boot. 
    
    # This file is loaded by firstboot, parsed by init_config and ends up as several calls to imager_custom.
    # /usr/lib/raspberrypi-sys-mods/[firstboot,init_config,imager_custom]
    
    # The example below has all current fields.
    
    # Required:
    config_version = 1
    
    [system]
    hostname = "raspberrypi"
    
    [user]
    name = "pi"
    # The password can be encrypted or plain.
    password = "$(echo 'raspberry' | openssl passwd -6 -stdin)"
    password_encrypted = true
    
    [ssh]
    enabled = true
    password_authentication = false
    authorized_keys = [ "$AUTHORIZED_KEYS" ]
    
    [wlan]
    ssid = "$YOUR_SSID"
    password = "$YOUR_WIFI_PASSWORD"
    password_encrypted = false
    hidden = false
    country = "US"
    
    [locale]
    # grep XKBLAYOUT /etc/default/keyboard
    keymap = "us"
    timezone = "US/Eastern"
    EOF
    ```
  * Enable nvme
    ```sh
    cat << EOF >> /tmp/raspbian_img/config.txt 
    dtparam=nvme
    dtparam=pciex1_gen=3
    EOF
    ```
    ```
    cat /tmp/raspbian_img/custom.toml
    umount /tmp/raspbian_img
    ```   
</details>

* Flash
  ```
  dd if=${IMG} of=/dev/sdb bs=1M status=progress && udisksctl power-off -b /dev/sdb
  ``` 
### Configuration
* Apt source
  ```
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak_`date "+%y_%m_%d"`
  sudo sed -i 's/raspbian.raspberrypi.com/mirrors.aliyun.com\/raspbian/g' /etc/apt/sources.list
  sudo sed -i 's/raspbian.raspberrypi.com/mirrors.tuna.tsinghua.edu.cn\/raspbian/g' /etc/apt/sources.list 
  sudo apt update
  ```
  ```
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/      bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list 
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ bookworm main                                   " > /etc/apt/sources.list.d/raspi.list 
  ```
* Pip source
  ```
  pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  ```
* [non-interactive raspi-config](https://www.raspberrypi.com/documentation/computers/configuration.html#raspi-config-cli)
  ```
  sudo raspi-config nonint do_i2c         0      # enable I2C
  sudo raspi-config nonint do_serial_hw   0      # enable serial port  
  sudo raspi-config nonint do_serial_cons 1      # disable console over serial port
  ```
* jupyter
  ```
  mkdir -p ~/.jupyter/
  cat << EOF >  ~/.jupyter/jupyter_notebook_config.py
  c.ServerApp.ip = '0.0.0.0'
  c.ServerApp.token = ''
  c.ServerApp.password = ''
  #c.ServerApp.allow_root = True
  c.ServerApp.open_browser = False
  c.ServerApp.root_dir = '/var/www/html/test'
  EOF
  ```
* Additional WIFI Config
  ```
  cat << EOF | sudo tee /tmp/raspbian_os_sys/etc/NetworkManager/system-connections/wifi123.nmconnection
  [connection]
  id=$YOUR_SSID
  type=wifi
  interface-name=wlan0
  autoconnect=true
  
  [wifi]
  mode=infrastructure
  ssid=$YOUR_SSID
  
  [wifi-security]
  auth-alg=open
  key-mgmt=wpa-psk
  psk=$YOUR_WIFI_PASSWORD
  
  [ipv4]
  method=auto
  
  [ipv6]
  method=auto
  EOF
  sudo chmod -R 600       /tmp/raspbian_os_sys/etc/NetworkManager/system-connections/wifi123.nmconnection 

  nmcli radio wifi off
  nmcli radio wifi on
  nmcli conn reload
  ```
### Library
* spidev
```
https://github.com/doceme/py-spidev
wget https://github.com/doceme/py-spidev/archive/refs/tags/v3.7.tar.gz
sudo apt install python3-dev # we need Python headers
python3 setup.py install
```