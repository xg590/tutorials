* Install the desktop version of Ubuntu 2204 on a    bare-metal server as the login node.
* Install the server  version of Ubuntu 2204 on each bare-metal server as a compute node.
  * Use usb stick
    * Download ubuntu-22.04.4-live-server-amd64.iso and  it and flash the modified iso to a USB stick.
    * Prepare iso9660 file: Refer to and modify it
    * Burn ubuntu-22.04.4-live-server-amd64-mod.iso with ```dd```
      ```shell
      dd if=ubuntu-22.04.4-live-server-amd64-mod.iso of=/dev/sdb bs=1M
      ```
  * PXE
### Configure the login node
  * Assign IP address for the login node
    ```shell
    systemctl stop unattended-upgrades
    apt purge -y unattended-upgrades
    mkdir /root/sys_conf 
    cat << EOF > /etc/hosts
    127.0.0.1               localhost
    127.0.1.1               localhost
    192.168.11.1            $HOSTNAME
    192.168.11.1            login
    EOF
    cat << EOF >> ~/.bashrc 
    export IFNAME0=enp2s0f0
    export IFNAME1=enp2s0f1
    EOF
    source ~/.bashrc
    echo $IFNAME0 $IFNAME1
    nmcli connection add type ethernet con-name cn_hpc1 ifname $IFNAME1 ip4 192.168.11.1/24 gw4 192.168.11.1
    #nmcli conn del cn_hpc1
    sleep 5
    ```
  * Login as gateway
    ```
    ip route add 192.168.11.0/24 via 192.168.11.1
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf
    iptables -P FORWARD ACCEPT
    # provide internet for subnet via the internet-connected NIC $IFNAME0
    iptables -t nat -A POSTROUTING -s 192.168.11.0/24 -o $IFNAME0 -j MASQUERADE 
    ```
  * Provide a ephemeral IP for each compute node
    ```shell 
    apt update -y && apt install dnsmasq
    cat << EOF > /etc/dnsmasq.conf
    bind-interfaces 
    interface=$IFNAME1
    dhcp-range=$IFNAME1,192.168.11.100,192.168.11.200,255.255.255.0,6h
  
    # dhcp-option https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
    dhcp-option=$IFNAME1,3,192.168.11.1  
    dhcp-option=$IFNAME1,6,8.8.8.8,8.8.4.4       # DHCP Option 6 (Primary DNS Server) 
    EOF
    systemctl restart dnsmasq
    sleep 5
    systemctl status  dnsmasq # journalctl -u dnsmasq -f 
    cat /var/lib/misc/dnsmasq.leases 
    ```
  * Install NFS / NIS / MUNGE / SLURM services for login node
    * slurmctld is the central management daemon of Slurm
    * slurmd is the compute node daemon of Slurm
    * slurm-client contains commands like sinfo and sbatch 
    ```shell
    apt install -y nfs-kernel-server nfs-common     \
                   nis                              \
                   munge libmunge2 libmunge-dev     \
                   slurmctld slurmd slurm-client    \
                   pssh 
    ```
  * NFS Server
    ```shell
    cat << EOF >> /etc/exports
    /home 192.168.11.0/24(rw,sync,no_root_squash,no_subtree_check)
    EOF
    systemctl restart nfs-kernel-server
    exportfs -ra
    showmount -e $HOSTNAME

    systemctl enable nfs-kernel-server
    ```
    * NIS Server
    ```shell
    sed -i 's/NISSERVER=false/NISSERVER=master/g' /etc/default/nis
    cat << EOF > /etc/ypserv.securenets 
    255.0.0.0       127.0.0.0
    host            ::1 
    255.255.0.0     192.168.0.0
    EOF
    ypdomainname login
    echo "login" > /etc/defaultdomain 
    # domain <nisdomain> server <nisserver>
    echo "domain login server login" >> /etc/yp.conf
    cat << EOF > /etc/nsswitch.conf 
    # /etc/nsswitch.conf 

    passwd:         files nis 
    group:          files nis
    shadow:         files nis
    gshadow:        files

    hosts:          files dns nis
    networks:       files

    protocols:      db files
    services:       db files
    ethers:         db files
    rpc:            db files

    netgroup:       nis
    EOF
    /usr/lib/yp/ypinit -m

    systemctl restart rpcbind ypserv yppasswdd ypxfrd
    rpcinfo -p localhost | grep -E 'ypserv|yppasswdd'

    systemctl enable  rpcbind ypserv yppasswdd ypxfrd
    ```
  * Slurm Server
    ```shell
    cat << EOF > /etc/slurm/cgroup.conf 
    CgroupAutomount=yes
    CgroupMountpoint=/sys/fs/cgroup
    ConstrainCores=no
    ConstrainRAMSpace=no
    EOF

    mkdir             /var/spool/slurmctld /var/spool/slurmd 
    chown slurm:slurm /var/spool/slurmctld /var/spool/slurmd 
    chmod 755         /var/spool/slurmctld /var/spool/slurmd 
    touch /var/log/slurm/slurmctld.log /var/log/slurm/slurm_jobacct.log /var/log/slurm/slurm_jobcomp.log
    systemctl restart slurmctld slurmd 
    sinfo

    systemctl enable  slurmctld slurmd      
    ```
  
  * Create a /root/sys_conf/set_nic.sh for compute node
    ```shell
    cat << ABC > /root/sys_conf/set_nic.sh
    CNT=\`cat /tmp/.cnt\`
    IP=192.168.11.\$CNT
    NIC=\`ip route get 8.8.8.8 | awk '{ print \$5; exit }'\` 
    GW=192.168.11.1
    HN=node-\$CNT
    echo \$IP \$NIC \$GW \$HN > /root/.net_info 
    hostnamectl set-hostname \$HN
    cat << EOF > /etc/netplan/02-netcfg-abc.yaml
    network:
      version: 2
      ethernets:
        \$NIC: 
          dhcp4: no
          dhcp6: no
          addresses: [\$IP/24]
          routes:
            - to: default
              via: \$GW
          nameservers:
            addresses: [8.8.8.8, 8.8.4.4]
    EOF
    chmod 600 /etc/netplan/*
    ABC
    ``` 