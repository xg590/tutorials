### Network Manager <a name="nmcli"></a>
On Ubuntu 20.04, the network is managed by Network Manager ([CLI](https://developer.gnome.org/NetworkManager/stable/nmcli.html)) by default. <b>IT SUCKS!!!</b>. 
* Show current connection
```
  nmcli connection show
```
* Show available SSID
```
  nmcli dev wifi
  nmcli dev wifi list ifname wlx40a5ef5a28b8
```
* Add a connection (Quotation mark is required)
```
  nmcli dev wifi con "SSID" password "PASSWORD" name "ALIAS"
  nmcli dev wifi con "ustc_vpn" password "xxx" ifname wlx40a5ef5a28b8 name "usbWiFi"
```
* Connect/disconnect
```
  nmcli con up/down "ALIAS"
  nmcli dev connect enp5s0
```
* Modify a connection <a name="ubuntu-static-ip"></a>
```
  sudo nmcli conn edit "Wired connection 1" 
  nmcli> set ipv4.method manual
  nmcli> set ipv4.addresses 192.168.0.123/24
  nmcli> set ipv4.gateway 192.168.0.1
  nmcli> set ipv4.dns 8.8.8.8 8.8.4.4
  nmcli> save persistent
  nmcli> quit
  
  sudo nmcli conn mod  "Wired connection 1" ipv4.method manual ipv4.addr "192.168.0.123/24" ipv4.gateway 192.168.0.1 ipv4.route-metric 200 ipv4.dns 8.8.8.8
```
* Disable WIFI
```
nmcli radio wifi off
nmcli r     all  off # turn on airplane mode
```
* Add Route 
```
nmcli connection modify enp1s0 +ipv4.routes "192.168.122.0/24 10.10.10.1"
```
* Change DNS 
```
nmcli conn mod <connectionName> ipv4.dns "8.8.8.8 8.8.4.4"   # Permanent
resolvectl dns interface_name 8.8.8.8 8.8.4.4                # Temporary 
``` 
* Bring down NIC
```
nmcli device disconnect $IFNAME2; wait ; nmcli device connect $IFNAME2
```
* Delete
```
nmcli conn delete '有线连接 3'
```
* Reload 
```
nmcli conn reload
```
* Mess with metric
```
nmcli conn mod <connectionName> ipv4.route-metric 50
```
* Add new conn
```
nmcli conn add type ethernet con-name lan0 ifname ens3
```
#### Let NetworkManager configure new NICs automatically
* See the current conf
```sh

nmcli -f NAME,AUTOCONNECT connection show
```
* Let's make it happen
```sh
cat << EOF | sudo tee /etc/NetworkManager/conf.d/Auto.conf
[main]
no-auto-default=
EOF
sudo systemctl restart NetworkManager
```