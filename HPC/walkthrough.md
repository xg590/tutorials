[nmcli ref](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/networking_guide/sec-configuring_ip_networking_with_nmcli)
* Envs
```shell
IFNAME0=enp2s0f0
IFNAME1=enp0s3
IFNAME2=enp0s5
IFNAME3=enp0s7
ROOT_PASSWD=123456
echo $IFNAME1 $IFNAME2 $IFNAME3
```
* Let every machine have a temporary IP.
```shell
apt install -y dnsmasq 
systemctl disable dnsmasq 
# Give the NIC an ephemeral IP so dhcpd can listen on it. Otherwise dhcpd will exit abnormally.
# nmcli connection add type ethernet con-name <cn123> ifname <in456> ip4 <ip789> gw4 <gw012>
# nmcli con mod <cn123> ipv4.dns "8.8.8.8 8.8.4.4"
# nmcli device disconnect $IFNAME2; wait ; nmcli device connect $IFNAME2
nmcli connection add type ethernet con-name cn_hpc1 ifname $IFNAME1 ip4 192.168.11.1/24 gw4 192.168.11.1
nmcli connection add type ethernet con-name cn_hpc2 ifname $IFNAME2 ip4 192.168.22.1/24 gw4 192.168.22.1
nmcli connection add type ethernet con-name cn_hpc3 ifname $IFNAME3 ip4 192.168.33.1/24 gw4 192.168.33.1
ip route add 192.168.11.0/24 via 192.168.11.1
ip route add 192.168.22.0/24 via 192.168.22.1
ip route add 192.168.33.0/24 via 192.168.33.1
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward >/dev/null 
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o $IFNAME0 -j MASQUERADE # provide internet for subnet via the internet-connected NIC enp0s8  

cat << EOF > /etc/dnsmasq.conf
bind-interfaces
# dhcp-hostsfile=/etc/dhcpHostsFile
# dhcp-option https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
dhcp-option=6,8.8.8.8,8.8.4.4       # DHCP Option 6 (Primary DNS Server) 

interface=$IFNAME1
dhcp-range=$IFNAME1,192.168.11.100,192.168.11.200,255.255.255.0,6h
dhcp-option=$IFNAME1,3,192.168.11.1

interface=$IFNAME2
dhcp-range=$IFNAME2,192.168.22.100,192.168.22.200,255.255.255.0,6h
dhcp-option=$IFNAME2,3,192.168.22.1

interface=$IFNAME3
dhcp-range=$IFNAME3,192.168.33.100,192.168.33.200,255.255.255.0,6h
dhcp-option=$IFNAME3,3,192.168.33.1 # DHCP Option 3 (Default Gateway)
EOF
   
systemctl restart dnsmasq
sleep 5
systemctl status  dnsmasq # journalctl -u dnsmasq -f 
cat /var/lib/misc/dnsmasq.leases
```
*  Get ethernet addr of every NIC
```shell
mkdir /root/system_conf 

cat /var/lib/misc/dnsmasq.leases | awk '{ split($3, ipaddr, "."); if (ipaddr[3] == "11") { print $2; }}' > /root/system_conf/c1_eth_addr
cat /var/lib/misc/dnsmasq.leases | awk '{ split($3, ipaddr, "."); if (ipaddr[3] == "22") { print $2; }}' > /root/system_conf/c2_eth_addr
cat /var/lib/misc/dnsmasq.leases | awk '{ split($3, ipaddr, "."); if (ipaddr[3] == "33") { print $2; }}' > /root/system_conf/c3_eth_addr
```
* 
```shell
cat << EOF >  /root/system_conf/etcHosts 
127.0.0.1               localhost
127.0.1.1               localhost
192.168.11.1            $HOSTNAME
192.168.22.1            $HOSTNAME
192.168.33.1            $HOSTNAME
EOF
echo "" > /root/system_conf/dhcpHostsFile

i=1
while ((i++)); read -r j
do
    # a1:a2:3b:c4:c5:e6,192.168.11.42,node-11-42,infinite 
    echo -e "$j,192.168.11.$i,node-11-$i,infinite" >> /root/system_conf/dhcpHostsFile
    echo -e "192.168.11.$i\t\tnode-11-$i"          >> /root/system_conf/etcHosts 
done < c1_eth_addr

i=1
while ((i++)); read -r j
do  
    echo -e "$j,192.168.33.$i,node-33-$i,infinite" >> /root/system_conf/dhcpHostsFile
    echo -e "192.168.33.$i\t\tnode-33-$i"          >> /root/system_conf/etcHosts 
done < c3_eth_addr
```

