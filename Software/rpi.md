IMG=2024-03-15-raspios-bookworm-armhf-lite.img
YOUR_SSID=
YOUR_WIFI_PASSWORD=
KNOWN_KEYS="ssh-ed25519"
xz -dk $IMG.xz 
mkdir /tmp/raspbian_os_boot
sudo mount -o offset=$((8192*512)),umask=0002,uid=$UID $IMG /tmp/raspbian_os_boot 
touch        /tmp/raspbian_os_boot/ssh                  # Enable ssh server at first boot     
cat << EOF > /tmp/raspbian_os_boot/userconf.txt
pi:$(echo 'raspberry' | openssl passwd -6 -stdin)
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
sudo umount /tmp/raspbian_os_sys/