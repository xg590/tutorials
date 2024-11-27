### Generic Usage <a name="ip"></a>
* Delete wrong route (common for multi NICs)
```
ip route del default dev interface_name
ip route del 0.0.0.0/0 via 192.168.1.1
ip route del 0.0.0.0/0 via 192.168.1.1 metric 9999
``` 
* Add default route 
```
ip route add default dev interface_name
```
### Policy Routing [Credit](https://blog.scottlowe.org/2013/05/29/a-quick-introduction-to-linux-policy-routing/)
* I want all traffics from 192.168.30.200 route through ppp0
* Create a custom policy routing table.
```
echo -e "200 src123" > /etc/iproute2/rt_tables.d/new123.conf # routing table identifier and table name
```
* Create policy routing rules.
```
ip rule add from 192.168.30.200 lookup src123 
ip rule list                    lookup src123
``` 
* Add routes
```
ip route add default via 10.0.0.2 dev ppp0 table src123 
ip route show                              table src123
```
* Restart iface
```
ip link set eth0 down; wait ; ip link set eth0 up
```
* Del extra ip 
```
ip addr del 192.168.1.2/32 dev <interface-name>
```
* Metric
```
nmcli conn mod "LAN_1" ipv4.method manual ipv4.addresses 192.168.1.102/24 ipv4.gateway 192.168.1.1 ipv4.dns 210.42.249.132 ipv4.route-metric 50
```