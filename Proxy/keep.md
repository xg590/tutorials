* Scripts to run proxy server
```
mkdir /root/proxy
SSH_SERVER_IP=x.x.x.x 

cat << EOF > /root/proxy/setup.sh
#!/bin/bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf
#ip route add 144.34.187.127/32 via 192.168.1.1
ip route add $SSH_SERVER_IP/32  via 192.168.1.1

iptables -A INPUT -i ppp321 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i ppp321 -j DROP
iptables -t nat -A POSTROUTING -s 40.0.0.0/24      -o ppp321 -j MASQUERADE 
iptables -t nat -A POSTROUTING -s 192.168.3.10/32  -o enp1s0 -j MASQUERADE 
iptables -t nat -A POSTROUTING -s 192.168.3.20/32  -o enp1s0 -j MASQUERADE 
iptables -t nat -A POSTROUTING -s 192.168.3.30/32  -o ppp321 -j MASQUERADE 
iptables -t nat -A POSTROUTING -s 192.168.3.40/32  -o ppp321 -j MASQUERADE 
iptables -t nat -A POSTROUTING -s 192.168.3.128/25 -o enp1s0 -j MASQUERADE 

ip rule add from 40.0.0.0/24 lookup KR
ip rule add from 192.168.3.30/32 lookup KR # ASUS Router
ip rule add from 192.168.3.40/32 lookup KR
#ipsec start
EOF

cat << EOF > /root/proxy/keep.sh
#!/bin/bash
newConn() {
  echo "[$myIP] New Tunnel"
  ip link del ppp321
  pppd updetach noauth unit 321 silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd nodetach notty noauth unit 123" ipparam vpn 10.0.0.3:10.0.0.4
  ip route add default via 10.0.0.4 dev ppp321 table KR
}

while true 
do 
    tableKR_GW=$(ip route show table KR | wc -l)
    myIP=$(curl --interface ppp321 ipinfo.io/ip 2>/dev/null)
    nc -z 192.168.3.3 1080

    if [ "$?" == 1 ]; then
        echo "1080 port is closed";
        newConn
    elif [ "$myIP" != "$SSH_SERVER_IP" ]; then 
        echo "Add default GW for Route Table KR"
        newConn
    elif [ "$tableKR_GW" == 0 ] ; then
        echo "Add new routing table";
        newConn
    else
        echo "[$myIP] Old Tunnel"
    fi
    sleep 180
done
EOF
```