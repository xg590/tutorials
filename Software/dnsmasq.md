### Enable DNS cache 
* Stop systemd-resolv and enable dnsmasq
```shell
sudo su
apt-get install -y dnsmasq
systemctl disable systemd-resolved
systemctl stop    systemd-resolved
systemctl enable  dnsmasq
```
* New resolv.conf so everyone know the new DNS server (127.0.0.1)
```shell
unlink /etc/resolv.conf
cat << EOF >  /etc/resolv.conf
nameserver 127.0.0.1
nameserver ::1
options trust-ad
EOF
```
* Configuration [Ref [1](https://www.tecmint.com/setup-a-dns-dhcp-server-using-dnsmasq-on-centos-rhel/) and [2](https://github.com/imp/dnsmasq/blob/master/dnsmasq.conf.example)]
```
cat << EOF > /etc/dnsmasq.d/dns.conf 
interface=lo                        # either use interfaces or listen-address
#listen-address=192.168.1.33        # bind to interface or its ip addr
bind-interfaces                     # not listening on 0.0.0.0 
no-resolv                           # do not import /etc/resolv.conf into dnsmasq
server=8.8.8.8                      # upstream DNS (up to 3)
address=/example123.lan/127.0.0.1   # local resolution
log-queries
log-facility=/root/dnsmasq.log
EOF

systemctl restart dnsmasq
``` 
### Enable DHCP
```
cat << EOF > /etc/dnsmasq.d/dhcp.conf
dhcp-authoritative
dhcp-range=192.168.0.50,192.168.0.150,12h
dhcp-leasefile=/var/lib/dnsmasq/dnsmasq.leases
#dhcp-host=11:22:33:44:55:66,192.168.0.60 # MAC binding
log-dhcp
EOF
```
### Enable PXE (TFTP)
