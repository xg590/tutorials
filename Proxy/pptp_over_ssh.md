### PPTP over SSH
* The SSH server (1.2.3.4) can be accessed with authorized_keys on the local machine (192.168.1.2). 
* 192.168.1.1 is the ip of local network.
```
export SSH_SERVER_IP=1.2.3.4
export GATEWAY_IP=192.168.3.1 

echo $SSH_SERVER_IP $GATEWAY_IP
```
#### Login the remote SSH server and configure it for proxy purpose.
* Root privilege on both machines and public key authentication (SSH) are required
```
cat << EOF > /etc/ssh/sshd_config.d/proxy123.conf
PermitRootLogin yes
PermitTunnel yes
EOF

cat << EOF > /etc/sysctl.d/forward123.conf
net.ipv4.ip_forward = 1
EOF

iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE

systemctl restart sshd
sysctl --system
```
#### Configure the local machine 
```
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
* In one command, we will create one ppp789 network interface (10.0.0.7) on local machine, create another ppp987 interface (10.0.0.9) on remote SSH Machine, link two ppp interfaces together via a SSH tunnel, and replace the default route (via gateway_ip 192.168.1.1) on local Ubuntu machine.
```
ip route add ${SSH_SERVER_IP}/32 via ${GATEWAY_IP}
pppd unit 789 updetach noauth silent nodeflate defaultroute replacedefaultroute pty "/usr/bin/ssh proxy /usr/sbin/pppd unit 987 nodetach notty noauth" ipparam vpn 10.0.0.7:10.0.0.9
```
* Now all traffic on the local machine is routed through SSH server
#### Bring All Things Down 
```
ip link del ppp789 # Simply delete one ppp on either side
```
#### Forward traffic from LAN
* [Create](./ikev2.md) a IKEv2 VPN server on the local machine so that machines in the LAN can login and hide in $IKEv2_SUBNET (40.0.0.0/24) behind the local machine.
* Configure the local machine so it will allow the traffic forwarding.
```
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf
sysctl --system
```
* Create a new routing table so a new default gateway can be set for it. We can then add a rule so the IKEv2 subnet will follow the new routing table.
```
echo -e "200 src123" > /etc/iproute2/rt_tables.d/new123.conf # Policy Routing 
```
* Setup everything else.
```
cat << EOF > /root/proxy/setup.sh
# Protect the local machine
iptables -A INPUT -i ppp789 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -i ppp789 -j DROP 
iptables -t nat -A POSTROUTING -s ${IKEv2_SUBNET} -o ppp789 -j MASQUERADE # MASQUERADE the network traffic from $IKEv2_SUBNET.

ip route add ${SSH_SERVER_IP}/32 via ${GATEWAY_IP}
pppd unit 789 updetach noauth silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd unit 987 nodetach notty noauth" ipparam vpn 10.0.0.7:10.0.0.9

# We do not use "defaultroute replacedefaultroute" in the last command so our default routing table is intact.

# Let ${IKEv2_SUBNET} follow the new routing table src123 
ip rule  add from     ${IKEv2_SUBNET}       lookup src123

# A new default gateway will be set
ip route add default via 10.0.0.9 dev ppp789 table src123

echo "rule"; ip rule list lookup src123 ; sleep 0.1 ; echo "route" ; ip route show table src123
EOF

(crontab -l 2>/dev/null; echo "@reboot sleep 60 && sudo bash /root/proxy/setup.sh") | crontab -
```  