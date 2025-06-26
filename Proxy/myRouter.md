### myRouter
* I have a Linux machine (Raspberry Pi) and an AP so I can make a transparent proxy router for my other devices (like Oculus 2 VR goggle)
* Every setting is ephemeral except this. Delete /etc/systemd/network/disable-dhcp-for-IFNAME1.network if you want DHCP back
  ```
  cat << EOF > /etc/systemd/network/disable-dhcp-for-IFNAME1.network
  [Match]
  Name=$IFNAME1

  [Network]
  DHCP=no"
  EOF
  sudo systemctl restart systemd-networkd
  ```
#### Router First
* Env variables
    ```
    sudo su
    cat << EOF >> ~/.bashrc 
    export IFNAME0=wlan0 # connect to existing network
    export IFNAME1=eth0  # connect to AP. 
    EOF
    source ~/.bashrc
    echo $IFNAME0 $IFNAME1
    ```
* Configure an ephemeral IP for eth0
  ```
  ip addr add 192.168.3.1/24 dev $IFNAME1 
  ```
* Configure an ephemeral rule in kernel for packet forward
  ```
  echo 1 > /proc/sys/net/ipv4/ip_forward
  ```
* Configure an firewall rule for packet forward 
  ``` 
  iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o $IFNAME0 -j MASQUERADE     # iptables -P FORWARD ACCEPT
  ```
* Configure DHCP service
  ```
  apt update -y && apt install -y dnsmasq && systemctl disable dnsmasq
  
  cat << EOF > /etc/dnsmasq.conf
  bind-interfaces 
  interface=$IFNAME1
  dhcp-range=$IFNAME1,192.168.3.100,192.168.3.200,255.255.255.0,6h
  
  # dhcp-option https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
  dhcp-option=$IFNAME1,3,192.168.3.1  
  dhcp-option=$IFNAME1,6,8.8.8.8,8.8.4.4       # DHCP Option 6 (Primary DNS Server) 
  EOF

  systemctl start dnsmasq
  ```
* Check if DHCP is working
  ``` 
  systemctl status dnsmasq
  # journalctl -u dnsmasq -f 
  cat /var/lib/misc/dnsmasq.leases 
  ```
* Optional: Persistence
  ```
  echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf  
  nmcli connection add type ethernet con-name myRouter ip4 192.168.3.1/24 ifname $IFNAME1
  systemctl enable dnsmasq
  ```
* After Reboot
  ```
  ip addr add 192.168.3.1/24 dev $IFNAME1 
  echo 1 > /proc/sys/net/ipv4/ip_forward
  systemctl start dnsmasq
  # journalctl -u dnsmasq -f 
  cat /var/lib/misc/dnsmasq.leases

  iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o $IFNAME0 -j MASQUERADE     # iptables -P FORWARD ACCEPT
  ```

#### Proxy Second
* Configure
  ```
  cat << EOF >> ~/.bashrc
  export SSH_SERVER_IP=XX.XX.XX.XX
  export GATEWAY_IP=YY.YY.YY.YY      # IP of IFNAME0
  EOF
  echo $SSH_SERVER_IP $GATEWAY_IP
  
  mkdir /root/.ssh/
  cat << EOF > /root/.ssh/config
  Host proxy
    Hostname $SSH_SERVER_IP
    User root
    TCPKeepAlive yes
    ServerAliveCountMax 1
    ServerAliveInterval 5
  EOF
  ```
* After Reboot
  ```
  systemctl restart systemd-networkd # stop dhcp
  echo $SSH_SERVER_IP $GATEWAY_IP
  ip addr add 192.168.3.1/24 dev $IFNAME1
  ip addr
  echo 1 > /proc/sys/net/ipv4/ip_forward
  systemctl start dnsmasq && systemctl status dnsmasq

  iptables -P FORWARD ACCEPT
  iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o ppp456 -j MASQUERADE 

  ip route add ${SSH_SERVER_IP}/32 via $GATEWAY_IP
  pppd unit 456 updetach noauth silent nodeflate defaultroute replacedefaultroute pty "/usr/bin/ssh proxy /usr/sbin/pppd unit 654 nodetach notty noauth" ipparam vpn 10.0.0.5:10.0.0.6

  # journalctl -u dnsmasq -f 
  cat /var/lib/misc/dnsmasq.leases
  ```