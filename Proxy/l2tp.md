* Prerequisite
```
cat << EOF > /etc/l2tp.conf
export CONNECTION_NAME=l2tp_123
export VPN_SERVER_IP=x.x.x.x
export YOUR_PSK=ustc # Pre-shared key
export YOUR_USERNAME=xxx
export YOUR_PASSWORD=xxx
EOF
chmod 600 /etc/l2tp.conf
source    /etc/l2tp.conf
apt install -y network-manager-l2tp  
```
* Configure VPN via nmcli
```
nmcli connection add type vpn vpn-type l2tp  \
  connection.autoconnect false               \
  con-name    ${CONNECTION_NAME}             \
  vpn.data    "gateway=${VPN_SERVER_IP}"     \
  vpn.secrets "ipsec-psk=${YOUR_PSK}"        \
 +vpn.data    "user=${YOUR_USERNAME}"        \
 +vpn.secrets "password=${YOUR_PASSWORD}"    \
 +vpn.data    "ipsec-enabled=yes"            \
 +vpn.data    "lcp-echo-failure=5"           \
 +vpn.data    "lcp-echo-interval=30"         \
 +vpn.data    "machine-auth-type=psk"        \
 +vpn.data    "password-flags=0"             \
 +vpn.data    "user-auth-type=password"      \
  vpn.service-type "org.freedesktop.NetworkManager.l2tp"

nmcli connection up ${CONNECTION_NAME}

# (crontab -l ; echo "@reboot root sleep 30 && nmcli connection up ${CONNECTION_NAME}") | crontab -
echo "@reboot root sleep 30 && nmcli connection up ${CONNECTION_NAME}" > /etc/cron.d/l2tp_autoconnect     
```
* Forward
```
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf
cat /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 172.22.128.1/16 -o ppp0 -j MASQUERADE
```
* Bring the VPN down
```
nmcli connection down ${CONNECTION_NAME}   
```
* nmcli in one line
```
nmcli connection add type vpn vpn-type l2tp con-name ${CONNECTION_NAME} connection.autoconnect false vpn.data "gateway=${VPN_SERVER_IP}, ipsec-enabled=yes, lcp-echo-failure=5, lcp-echo-interval=30, machine-auth-type=psk, password-flags=0, user=${YOUR_USERNAME}, user-auth-type=password" vpn.secrets "ipsec-psk=${YOUR_PSK}, password=${YOUR_PASSWORD}"
```
* To enable VPN Connection Editor
```
sudo apt install -y network-manager-l2tp-gnome
```