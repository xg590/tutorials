# Scripts to run proxy server

## setup.sh

```sh
mkdir /root/proxy
echo $SSH_SERVER_IP


mkdir /root/proxy/

cat << EOF > /root/proxy/setup.sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf

##### Protect the local machine with firewall #####

iptables -A INPUT -i ppp$LOCAL_ID -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -i ppp$LOCAL_ID -j DROP 

##### Proxy #####

## keep remote proxy server in routing table
ip route add ${SSH_SERVER_IP}/32 via ${GATEWAY_IP}

## We do not use "defaultroute replacedefaultroute" in the last command so our default routing table is intact.
pppd unit $LOCAL_ID updetach noauth silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd unit $REMOTE_ID nodetach notty noauth" ipparam vpn 10.0.0.$LOCAL_ID:10.0.0.$REMOTE_ID

## Let ${IKEv2_SUBNET} follow the new routing table src123
ip rule add from ${IKEv2_SUBNET} lookup src123

## A new default gateway will be set for table src123 so the traffic will pass proxy server via local ppp network interface
ip route add default via 10.0.0.$REMOTE_ID dev ppp$LOCAL_ID table src123

## MASQUERADE the network traffic from $IKEv2_SUBNET.
iptables -t nat -A POSTROUTING -s ${IKEv2_SUBNET} -o ppp$LOCAL_ID -j MASQUERADE 

##### LOG #####
echo "rule"; ip rule list lookup src123 ; sleep 0.1 ; echo "route" ; ip route show table src123
EOF

(crontab -l 2>/dev/null; echo "@reboot sleep 60 && sudo bash /root/proxy/setup.sh") | crontab -
```

## keep.sh

```sh
cat << EOF > /root/proxy/keep.sh
#!/bin/bash
newConn() {
  echo "[\$myIP] New Tunnel"
  ip link del ppp$LOCAL_ID
  pppd unit $LOCAL_ID updetach noauth silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd unit $REMOTE_ID nodetach notty noauth" ipparam vpn 10.0.0.$LOCAL_ID:10.0.0.$REMOTE_ID
  ip route add default via 10.0.0.$REMOTE_ID dev ppp$LOCAL_ID table src123
}

while true 
do 
    table_src123_GW=\$(ip route show table src123 | wc -l)
    myIP=\$(curl --interface ppp$LOCAL_ID ipinfo.io/ip 2>/dev/null)
    nc -z localhost 1080

    if [ "\$?" == 1 ]; then
        echo "1080 port is closed";
        newConn
    elif [ "\$myIP" != "$SSH_SERVER_IP" ]; then 
        echo "Add default GW for Route Table src123"
        newConn
    elif [ "\$table_src123_GW" == 0 ] ; then
        echo "Add new routing table";
        newConn
    else
        echo "[\$myIP] Old Tunnel"
    fi
    sleep 180
done
EOF
```
