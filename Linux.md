# Ubuntu
### Configurate Network
On Ubuntu 20.04, the network is managed by Network Manager ([CLI](https://developer.gnome.org/NetworkManager/stable/nmcli.html)) by default. 
* Show current connection
```
  nmcli connection show
```
* Add a connection
```
  nmcli dev wifi con "SSID" password "PASSWORD" name "ALIAS"
```
* Change DNS ([credit](https://serverfault.com/questions/810636/how-to-manage-dns-in-networkmanager-via-console-nmcli))
```
nmcli con mod  <connectionName> ipv4.dns "8.8.8.8 8.8.4.4"
nmcli con down <connectionName>
nmcli con up   <connectionName>
```
* Delete wrong route (common for multi NICs)
```
ip route del default via 192.168.0.1
```
### Enable CGI support in Apache
``` 
a2enmod cgid
vim /etc/apache2/conf-available/serve-cgi-bin.conf
```
ScriptAlias /cgi-bin/ /var/www/cgi-bin/ 
### Disable CUPS
```
systemctl disable cups.service
```
### Default settings for <i>vncserver</i> sucks in Ubuntu 18.04
#### Related softwares
```
sudo apt-get install gnome-panel           \
                     gnome-settings-daemon \
                     metacity              \
                     nautilus              \
                     gnome-terminal  
``` 
#### Configuration
```
cd ~
cat << EOF >> .vnc/xstartup
gnome-panel &              # launcher and docking facility for GNOME
metacity &                 # lightweight GTK+ window manager
nautilus &                 # file manager and graphical shell for GNOME
gnome-settings-daemon &
EOF
```
### X11vnc
[Credit.1](https://askubuntu.com/questions/229989/how-to-setup-x11vnc-to-access-with-graphical-login-screen) and [Credit.2](https://wiki.archlinux.org/index.php/X11vnc)
```
sudo apt install -y x11vnc net-tools
x11vnc -auth guess -passwd 123456 -display :0 -listen 127.0.0.1 -rfbport 5900 -no6 -rfbportv6 -1
```
* Specify a interface by using -listen
* Disable ipv6 by using -no6 and -rfbportv6 -1 (Invalid Port). 
### Youtube-dl
```
wget https://yt-dl.org/downloads/latest/youtube-dl
youtube-dl --write-auto-sub --convert-subs=srt --skip-download URL 
```
