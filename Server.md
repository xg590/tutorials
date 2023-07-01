## Samba Server<a name="samba"></a>
#### Add a samba user if the same unix user exists
```
sudo apt install samba 
sudo smbpasswd -a $USER
```
#### Config
```
[global]
   workgroup = WORKGROUP
   server string = %h server (Samba, Ubuntu)
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user
   bind interfaces only = yes
   interfaces = lo enp3s0
[nuc]
    comment = Samba on Ubuntu
    path = /var/www/html
    read only = no
    guest ok  = yes
    browsable = yes
    create mask = 0644
    directory mask = 0755
    public = yes
    force user = [YOUR_USERNAME]
```
#### Smbclient
```
sudo apt install smbclient
smbclient //ip/share_folder -U '%' -c "put somefile"
smbclient '\\192.168.1.123\someDir' -c 'prompt OFF;lcd "localDir";mput movie.mp4' -U userName passwd
``` 
## FTP Client <a name="ftp"></a>
```
ftp -inv ftp.ebi.ac.uk <<EOF
user anonymous {mypassword}
cd pub/databases/msd/sifts/xml
mget 5z*.xml.gz 
bye
EOF
```
Or
```
ftp -inv ftp.ebi.ac.uk <<EOF
user anonymous {mypassword}
cd pub/databases/msd/sifts/xml
get 5z8t.xml.gz
get 5z51.xml.gz
get 5zu3.xml.gz
bye
EOF
```
#### list local dir 
```
!ls 
```
## NFS Client
```
sudo apt install nfs-common
showmount -e 192.168.1.123 
# Export list for 192.168.1.123:
# /mnt/someDir 192.168.1.0/24
mount 192.168.1.123:/mnt/someDir /nfs/general
``` 
## DHCP Server<a name="dhcp"></a>
* Assume eth0 is already configured with ip 192.168.3.3/24 (Otherwise dhcpd will fail to start)
* A dhcp server (dhcpd) can be started for 192.168.3.0/24
```
sudo apt install isc-dhcp-server
cat << EOF > /etc/dhcp/dhcpd.conf
default-lease-time 600;
max-lease-time 7200;

subnet 192.168.3.0 netmask 255.255.255.0 {
 range 192.168.3.100 192.168.3.200;
 option routers 192.168.3.3;
 option domain-name-servers 8.8.8.8, 8.8.4.4; 
}
EOF
cat << EOF > /etc/default/isc-dhcp-server # specify the interfaces dhcpd should listen to.
INTERFACESv4="eth0"
EOF
sudo systemctl restart isc-dhcp-server.service
```
* dhcpd’s messages are being sent to syslog.
* List dhcpd's users  
## rsync Server
```
cat << EOF > /etc/rsyncd.conf
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsync.log
port = 8873

[my_remote_dir]
path = /tmp/rsync
comment = Rsync files
timeout = 300
read only = false
EOF
rsync --daemon
rsync -azP /local_dir/ rsync://host:port/my_remote_dir/
```
* Rsync recurrently
```
rsync -azv --delete /mnt/e/ /mnt/h/
```
## Email Server (Not working for AWS Host. Additional configuration is needed for AWS)
0. Add a MX record to DNS registrar
```
Name   Type    Data
@      MX      10 guoxiaokang.com.
```
1. Install MTA (Message Transfer Agent)
```shell
apt update && apt install -y postfix
``` 
2. Install MUA (Mail User Agent)
```shell
apt install -y mailutils
```
3. Test MUA
```shell
echo "This is the body of email" | mail -s "This is the subject of email" "recipient@gmail.com"
```
4. A Long Letter<br>
```mail -s "This is the subject of email" "recipient@gmail.com"```<kbd>Enter</kbd><br>
```This is the body of email```<kbd>Enter</kbd><br>
```This is a new line```<kbd>Enter</kbd><br>
<kbd>CTRL</kbd>+<kbd>D</kbd>
## Let's Encrypt
#### Installation
```
sudo apt update -y && sudo apt install -y python3-certbot-apache
sudo certbot --apache --agree-tos --non-interactive --email your_email_address -d your_domain_name
```
#### Renew cert
```
sudo letsencrypt renew
``` 
#### Location of cert
  * Public cert: /etc/letsencrypt/live/your_domain_name/fullchain.pem
  * Private key: /etc/letsencrypt/live/your_domain_name/privkey.pem
#### What are these PEM file
  * cert.pem      contains the server certificate by itself. 
  * chain.pem     contains intermediate certificates. Some webservers like separated certficate files.
  * fullchain.pem contains cert.pem and chain.pem. Some webservers like unseparated certficate files.
  * private.pem   counterpart of the server certificate
## 1