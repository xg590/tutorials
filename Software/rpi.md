Visit [this page](https://mirrors4.tuna.tsinghua.edu.cn/raspberry-pi-os-images/) from Tsinghua Univ to download [2024-11-19-raspios-bookworm-armhf-lite.img.xz](https://mirrors4.tuna.tsinghua.edu.cn/raspberry-pi-os-images/raspios_lite_armhf/images/raspios_lite_armhf-2024-11-19/2024-11-19-raspios-bookworm-armhf-lite.img.xz)
```
wget 2024-11-19-raspios-bookworm-armhf-lite.img.xz
IMG=2024-11-19-raspios-bookworm-armhf-lite.img
YOUR_SSID=
YOUR_WIFI_PASSWORD=
KNOWN_KEYS="ssh-ed25519 xxx xxx"
xz -dk $IMG.xz 
mkdir /tmp/raspbian_os_boot
fdisk -l $IMG
sudo mount -o offset=$((8192*512)),umask=0002,uid=$UID $IMG /tmp/raspbian_os_boot 
touch        /tmp/raspbian_os_boot/ssh                  # Enable ssh server at first boot     
cat << EOF > /tmp/raspbian_os_boot/userconf.txt
pi:$(echo 'a' | openssl passwd -6 -stdin)
EOF
sudo umount /tmp/raspbian_os_boot
mkdir /tmp/raspbian_os_sys
sudo mount -o offset=$((1056768*512)) $IMG /tmp/raspbian_os_sys/
mkdir -p                                   /tmp/raspbian_os_sys/home/pi/.ssh 
echo $KNOWN_KEYS >                         /tmp/raspbian_os_sys/home/pi/.ssh/authorized_keys
chmod 600                                  /tmp/raspbian_os_sys/home/pi/.ssh/authorized_keys
chown -R 1000:1000                         /tmp/raspbian_os_sys/home/pi/.ssh/
cat << EOF | sudo tee /tmp/raspbian_os_sys/etc/ssh/sshd_config.d/new123.conf
PasswordAuthentication no
EOF
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
sudo chown -R root:root /tmp/raspbian_os_sys/etc/NetworkManager/system-connections/wifi123.nmconnection
cat                     /tmp/raspbian_os_sys/etc/NetworkManager/system-connections/wifi123.nmconnection
sudo umount             /tmp/raspbian_os_sys/
```
* Apt source
```
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/      bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list 
echo "deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ bookworm main                                   " > /etc/apt/sources.list.d/raspi.list 
```
* Pip source
```
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```
```
nmcli radio wifi off
nmcli radio wifi on
nmcli conn reload