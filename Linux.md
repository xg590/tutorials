# Ubuntu
### Configurate Network
On Ubuntu 20.04, the network is managed by Network Manager ([CLI](https://developer.gnome.org/NetworkManager/stable/nmcli.html)) by default. <b>IT SUCKS!!!</b>. 
* Show current connection
```
  nmcli connection show
```
* Add a connection
```
  nmcli dev wifi con "SSID" password "PASSWORD" name "ALIAS"
```
* Change DNS 
```
resolvectl dns interface_name 8.8.8.8
```
* Delete wrong route (common for multi NICs)
```
ip route del default dev interface_name
```
### Enable CGI support in Apache
``` 
a2enmod cgid
vim /etc/apache2/conf-available/serve-cgi-bin.conf
```
ScriptAlias /cgi-bin/ /var/www/cgi-bin/ 
### Remove Services
```
systemctl disable cups cups-browsed nmbd apache2 smbd
```
### List Service
```
systemctl list-units --type service --all
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
Get the right Xauthority_file
```
ps axu|grep 'Xorg'
```
Result
```
gdm ... -auth /run/user/123/gdm/Xauthority ...  
```
Create a valid Xauthority file
```
sudo xauth -f valid_Xauthority merge /run/user/123/gdm/Xauthority
sudo chmod 666 valid_Xauthority
```
Install and Run [Credit](https://wiki.archlinux.org/index.php/X11vnc)
```
sudo apt install -y x11vnc net-tools
x11vnc -auth valid_Xauthority -passwd 123456 -display :0 -listen 127.0.0.1 -rfbport 5900 -no6 -rfbportv6 -1
```
* Specify a interface by using -listen
* Disable ipv6 by using -no6 and -rfbportv6 -1 (Invalid Port).   
### Youtube-dl
```
wget https://yt-dl.org/downloads/latest/youtube-dl 
youtube-dl --sub-lang en --write-sub --skip-download https://www.youtube.com/watch?v=d4EgbgTm0Bg
```
