## Point to Point Tunneling Protocol 
### Simple PPTP Server
```
apt-get install -y pptpd 
sudo tee /etc/pptpd.conf << EOF > /dev/null   
localip 20.0.0.1
remoteip 20.0.0.100-200
EOF

sudo tee /etc/ppp/pap-secrets << EOF > /dev/null
# Pick one pptp client authentication method (pap, chap, or ?)
# Any choice is as bad as others
# [username] [service] [plain-text password] [ip]  
username123 *         password321 *
username456 $HOSTNAME password654 * 
username789 $HOSTNAME password987 * 
EOF

sudo tee /etc/ppp/pptpd-options << EOF > /dev/null   
ms-dns 8.8.8.8
ms-dns 8.8.4.4
EOF

systemctl start pptpd  
```
### PPTP Client
```
cat << EOF > /etc/ppp/peers/pptp123
pty "pptp 192.168.1.2 --nolaunchpppd --debug"
name username456
password password654
remotename PPTP
noauth
debug
persist
maxfail 0
defaultroute
replacedefaultroute
usepeerdns
EOF

pon pptp123
```
### PPTP over SSH
#### Intro
  * Create one ppp0 network interface on local Ubuntu machine (local_ip 192.168.1.2) and one ppp0 interface on remote Ubuntu Machine (openssh_server_ip 4.5.6.7), link two ppp0 interfaces together via a SSH tunnel, and replace the default route (via gateway_ip 192.168.1.1) on local Ubuntu machine.
  * Root privilege on both machines and public key authentication (SSH) are required
  * The network traffic from local machine is MASQUERADEd on remote machine so the remote machine is a proxy server.
#### Remote Machine (proxy server)
```
sudo su
echo -e "#Proxy Server\nPermitRootLogin yes\nPermitTunnel yes" > /etc/ssh/sshd_config.d/proxy.conf
systemctl restart sshd
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf
sysctl --system
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE 
```
#### Local Machine
```
sudo su
host myProxyServer123.com # Get ip (4.5.6.7) of openssh server
openssh_server_ip=4.5.6.7
gateway_ip=192.168.1.1 # local gateway machine.
mkdir /root/.ssh
cat << EOF >> /root/.ssh/config

Host proxy
    Hostname $openssh_server_ip
    User root
    Identityfile ~/.ssh/prvtkey
    TCPKeepAlive yes
    ServerAliveCountMax 1
    ServerAliveInterval 5
    DynamicForward 0.0.0.0:1080
EOF

cat << EOF > /root/proxy.sh
#echo "nameserver 8.8.8.8" > /etc/resolv.conf
ip route add $openssh_server_ip/32 via $gateway_ip
pppd updetach noauth silent nodeflate defaultroute replacedefaultroute pty "/usr/bin/ssh proxy /usr/sbin/pppd nodetach notty noauth" ipparam vpn 10.0.0.1:10.0.0.2
iptables -t nat -A POSTROUTING -s 40.0.0.0/24 -o ppp0 -j MASQUERADE
iptables -A INPUT -i ppp0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i ppp0 -j DROP
EOF
```
#### Bring All Things Down 
```
ip link del ppp0 # Simply delete one ppp0 of either side
```
#### Raspbian OS as an internal server
```
openssh_server_ip=`host myProxyServer123.com | cut -f 4 -d\ `
gateway_ip="$(ip route | grep -P -o '(?<=default via )[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(?= dev)')" 
cat << EOF >> /home/pi/proxy.sh
ip route add $openssh_server_ip/32 via $gateway_ip
pppd updetach noauth silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd nodetach notty noauth" ipparam vpn 10.0.0.1:10.0.0.2
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o wlan0 -j MASQUERADE
EOF
(crontab -l 2>/dev/null; echo "@reboot sleep 60 && sudo bash /home/pi/proxy.sh") | crontab -
```
### Policy Routing and SNAT
* We need to both route and masquerade the packet so it will be forward to the destion with the src_ip  
``` 
pppd updetach noauth unit 654 silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd nodetach notty noauth unit 456" ipparam vpn 10.0.0.5:10.0.0.6 
ip rule add from 192.168.xxx.128/25 lookup src123
ip route add default via 10.0.0.5 dev ppp654 table src123
iptables -t nat -A POSTROUTING -s 192.168.xxx.128/25 -o ppp654 -j MASQUERADE
```
### Temporary forwarding or not forwarding all traffic from Local Machine to proxy server
* If we were not using "defaultroute replacedefaultroute" then our default gateway stays the same.
* We can configure the routing table mannully for a small period of time to forward all traffic from Local Machine to proxy server.
```
ip route add $openssh_server_ip/32 via $gateway_ip
ip route add default via 10.0.0.5 dev ppp654 
ip route del default via 10.0.0.5 dev ppp654 
```