### Point-to-Point Protocol over SSH 
* Create ppp0 network interfaces on Local Ubuntu Machine and Remote Ubuntu Machine (ip 4.5.6.7), and link them together via a SSH tunnel. (We need to be root on either machine and use SSH public key authentication method)
* Route all traffic through the local ppp0 
* MASQUERADE the traffic on remote machine
#### Remote Machine
```
echo "PermitRootLogin yes" > /etc/ssh/sshd_config
systemctl restart sshd  
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE 
```
#### Local Machine
```
sudo su
host myProxyServer123.com # Get ip of remote machine
mkdir /root/.ssh
cat << EOF >> /root/.ssh/config

Host proxy
    Hostname 4.5.6.7
    User root
    Identityfile ~/.ssh/prvtkey
    TCPKeepAlive yes
    ServerAliveCountMax 1
    ServerAliveInterval 5
EOF
echo "nameserver 8.8.8.8" > /etc/resolv.conf
pppd updetach noauth silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd nodetach notty noauth" ipparam vpn 10.0.0.1:10.0.0.2
ip route add 4.5.6.7/32 via 10.0.2.2
ip route replace default dev ppp0 

echo 1 > /proc/sys/net/ipv4/ip_forward 
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o ppp0 -j MASQUERADE 
```
#### Bring All Things Down
* Simply delete one ppp0 of either side
```
ip link del ppp0
```