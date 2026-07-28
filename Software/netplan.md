```sh
cat /etc/netplan/wlan0.yaml 
network:
  version: 2
  wifis:
    NM-xxx:
      renderer: NetworkManager
      match:
        name: "wlan0"
      dhcp4: true
      dhcp6: true
      routes:
        - to: 192.168.23.3/32
          via: 192.168.88.1
          on-link: true
```