```shell
i=1
while ((i++)); read -r j
do 
    echo node-11-$i 
    ssh root@192.168.11.$i "hostnamectl set-hostname node-11-$i" 
done < c1_eth_addr

i=1
while ((i++)); read -r j
do 
    echo node-33-$i 
    ssh root@192.168.33.$i "hostnamectl set-hostname node-33-$i" 
done < c3_eth_addr
```
* Repair the delay bug
```shell
for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; do echo $IP 1>> mkdir.ssh.log ; echo "UseDNS no" | sshpass -p $ROOT_PASSWD ssh -o "StrictHostKeyChecking no" root@$IP tee -a /etc/ssh/sshd_config; sshpass -p $ROOT_PASSWD ssh -o "StrictHostKeyChecking no" root@$IP systemctl restart sshd; done 
```
* Password-less login
```shell
apt install -y sshpass
DATE=`date|sed 's/ /_/g'`
ssh-keygen -q -t ed25519 -C "ubuntu_install@$DATE" -N '' -f ~/.ssh/installation
cat ~/.ssh/installation.pub >> ~/.ssh/authorized_keys

for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; do echo $IP ; ssh-keyscan $IP >> known_hosts ;done 
for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; do echo $IP 1>> mkdir.ssh.log ; sshpass -p $ROOT_PASSWD ssh -o "StrictHostKeyChecking no" root@$IP mkdir ~/.ssh 2>> mkdir.ssh.log;done 
for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; do cat ~/.ssh/installation.pub | sshpass -p $ROOT_PASSWD ssh -o "StrictHostKeyChecking no" root@$IP tee ~/.ssh/authorized_keys ;done 
for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; do ssh root@$IP hostname ;done
```
* NFS Server
```
apt install -y nfs-kernel-server nfs-common 
cat << EOF >> /etc/exports
/home 192.168.11.0/24,192.168.22.0/24,192.168.33.0/24(rw,sync,no_root_squash)
EOF
cat << EOF >> /etc/exports
/home 192.168.0.0/16(rw,sync,no_root_squash,no_subtree_check)
EOF
systemctl restart nfs-kernel-server
exportfs -ra
systemctl enable nfs-kernel-server
showmount -e login3
```
### Nodes
* Repo
```shell
cat << EOF > CentOS-Base.repo 
[base]
name=CentOS-\$releasever - Base - 163.com
baseurl=http://mirrors.163.com/centos-vault/centos/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.163.com/centos-vault/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-\$releasever - Updates - 163.com
baseurl=http://mirrors.163.com/centos-vault/centos/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.163.com/centos-vault/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-\$releasever - Extras - 163.com
baseurl=http://mirrors.163.com/centos-vault/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.163.com/centos-vault/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-\$releasever - Plus - 163.com
baseurl=http://mirrors.163.com/centos-vault/centos/\$releasever/centosplus/\$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.163.com/centos-vault/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7
EOF

for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; 
    do 
        scp CentOS-Base.repo root@$IP:/etc/yum.repos.d/CentOS-Base.repo
done
```
* NFS
```shell
 
for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; 
do  
    dist=`ssh root@$IP lsb_release -is 2> /dev/null` 
    if [ "$dist" != "Ubuntu" ] ;
    then 
        echo $IP $dist
        ssh root@$IP pkill yum
        echo "nameserver 222.88.88.88" | ssh root@$IP tee /etc/resolv.conf
        ssh root@$IP yum clean all
        ssh root@$IP cat /etc/yum.repos.d/CentOS-Base.repo
        ssh root@$IP yum makecache
        ssh root@$IP yum install -y nfs-utils ;
    fi
done

for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; 
    do 
        scp etcHosts root@$IP:/etc/hosts
done

for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; 
do  
    dist=`ssh root@$IP lsb_release -is 2> /dev/null` 
    if [ "$dist" != "Ubuntu" ] ;
    then 
        echo $IP $dist
        #ssh root@$IP showmount -e $HOSTNAME
        ssh root@$IP mount -t nfs $HOSTNAME:/home /home
    fi
done
```
mount -t nfs login3:/home /home

ssh root@192.168.11.31 mount -t nfs login3:/home /home
ssh root@192.168.11.49 mount -t nfs login3:/home /home
ssh root@192.168.11.33 mount -t nfs login3:/home /home
ssh root@192.168.11.42 mount -t nfs login3:/home /home
ssh root@192.168.11.46 mount -t nfs login3:/home /home
ssh root@192.168.11.25 mount -t nfs login3:/home /home
ssh root@192.168.11.29 mount -t nfs login3:/home /home
ssh root@192.168.11.27 mount -t nfs login3:/home /home
ssh root@192.168.11.45 mount -t nfs login3:/home /home



for IP in `cat /var/lib/misc/dnsmasq.leases | cut -d ' ' -f 3`; 
do  
    dist=`ssh root@$IP lsb_release -is 2> /dev/null` 
    if [ "$dist" != "Ubuntu" ] ;
    then 
        echo $IP $dist 
        ssh root@$IP hostname
    fi
done