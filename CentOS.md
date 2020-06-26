## 6.x Setup
#### Set static ip
vim /etc/sysconfig/network-scripts/ifcfg-eth0
```
DEVICE=eth0
HWADDR=08:00:27:90:69:AB
TYPE=Ethernet 
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=192.168.56.100
NETMASK=255.255.255.0
```
#### DNS
vim /etc/resolv.conf 
```
nameserver 4.2.2.2
```
#### Change NIC name
vim /etc/udev/rules.d/70-persistent-net.rules
#### Change hostname 
vim /etc/networks
#### NFS
master
```
/etc/init.d/rpcbind start
/etc/init.d/nfs start
/etc/init.d/nfslock start 
chkconfig rpcbind on
chkconfig --level 2345 nfs on
chkconfig nfslock on 
chkconfig --list | grep nfs
```
vim /etc/exports
```
/home 192.168.56.0/24(rw,no_root_squash,async)
```
mount
```
exportfs -arv
```
slave: start rpcbind nfslock<br>
vim /etc/fstab
```
master:/home /home nfs
``` 
