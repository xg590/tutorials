## NFS Client
```
sudo apt install nfs-common
showmount -e 192.168.1.123 
# Export list for 192.168.1.123:
# /mnt/someDir 192.168.1.0/24
mount 192.168.1.123:/mnt/someDir /nfs/general
```
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
* Folder exclusion (you cannot exclude '/var/www/html/software/docker' because there is no '/var/www/html/software/docker' under '/var/www')
```
rsync -rtP --exclude 'www/html/software/docker' /var/www /media/aaa/AutoChem_Backup/
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