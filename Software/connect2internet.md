### Connect to WiFi via wpa_supplicant (Ubuntu Server 22043)
1. Make sure wpa_supplicant is running
```
systemctl status wpa_supplicant 
ip addr
```
2. Add configuration file
```
wpa_passphrase essid_wifi_name wifi_password > /tmp/wpa_supplicant.conf
```
3. Connect to the wifi
```
wpa_supplicant -c /tmp/wpa_supplicant.conf -i nic_name_like_eth0
```
4. Run wpa_supplicant in the background
```
wpa_supplicant -c /tmp/wpa_supplicant.conf -i nic_name_like_eth0 -B
```
5. Use DHCP client to get IP address
```
dhclient nic_name_like_eth0
ip addr
```
### Connect to Ethernet via systemd (Ubuntu Server 22043)
* Enable DHCP function
```
systemctl status systemd-networkd # check if necessary
cat << EOF > /etc/systemd/network/81-dhcp.network
[Match]
Name=en*

[Network]
DHCP=yes
EOF
```