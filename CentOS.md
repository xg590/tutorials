## 6.x Setup
### Set static ip
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
### DNS
vim /etc/resolv.conf 
```
nameserver 4.2.2.2
```
### Change NIC name
vim /etc/udev/rules.d/70-persistent-net.rules
### Change hostname 
vim /etc/networks
### NFS
#### master
start relevant services 
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
#### slave
start relevant services: rpcbind nfslock<br>
vim /etc/fstab
```
master:/home /home nfs
``` 
### YUM Repo
List current status
```
yum repolist all
```
Disable repos
```
yum-config-manager --disable base extras updates
```
Enable repos
```
yum-config-manager --enable c6-media
```
Install compiler
```
yum install gcc gcc-c++ gcc-gfortran
```
### Source Network Address Translation (sNAT)
Goal: Slave node with only one network interface (eth0: 192.168.0.101) wants to access the internet via master node who has two network interfaces, internal (eth0: 192.168.0.100) and external (eth1: 217.33.156.23).
* Commands on master node
```  
echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -A INPUT -i eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth1 -j MASQUERADE
```
* Commands on slave node
```
route add default gw 192.168.0.100 
```
Credit to vbird @ http://linux.vbird.org/linux_server/0250simple_firewall.php 
### Install InfiniBand Network
Understand InfiniBand [doc](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/ch-Configure_InfiniBand_and_RDMA_Networks)
Get info on hardware (<b>Mellanox</b> NIC)
```
# lspci | grep Mellanox
01:00.0 Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]
``` 
#### Driver
[Get it](https://www.mellanox.com/products/ethernet-drivers/linux/mlnx_en) / [Installtion Guide](https://docs.mellanox.com/display/MLNXEN501000/Installing+MLNX_EN)
#### Subnet Manager 
[OpenSM](https://docs.oracle.com/cd/E18476_01/doc.220/e18478/GUID-9FF8B5B0-3481-4B73-89D3-108CBD7EB989.htm#ELMOG76340)

https://docs.mellanox.com/pages/viewpage.action?pageId=12004991
