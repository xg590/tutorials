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
nmcli conn mod <connectionName> ipv4.dns "8.8.8.8 8.8.4.4"   # Permanent
resolvectl dns interface_name 8.8.8.8 8.8.4.4                # Temporary 
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
### Virtual Terminal
Change VT (equals to press Crtl+Alt+Fx)
```
sudo chvt N
```
Current N
```
sudo fgconsole
```
### X11vnc
Thanks to [Ziyue Yang](https://yzygitzh.github.io/productivity/2017/09/05/remote-desktop-solutions.html)
* One weird prerequisite: My headless server MUST be connected a monitor otherwise I will always get a black screen via x11vnc.
```
sudo apt install -y x11vnc net-tools
```
#### If you enabled automatic login.
vim /etc/gdm3/custom.conf. 
```
WaylandEnable=false
AutomaticLoginEnable = true
```
You can use x11vnc out of box.
```
x11vnc -display :0 
```
#### Thing is complicated if you need a greeting screen.
1. See user gdm is running Xorg
```
$ ps axu|grep Xorg
```
* The greeting screen on virtual terminal (VT) 1 (<i>vt1</i>) where you can choose one user to login. 
```
gdm ... /usr/lib/xorg/Xorg vt1 -auth /run/user/gdm_uid/gdm/Xauthority ...
```
2. Setup x11vnc to do logging in
```
sudo x11vnc -display :0 -no6 -rfbportv6 -1 -rfbport 5900 -listen 192.168.0.123 -auth /run/user/gdm_uid/gdm/Xauthority 
```
* Specify a interface by using -listen IP binded on it. 
* Disable ipv6 by using -no6 and -rfbportv6 -1 (Invalid Port).  
3. Before we use any vncviewer to see the login screen at 192.168.0.123:0, Let's see the current active VT.
```
sudo fgconsole
```
* We get the number 1, indicating vt1 is active. 
5. Now we use vncviewer to login and expect to see a black screen. OK, check the active VT again
```
sudo fgconsole
```
* We get another number (eg. 2), which means the a new VT2 is created and become active. Meanwhile the old VT goes dormat and our x11vnc is still stick to vt1. This is why we saw the black screen after login. 
```
$ ps axu|grep Xorg
```
* See, a new Xorg client (NOT server) at vt2. 
```
your_username ... /usr/lib/xorg/Xorg vt2 -auth /run/user/your_uid/gdm/Xauthority ...
```
6. Now you can safely kill the first x11vnc and start a new one.
```
x11vnc -display :1 -no6 -rfbportv6 -1 -rfbport 5900 -listen 192.168.0.123
```
* We need a new port for Xorg by specifying -display :1
7. We can see the desktop by visiting 192.168.0.123:0
### Samba 
```
[global] 
   bind interfaces only = yes
   interfaces = enp3s0

[nuc]
    comment = Samba on Ubuntu
    path = /var/www/html
    read only = no
    guest ok  = yes
    browsable = yes
    create mask = 0644
    directory mask = 0755
    force user = username
```
### ssh-agent
```
eval `ssh-agent`
ssh-add path_to_private_key
```
