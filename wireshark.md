tcpdump -nn dst 192.168.0.xxx and src 192.168.1.xxx  -w -| nc -l -s 127.0.0.1 -p 12345 
wireshark -k -i <(tcpdump -nn dst xxx.xxx.xxx.xxx -w -) 
