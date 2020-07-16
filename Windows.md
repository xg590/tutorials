### Route 
I got two Network Interface Cards (NICs), and each has its place in routing table. Since only the second NIC is connect to the internet, I will delete the route involving the 1st NIC.<Br>
#### Show the routing table
```
> route print
```
Result
```
===========================================================================
Interface List 
 14...MAC of the 1st NIC ......Brand of the 1st NIC                           # IP binds to this NIC is 192.168.10.2
 17...MAC of the 2nd NIC ......Brand of the 2nd NIC                           # IP binds to this NIC is 192.168.0.75
===========================================================================

IPv4 Route Table
===========================================================================
Active Routes:
Network Destination        Netmask          Gateway       Interface  Metric
          0.0.0.0          0.0.0.0     192.168.10.1     192.168.10.2     55
          0.0.0.0          0.0.0.0     192.168.0.22     192.168.0.75     36
=========================================================================== 
```
With the help of command <i>ipconfig</i>, we should know the ip-interface binding relation.  
* Interface number of the 1st NIC is 14 and that of the 2nd NIC is 17.   
* Actually we don't need delete the 1st route since it has a higher metric value. Internet links go through the 2nd interface automatically. 
#### Delete a route
```
> route delete 0.0.0.0 mask 0.0.0.0 192.168.10.1 if 17
```
