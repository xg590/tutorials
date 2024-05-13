
### Network Manager <a name="nmcli"></a>
On Ubuntu 20.04, the network is managed by Network Manager ([CLI](https://developer.gnome.org/NetworkManager/stable/nmcli.html)) by default. <b>IT SUCKS!!!</b>. 
* Show current connection
```
  nmcli connection show
```
* Show available SSID
```
  nmcli dev wifi
```
* Add a connection (Quotation mark is required)
```
  nmcli dev wifi con "SSID" password "PASSWORD" name "ALIAS"
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
```
* Disable WIFI
```
nmcli radio wifi off
nmcli r     all  off # turn on airplane mode
```
* Change DNS 
```
nmcli conn mod <connectionName> ipv4.dns "8.8.8.8 8.8.4.4"   # Permanent
resolvectl dns interface_name 8.8.8.8 8.8.4.4                # Temporary 
``` 