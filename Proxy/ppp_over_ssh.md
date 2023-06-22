### Point-to-Point Protocol over SSH 
* MASQUERADE the traffic on remote machine
* Create ppp0 network interfaces on Local Ubuntu Machine and Remote Ubuntu Machine (ip 4.5.6.7), link them together via a SSH tunnel, and replace the default route. (We need the root privilege on either machine and use SSH public key authentication method) 
#### Remote Machine
```
sudo su
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
server_ip=4.5.6.7
mkdir /root/.ssh
cat << EOF >> /root/.ssh/config

Host proxy
    Hostname $server_ip
    User root
    Identityfile ~/.ssh/prvtkey
    TCPKeepAlive yes
    ServerAliveCountMax 1
    ServerAliveInterval 5
EOF
echo "nameserver 8.8.8.8" > /etc/resolv.conf
ip route add $server_ip/32 via 10.0.2.2
pppd updetach noauth silent nodeflate defaultroute replacedefaultroute pty "/usr/bin/ssh proxy /usr/sbin/pppd nodetach notty noauth" ipparam vpn 10.0.0.1:10.0.0.2
```
#### Bring All Things Down
* Simply delete one ppp0 of either side
```
ip link del ppp0
```