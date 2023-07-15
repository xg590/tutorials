### Open Source Mirror In China  
* Get Raspbian OS Images from [Aliyun](https://mirrors.aliyun.com/raspberry-pi-os-images/raspios_armhf/images/) 
* apt src
  ```
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak_`date "+%y_%m_%d"`
  sudo sed -i 's/raspbian.raspberrypi.org/mirrors.aliyun.com\/raspbian/g' /etc/apt/sources.list
  sudo apt update
  ```
* pip src
  ```
  pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  ```  
### Modify Raspbian image on Ubuntu  
* Download a Raspbian OS image
  ```
  img=2022-09-06-raspios-bullseye-armhf-lite.img
  xz -dk $img.xz
  ```  
* Get offset 
  * startsector of boot partition begins at 8192
  * offset is 8192 * 512 byte/sector
  ```
  $ fdisk -l $img
  Disk 2022-09-06-raspios-bullseye-armhf-lite.img: 1.75 GiB, 1874853888 bytes, 3661824 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disklabel type: dos
  Disk identifier: 0xac1488a6
  
  Device                                      Boot  Start     End Sectors  Size Id Type
  2022-09-06-raspios-bullseye-armhf-lite.img1        8192  532479  524288  256M  c W95 FAT32 (LBA)
  2022-09-06-raspios-bullseye-armhf-lite.img2      532480 3661823 3129344  1.5G 83 Linux
  ```
* Mount boot partition (First partition is FAT32 and it support uid when mount) / [Ref](https://www.raspberrypi.com/news/raspberry-pi-bullseye-update-april-2022/)
  ```
  mkdir /tmp/raspbian_os_boot
  sudo mount -o offset=$((8192*512)),umask=0002,uid=$UID $img /tmp/raspbian_os_boot
  touch        /tmp/raspbian_os_boot/ssh                  # Enable ssh server at first boot    
  cat << EOF > /tmp/raspbian_os_boot/wpa_supplicant.conf  # Join WiFi network
  ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
  country=US
  update_config=1
  network={
      ssid="YOUR_SSID"
      psk="YOUR_WIFI_PASSWORD"
      key_mgmt=WPA-PSK
  }
  EOF
  cat << EOF > /tmp/raspbian_os_boot/userconf.txt
  pi:$(echo 'raspberry' | openssl passwd -6 -stdin)
  EOF
  sudo umount /tmp/raspbian_os_boot
  ```
* Mount system partition (Second partition is EXT4 format)
  ```
  mkdir /tmp/raspbian_os_sys
  sudo mount -o offset=$((532480*512)) $img /tmp/raspbian_os_sys/
  mkdir -p                                        /tmp/raspbian_os_sys/home/pi/.ssh
  ssh-keygen -t rsa -b 4096 -N '' -C '' -f        /tmp/raspbian_os_sys/home/pi/.ssh/id_rsa
  cp /tmp/raspbian_os_sys/home/pi/.ssh/id_rsa.pub /tmp/raspbian_os_sys/home/pi/.ssh/authorized_keys
  chown -R 1000:1000                              /tmp/raspbian_os_sys/home/pi/.ssh/

  cat               << EOF >>                     /tmp/raspbian_os_sys/etc/ssh/sshd_config
  PermitRootLogin prohibit-password
  PasswordAuthentication no
  PubkeyAuthentication yes
  EOF
  sudo umount                                     /tmp/raspbian_os_sys/
  ```
### Ethernet to WiFi
* Dismiss Pi as a STA Station
  ```
  mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.bak
  reboot
  ```
* AP
  ```  
  sudo apt install -y hostapd 
  sudo tee /etc/hostapd/hostapd.conf << EOF > /dev/null  
  interface=wlan0
  hw_mode=g
  ieee80211n=1
  channel=1
  wmm_enabled=1
  auth_algs=1
  wpa=2
  wpa_key_mgmt=WPA-PSK
  wpa_pairwise=TKIP
  rsn_pairwise=CCMP
  ssid=myAP
  wpa_passphrase=myPassword
  EOF
  sudo systemctl disable hostapd
  sudo systemctl unmask hostapd
  sudo systemctl start hostapd
  ```
* DHCP
  ```
  sudo ip addr add 192.168.3.3/24 dev wlan0 
  cat << EOF >> /etc/dhcpcd.conf # This is config file for dhcp client 
  interface wlan0
  static ip_address=192.168.3.3/24 
  EOF

  sudo apt install -y isc-dhcp-server
  sudo tee /etc/dhcp/dhcpd.conf << EOF > /dev/null  
  default-lease-time 600;
  max-lease-time 7200;
  
  subnet 192.168.3.0 netmask 255.255.255.0 {
    range 192.168.3.100 192.168.3.200;
    option routers 192.168.3.3;
    option domain-name-servers 8.8.8.8, 8.8.4.4; 
  }
  EOF

  sudo tee /etc/default/isc-dhcp-server << EOF > /dev/null # specify the interfaces   dhcpd should listen to.
  INTERFACESv4="wlan0"
  EOF

  sed -i "14a sleep 30" /etc/init.d/isc-dhcp-server # Delay the start of service isc-dhcp-server 

  sudo systemctl disable isc-dhcp-server.service
  sudo systemctl restart isc-dhcp-server.service
  dhcp-lease-list
  ```
* SNAT
  ```
  sudo tee /etc/sysctl.d/forward123.conf << EOF > /dev/null
  net.ipv4.ip_forward = 1
  EOF
  sudo sysctl --system
  sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o eth0 -j MASQUERADE
  ```
* Cron
  ```
  (crontab -l 2>/dev/null; echo "@reboot sleep 60 && sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o eth0 -j MASQUERADE") | crontab -
  ```
### WiFi to Ethernet
* DHCP
  ```
  sudo ip addr add 192.168.3.3/24 dev eth0 
  cat << EOF >> /etc/dhcpcd.conf # This is config file for dhcp client 
  interface eth0
  static ip_address=192.168.3.3/24 
  EOF

  sudo apt install -y isc-dhcp-server
  sudo tee /etc/dhcp/dhcpd.conf << EOF > /dev/null  
  default-lease-time 600;
  max-lease-time 7200;
  
  subnet 192.168.3.0 netmask 255.255.255.0 {
    range 192.168.3.100 192.168.3.200;
    option routers 192.168.3.3;
    option domain-name-servers 8.8.8.8, 8.8.4.4; 
  }
  EOF

  sudo tee /etc/default/isc-dhcp-server << EOF > /dev/null # specify the interfaces   dhcpd should listen to.
  INTERFACESv4="eth0"
  EOF

  sudo sed -i "14a sleep 30" /etc/init.d/isc-dhcp-server # Delay the start of service isc-dhcp-server 

  sudo systemctl restart isc-dhcp-server.service
  dhcp-lease-list
  ```
* SNAT
  ```
  sudo tee /etc/sysctl.d/forward123.conf << EOF > /dev/null
  net.ipv4.ip_forward = 1
  EOF
  sudo sysctl --system
  sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o wlan0 -j MASQUERADE
  ```
* Cron
  ```
  (crontab -l 2>/dev/null; echo "@reboot sleep 60 && sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o wlan0 -j MASQUERADE") | crontab -
  ```