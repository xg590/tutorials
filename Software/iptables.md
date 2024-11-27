/sbin/iptables-save    > /root/iptables.sav
sh -c '/sbin/iptables-restore < /root/iptables.sav'
/sbin/iptables-restore < /etc/iptables/rules.v4'



### [Policy Routing](https://superuser.com/a/1010516)
* Add a firewall rule to mark certain packets:
  ```
  iptables -t mangle -A PREROUTING -d 101.200.88.34 -j MARK --set-mark 456

  echo -e "200 src123" > /etc/iproute2/rt_tables.d/new123.conf # routing table identifier and table name
  ```
* Create a new routing table with your desired gateway:
  ```
  ip route add default via 192.168.26.1 dev enp2s0f3 table src123
  ip route show                                      table src123
  ```
* Add a policy rule to use the new routing table for marked packets:
  ```
  ip rule add fwmark 456 lookup src123
  ```


iptables -t mangle -D PREROUTING 1
cat /etc/iproute2/rt_tables.d/new123.conf
echo -e "200 src123" > /etc/iproute2/rt_tables.d/new123.conf
   XXX.XXX.XXX.XXX 22


curl --interface enp2s0f3 http://101.200.88.34:8888/
curl http://101.200.88.34:8888/

```

iptables -t raw -A OUTPUT -d 101.200.88.34 -j MARK --set-mark 0x1
iptables -A OUTPUT -d 101.200.88.34 -j MARK --set-mark 0x1
iptables -t mangle -A OUTPUT -d 101.200.88.34 -j MARK --set-mark 0x1
iptables -t nat -A OUTPUT -d 101.200.88.34 -j MARK --set-mark 0x1
ip route add default dev enp2s0f3 table src123 
ip rule add fwmark 0x1 table src123
ping 101.200.88.34




iptables -t raw    -D OUTPUT 1
iptables           -D OUTPUT 1
iptables -t mangle -D OUTPUT 1
iptables -t nat    -D OUTPUT 1
iptables -t mangle -D PREROUTING 1

ip rule list lookup src123
ip route show table src123
```
* Create policy routing rules.
```
ip rule add from 192.168.30.200 lookup src123 
ip rule list lookup src123
ssh -J master -D 1081 -i ~/.ssh/aliyun/mba.20231111 192.168.1.148
``` 
* Add routes
```
ip route add default via 10.0.0.2 dev ppp0 table src123 
```



ip route show table 456
ip rule list lookup 456
iptables-save
```


