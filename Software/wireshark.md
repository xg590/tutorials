### Wireshark
#### WI-FI sniffer
* Drirver of BCM4345/6 (Raspberry Pi's on-board WiFI chip) does not support "Monitor Mode". 
* A third-party WiFi Dangle RT5370 is needed. 
* Put the network interface in "Monitor Mode"
```
# On Raspberry Pi
sudo apt-get update && sudo apt-get install iw tcpdump
iw dev 
nic=wlan1 # RT5370
sudo ip link set $nic down
sudo iw $nic set type monitor
sudo ip link set $nic up 
iw dev
```
* Run [tcpdump](https://www.tcpdump.org/manpages/tcpdump.1.html) to capture wireless packets and forward it via [netcat](https://linuxcommandlibrary.com/man/netcat) on Raspberry Pi 
```shell
# tcpdump 
#   -n     Don’t convert host addresses to names.  This can be used to avoid DNS lookups. 
#   -nn    Don’t convert protocol and port numbers etc. to names either.  
#   -U     No buffer mode for the real-time analysis. Output message immediately.  
#   -w     Set the default capture file name, or '-' for standard output. 
#   port   A filter
sudo tcpdump -i $nic -nn -U -w - | nc -l 0.0.0.0 45454
```
* On a Linux PC  
```
sudo apt install wireshark ### Allow non-root user to capture packet.
sudo usermod -a -G wireshark $USER 
newgrp wireshark
wireshark -k -i TCP@192.168.x.x:45454
```
* On a Windows PC 
```
CMD F:\>            Programs\WiresharkPortable64\WiresharkPortable64.exe -k -i TCP@192.168.x.x:45454
ShortCut Target: F:\Programs\WiresharkPortable64\WiresharkPortable64.exe -k -i TCP@192.168.x.x:45454
```
* Wireshark filter
```
ip.dst_host == 192.168.x.123 && tcp.port == 8266 && websocket
wlan.fc.type_subtype == 0x0008 # beacon frame
```
* Restore
```
nic=wlan1 # RT5370
sudo ip link set $nic down 
sudo iw $nic set type managed
sudo ip link set $nic up 
```
#### USB sniffer / USBPcapCMD
* Filter for 
```
usb.device_address==8 and usb.capdata
```