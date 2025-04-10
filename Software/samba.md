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
   path = /var/www/html
   writable = yes
   printable = no
   public = yes
[global]
  workgroup = WORKGROUP
  server string = %h server (Samba, Ubuntu)
  security = user
  guest account = a
  passdb backend = tdbsam
  bind interfaces only = yes
  interfaces = enx0826ae3c0b6e

EOF
sudo systemctl restart smbd
```
#### Smbclient
```
sudo apt install smbclient
smbclient //ip/share_folder -U '%' -c "put somefile"
smbclient '\\192.168.1.123\someDir' -c 'prompt OFF;lcd "localDir";mput movie.mp4' -U userName passwd
``` 