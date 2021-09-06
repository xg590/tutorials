### Install 
```
sudo apt install wireshark ### Allow non-root user to capture packet.
sudo usermod -a -G wireshark $USER 
```
### Remote capture
```shell 
wireshark -k -i <(ssh piMachine "sudo tcpdump -i eth1 -nn -w - src 192.168.4.100")
``` 
