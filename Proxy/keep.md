* Scripts to run proxy server
```
mkdir /root/proxy
PROXY_IP=xxx.xxx.xxx.xx 

cat << EOF > /root/proxy/setup.sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf
ip route add $PROXY_IP/32 via 192.168.3.1
ip rule add from 40.0.0.0/24 lookup KR
iptables -A INPUT -i ppp987 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i ppp987 -j DROP
iptables -t nat -A POSTROUTING -s 40.0.0.0/24 -o ppp987 -j MASQUERADE
EOF

cat << EOF > /root/proxy/keep.sh
while true
do
    myIP=\$(curl --interface ppp987 ipinfo.io/ip 2>/dev/null)
    if [ "\$myIP" != "$PROXY_IP" ]; then 
        echo "[\$myIP] New Tunnel"
	    pppd updetach noauth unit 987 silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd nodetach notty noauth unit 789" ipparam vpn 10.0.0.7:10.0.0.9
	    # ip route add default dev ppp987 metric 99 / ip route del default dev ppp987 
        ip route add default dev ppp987 table KR
    else
        echo "[\$myIP] Old Tunnel"
    fi
    sleep 60
done
EOF
```
