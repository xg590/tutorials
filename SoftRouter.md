## Make a Soft Router
### Situation
* I have a Linux PC (NUC) with one wired NIC (eth0) and one wireless NIC (wlan0). 
* I will add an addtional WiFi adapter (wlan1) so the built-in wireless NIC will be used to join an existing 5GHz WiFi network and the plug-in one will create another 2.4GHz WiFi network.
* I can capture packets over wireless network for analysis 
### What will the Router do
* Layer 2 switching: forward frames among NUC and connected devices (clients).
* Layer 3 routing and IP management: serve NAT and DHCP services
### Hostapd: Layer 2 Wireless Switching
* Install hostapd but I saw hostapd failed to start. 
* When "journalctl -xe", I found "hostapd.service: Failed to schedule restart job: Unit hostapd.service is masked"
```
sudo apt install hostapd
```
* Let configure it first 
```
sudo tee /etc/hostapd/hostapd.conf << EOF >/dev/null 
# the interface used by the AP
interface=wlan1 
# "g" means 802.11g
hw_mode=g
# turn on 802.11n support
ieee80211n=1   
# the channel to use
channel=1
# QoS support, also required for full speed on 802.11n/ac/ax
wmm_enabled=1 
# the name of the AP
ssid=myAP
# algorithm: {1:wpa, 2:wep, 3:both}
auth_algs=1
# WPA2 only
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
wpa_passphrase=myPassword
EOF
```
* Unmask and start hostapd
* Now I got my new AP
```
sudo systemctl unmask hostapd
sudo systemctl start hostapd
```
* At this most, the new WiFi network is establised. 
* Client can join the new WiFi but will not get network configuration automatically.
* I can manually set IP for a connected device and the Linux PC, and do a Ping test.
### IP management
* Bind IP to Wireless NIC
```
sudo ip addr add 192.168.3.3/24 dev wlan1
```
* I then use a iPad connected to myAP and set ip 192.168.3.4 for iPad manually. 
* Then pinging iPad from 192.168.3.3 is successful. 
* Setup the DHCP service so iPhone will get ip upon joining the network.
```
sudo apt install isc-dhcp-server
sudo tee /etc/dhcp/dhcpd.conf << EOF >/dev/null  
default-lease-time 600;
max-lease-time 7200;

subnet 192.168.3.0 netmask 255.255.255.0 {
 range 192.168.3.100 192.168.3.200;
 option routers 192.168.3.3;
 option domain-name-servers 8.8.8.8, 8.8.4.4; 
}
EOF
sudo tee /etc/default/isc-dhcp-server << EOF >/dev/null # specify the interfaces dhcpd should listen to.
INTERFACESv4="wlan1"
EOF
sudo systemctl restart isc-dhcp-server.service
```
* OK, now my connected device get configured automatically.
### NAT
* Allow forward and routing packet from clients to the internet. [Here is wlan0 instead of wlan1]
```
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward >/dev/null
sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o wlan0 -j MASQUERADE
```
