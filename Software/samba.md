#### Samba Server<a name="samba"></a>
* Add a samba user if the same unix user exists
```
sudo apt install -y apache2 samba
sudo bash -c "echo -e 'a\na\n' | smbpasswd -a $USER"
```
* Config
```
cat << EOF | sudo tee /etc/samba/smb.conf 
[$HOSTNAME]
    comment = Samba on Ubuntu
    path = /var/www/html
    read only = no
    guest ok  = yes
    browsable = yes
    create mask = 0644
    directory mask = 0755
    public = yes
    force user = ${USER}
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
   #bind interfaces only = yes
   #interfaces = lo enp3s0
EOF
sudo systemctl restart smbd
```
#### Smbclient
```
sudo apt install smbclient
smbclient //ip/share_folder -U '%' -c "put somefile"
smbclient '\\192.168.1.123\someDir' -c 'prompt OFF;lcd "localDir";mput movie.mp4' -U userName passwd
``` 