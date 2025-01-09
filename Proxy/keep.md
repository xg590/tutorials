* Scripts to run proxy server
```
mkdir /root/proxy
SSH_SERVER_IP=x.x.x.x 

cat << EOF > /root/proxy/setup.sh
#!/bin/bash
iptables -A INPUT -i ppp789 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -i ppp789 -j DROP 
iptables -t nat -A POSTROUTING -s 40.0.0.0/24 -o ppp789 -j MASQUERADE # MASQUERADE the network traffic from 40.0.0.0/24.

ip route add $SSH_SERVER_IP/32 via 192.168.3.1
pppd unit 789 updetach noauth silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd unit 987 nodetach notty noauth" ipparam vpn 10.0.0.7:10.0.0.9

# We do not use "defaultroute replacedefaultroute" in the last command so our default routing table is intact.
# Let 40.0.0.0/24 follow the new routing table src123 
ip rule  add from     40.0.0.0/24       lookup src123
# A new default gateway will be set
ip route add default via 10.0.0.7 dev ppp789 table src123
EOF

cat << EOF > /root/proxy/keep.sh
while true
do
    table_src123_GW=$(ip route show table src123 | wc -l)
    if [ $table_src123_GW == 0 ]; then 
	echo "Add default GW for Route Table src123"
        ip route add default via 10.0.0.7 dev ppp789 table src123
    fi

    myIP1=\$(curl --interface       ppp789         ipinfo.io/ip 2>/dev/null)
    myIP2=\$(curl --socks5-hostname 127.0.0.1:1080 ipinfo.io/ip 2>/dev/null)
    if [ "\$myIP" != "$SSH_SERVER_IP" ]; then 
        echo "[\$myIP] New Tunnel"
	    ip link del ppp789 
        pppd updetach noauth unit 789 silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd nodetach notty noauth unit 987" ipparam vpn 10.0.0.7:10.0.0.9
        # ip route add default dev ppp789 metric 99 / ip route del default dev ppp789 
        ip route add default dev ppp789 table src123
    else
        echo "[\$myIP] Old Tunnel"
    fi
    sleep 60
done
EOF
```
