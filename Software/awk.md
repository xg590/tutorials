``` 
cat << EOF > renewIP.awk
BEGIN { cnt11 = 2; cnt22 = 2; cnt33 = 2; } 
{   
    split(\$3, ipaddr, ".");  
    if (ipaddr[3] == "11") { 
        print \$3 ",192.168.11." cnt11 ",node-11-" cnt11;
        cnt11 += 1 ;
    } else if (ipaddr[3] == "22") {
        print \$3 ",192.168.22." cnt22 ",node-22-" cnt22;
        cnt22 += 1 ;
    } else if (ipaddr[3] == "33") {
        print \$3 ",192.168.33." cnt33 ",node-33-" cnt33;
        cnt33 += 1 ;
    }
}
EOF

cat /root/system_conf/dnsmasq.leases | awk -f renewIP.awk > renewIP

```