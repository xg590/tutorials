### Content 
* [CLI and GUI](#cliandgui)
* [systemctl](#systemctl)
* [iptables](#iptables)
* [DHCP](#dhcp)
* [nmcli](#nmcli)
* [ip](#ip)
* [FTP](#ftp)
* [Samba](#samba)
* [screen](#screen)
### CLI and GUI <a name="cliandgui"></a>
```
Boot (Ubuntu 20.04)
  \_systemD (another init system than system V)
     |\
     | \_multi-user.target
     |     \
     |      \_startx (X session)  
     |
     \_graphical.target
         \
          \_Display Manager / graphical login manager (Xorg / Wayland)
			  \
			   \_Window Manager (X session)
```
* Boot into text mode: 
```
sudo systemctl set-default multi-user.target 
```
* Boot into graphical mode: 
```
sudo systemctl set-default graphical.target 
```
* Switch to text mode from graphical mode without reboot: 
```sudo systemctl start multi-user.target 
```
* Oppositely, do: 
```
sudo systemctl start graphical.target
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
* Thanks to [Ziyue Yang](https://yzygitzh.github.io/productivity/2017/09/05/remote-desktop-solutions.html) for mentioning x11vnc
* One weird problem: The ubuntu MUST have a monitor connected to it otherwise I will freeze. So ... 
* Install the needed software.
```
sudo apt install -y x11vnc
```
#### Things are in the best scenario if you enabled automatic login. 
You can use x11vnc out of box and use the vnc viewer then.
```
x11vnc -display :0 
```
#### Thinge are complicated if you use a greeting screen (need password to enter an account).
0. Try this command and connect port 5900. If it succeeds, then goto step 6. 
```
sudo x11vnc -display :0 -auth /run/user/125/gdm/Xauthority
```
1. Disable Wayland and enable Xorg display server if necessary.
```
sudo sed -i s/#WaylandEnable/WaylandEnable/ /etc/gdm3/custom.conf
sudo reboot
```
2. Now user gdm is running Xorg and displaying a greeting screen.
```
$ ps axu|grep Xorg
```
3. The greeting screen is on vt1 (virtual terminal 1) where you can login. 
```
gdm ... /usr/lib/xorg/Xorg vt1 -auth /run/user/gdm_uid/gdm/Xauthority ...
```
* Let's check which VT is active. You will connect to this terminal if you use x11vnc. 
```
sudo fgconsole
1
```
4. Let's setup a vnc server to see the greeting screen. we need root privilege because we need acsess gdm's Xauthority 
```
sudo x11vnc -display :0 -auth /run/user/gdm_uid/gdm/Xauthority 
```
* Use vnc viewer to log in.
5. After login, our vnc viewer will went black because vt1 goes dormat and a new virtual terminal is activated. 
* Of course it is run by the user we just logged in. OK, check the active VT again
```
sudo fgconsole
2 
```
* We get another number (eg. 2), which means the a new VT2 is created by the user we logged in and becomes active.   
```
$ ps axu|grep Xorg
your_username ... /usr/lib/xorg/Xorg vt2 -auth /run/user/your_uid/gdm/Xauthority ...
``` 
* See, a new Xorg client (NOT server) at vt2.  
6. Now you can safely kill the first x11vnc and start a new one without using Xauthority.
```
x11vnc -display :1 -no6 -rfbportv6 -1 -rfbport 5900 -listen 192.168.0.???
```
* Specify a interface by using -listen IP binded on it. 
* Disable ipv6 by using -no6 and -rfbportv6 -1 (Invalid Port).  
* We need a new port for Xorg by specifying -display :1 
### Repair grub after MS Windows installation.
* Use USB installation stick to try Ubuntu and run following code 
```
sudo add-apt-repository ppa:yannubuntu/boot-repair 
sudo apt update && sudo apt install boot-repair boot-repair 
```
### systemctl <a name="systemctl"></a>
* Service will not start after reboot
```
systemctl disable apache2 
```
* Check if disabling works. Equvialent to CentOS's "chkconfig --list"
```
systemctl list-unit-files --state=enabled 
```
* Apache2 will stop instantly
```
systemctl stop apache2    
```
* Check if stopping works
```
systemctl status apache2    
```
### iptables <a name="iptables"></a>
```shell
#!/bin/bash
if [ `id -u` != 0 ] 
then  
  echo You Are Not Root 
  exit 
fi  
 
iptables -F 
iptables -X 
iptables -Z 
iptables -t nat -F 
iptables -t nat -X 
iptables -t nat -Z 
 
iptables -A INPUT -p tcp --dport ssh -j ACCEPT 
iptables -A INPUT -i lo -j ACCEPT 
iptables -A INPUT -i enp0s3 -m state --state RELATED,ESTABLISHED -j ACCEPT
 
iptables -P INPUT DROP   # Since we accept ESTABLISHED connection, the reply of our outgoing request will not be dropped. 
iptables -P OUTPUT ACCEPT 
iptables -P FORWARD ACCEPT
```
* Sometime switch function is needed so (POSTROUTING is to manipulate outgoing packet)
```
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -d 172.16.1.0/24 -j ACCEPT
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -j MASQUERADE
```
* DELETE
```
iptables -D INPUT 1      # Delete the first rule in INPUT chain of table filter
```
### crontab ([credit](https://stackoverflow.com/users/45978/joe-casadonte))
* I dont know why but it is better to use absolute path of a command
```
(crontab -l 2>/dev/null; echo "@reboot date > /tmp/date") | crontab -
```
### Pipe via SSH
```
echo LOL | ssh remoteHost 'cat > /tmp/pipeOverSSH'
```
### Single User Mode
* Press F10 to select boot media
* Choose hard disk and press ESC
* Land into grub menu and use key E to edit "Ubuntu"
* Add "single" after line starting with "linux"
* Press F10 to save and exit
### aria2c
```
aria2c -j5 --header="User-Agent: Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36"  
```
### Update Time (Thanks [Shrukul Habib](https://askubuntu.com/a/683136))
```
sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
```
### Wake-on-Lan
* It works out of box for one of my Intel NUC. 
  * Enabled by default in BIOS
  * NUC supports Wake-on: pumbg (use man ethtool to see the meaning of each letter)
  * NUC wake-on :g (not d)
  * Wake NUC up from another machine (port is 9)
```
  sudo apt install wakeonlan
  wakeonlan -i nuc_ip nuc_mac
``` 
### ssh-agent
```
eval `ssh-agent`
ssh-add path_to_private_key
```
### SSH jumphost
```
scp -i .ssh/targetHostIdentityFileOnMiddleHost -oProxyCommand="ssh -i .ssh/middleHostIdentityFileOnLocalHost -W %h:%p middleHost" targetHost:/some/path/to/file ./
```
### Don't Starve Together
```shell
sudo dpkg --add-architecture i386 && dpkg --print-foreign-architectures
sudo apt-get update && sudo apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 
cat << EOF > dst_in_screen.sh
screen -s /bin/bash -d -m -S dst
screen -S dst -X stuff 'bash ${PWD}/run_dedicated_servers.sh ^M'
EOF
(crontab -l 2>/dev/null; echo "@reboot bash ${PWD}/dst_in_screen.sh") | crontab - 
screen -S dst -X stuff ^C # Stop running
```
### Fritzing
```
sudo apt-get install -y qt5-default libqt5serialport5
```
### rsync
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
### Capture Screen
Save 10 sec screenshot 
```
ffmpeg -f x11grab -i :0.0 -video_size 1024x768 -framerate 25 -t 10 output.mp4
```
Broadcast screenshot via tcp 
```
ffmpeg -f x11grab -i :0.0 -framerate 25 -video_size 1024x768 -listen 1 -f mpegts tcp://0.0.0.0:12345
```
### Redirect Port
```
# add
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 44332 
iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 443 -j REDIRECT --to-ports 44332
# del
iptables -t nat -D PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 44332 
iptables -t nat -D OUTPUT -p tcp -d 127.0.0.1 --dport 443 -j REDIRECT --to-ports 44332
```
### Email Service (Not working for AWS Host. Additional configuration is needed for AWS)
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
### Let's Encrypt
* Installation
```
sudo apt update -y && sudo apt install -y python3-certbot-apache
sudo certbot --apache --agree-tos --non-interactive --email your_email_address -d your_domain_name
```
* Renew cert
```
sudo letsencrypt renew
``` 
* Location of cert
  * Public cert: /etc/letsencrypt/live/your_domain_name/fullchain.pem
  * Private key: /etc/letsencrypt/live/your_domain_name/privkey.pem
### DHCP <a name="dhcp"></a>
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
#### Convert wireless network to wired network
1. Set a static ip for the wired interface (This is the gateway ip)
```
cat << EOF >> /etc/dhcpcd.conf # This is config file for dhcp client 
interface eth0
static ip_address=192.168.3.3/24
static routers=192.168.3.0
EOF
```
2. Install dhcpd on wired interface so wired network can get network info 
3. There is a bug for Raspbian OS that isc-dhcp-server starts too early before interface eth0 has an IP addr.
4. We have delay isc-dhcp-server 30 second in startup script.
```
sed -i "14a sleep 30" /etc/init.d/isc-dhcp-server 
```
5. Allow forward and masquerade packets from wired interface
```
echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o wlan0 -j MASQUERADE
```
### Apache2 & CGI
* Common Gateway Interface Daemon
```shell
# As root
apt install -y apache2 python3 python3-pip
a2enmod cgid # vim /etc/apache2/conf-available/serve-cgi-bin.conf
systemctl restart apache2
pip3 install --target /var/www/additional_module boto3
cat << EOF > /usr/lib/cgi-bin/test.py
#!/usr/bin/python3
sys.path.append("/var/www/additional_module")
import boto3 
# -*- coding: UTF-8 -*- 
print("""Content-type:text/html
<html>
    <head>
        <meta charset=\"utf-8\"> 
        <title>This is a TEST</title> 
    </head> 
    <body>
        Your boto3's version is {boto3.__version__} <br>
    </body> 
</html>""")
EOF
chmod o+x /usr/lib/cgi-bin/test.py
```
* Visit http://your_domain/cgi-bin/test.py  
* [ScriptAlias](https://httpd.apache.org/docs/2.4/howto/cgi.html) 
  * Revise <i>/etc/apache2/conf-available/serve-cgi-bin.conf</i> after <i>a2enmod cgid</i>
```
The ScriptAlias directive tells Apache that a particular directory is set aside for CGI programs
``` 
### Jupyter-notebook
```
mkdir ~/.jupyter
cat << EOF >> ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
EOF
sudo apt update -y && sudo apt install -y python3-pip
pip3 install jupyter jupyter_contrib_nbextensions
.local/bin/jupyter contrib nbextension install --user
screen -s /bin/bash -d -m -S jupyter
screen -S jupyter -X stuff '.local/bin/jupyter-notebook ^M'
```
### Clear Cache
```shell
echo 3 | sudo tee /proc/sys/vm/drop_caches
```
### Enable i386 support on Ubuntu 18.04
```
sudo dpkg --add-architecture i386 && dpkg --print-foreign-architectures
```
### Offline Software Installation
* On the online Ubuntu
```shell
sudo apt install -y apt-offline
sudo apt-offline set --install-packages tightvncserver --update tightvncserver.sig
sudo apt-offline get --bundle bundle.zip tightvncserver.sig
```
* Copy bundle.zip from the online Ubuntu to the offline one.
* On the offline Ubuntu
```shell
sudo apt install -y apt-offline
sudo apt-offline install --skip-changelog bundle.zip
sudo apt-get install tightvncserver
vncserver -localhost -nolisten tcp
```
### Network Manager <a name="nmcli"></a>
On Ubuntu 20.04, the network is managed by Network Manager ([CLI](https://developer.gnome.org/NetworkManager/stable/nmcli.html)) by default. <b>IT SUCKS!!!</b>. 
* Show current connection
```
  nmcli connection show
```
* Show available SSID
```
  nmcli dev wifi
```
* Add a connection
```
  nmcli dev wifi con "SSID" password "PASSWORD" name "ALIAS"
```
* Connect/disconnect
```
  nmcli con up/down "ALIAS"
```
* Modify a connection (permanently)
```
  sudo nmcli conn edit "Wired connection 1" 
  nmcli> set ipv4.method manual
  nmcli> set ipv4.addresses 192.168.0.123/24
  nmcli> save persistent
  nmcli> quit
```
* Disable WIFI
```
nmcli radio wifi off
nmcli r     all  off # turn on airplane mode
```
* Change DNS 
```
nmcli conn mod <connectionName> ipv4.dns "8.8.8.8 8.8.4.4"   # Permanent
resolvectl dns interface_name 8.8.8.8 8.8.4.4                # Temporary 
``` 
### ip <a name="ip"></a>
* Delete wrong route (common for multi NICs)
```
ip route del default dev interface_name
ip route del 0.0.0.0/0 via 192.168.1.1
ip route del 0.0.0.0/0 via 192.168.1.1 metric 9999
``` 
### Configure Network via netplan
* List NIC
```
ip addr
```
* Link status of NIC (don't forget ethtool -p/--identify)
```
ethtool iface-name
```
* vim /etc/netplan/00-nonsense.yaml
```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 10.10.10.2/24
      gateway4: 10.10.10.1
      nameservers: 
          addresses: [10.10.10.1, 1.1.1.1]
```
### Remove Services
```
systemctl disable cups cups-browsed nmbd apache2 smbd
```
### FTP service <a name="ftp"></a>
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
* list local dir 
```
!ls 
```
* Client
```
smbclient '\\192.168.1.123\someDir' -c 'prompt OFF;lcd "localDir";mput movie.mp4' -U userName passwd
```
### NFS 
* Client
```
sudo apt install nfs-common
showmount -e 192.168.1.123 
# Export list for 192.168.1.123:
# /mnt/someDir 192.168.1.0/24
mount 192.168.1.123:/mnt/someDir /nfs/general
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
### Samba <a name="samba"></a>
* Add a samba user if the same unix user exists
```
sudo apt install samba 
sudo smbpasswd -a $USER
```
* Config
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
* Smbclient
```
sudo apt install smbclient
smbclient //ip/share_folder -U '%' -c "put somefile"
```
### Autossh
* [Homepage](https://www.harding.motd.ca/autossh/index.html)
* Compile
```
wget https://www.harding.motd.ca/autossh/autossh-1.4g.tgz
wget https://www.harding.motd.ca/autossh/autossh-1.4g.cksums
grep SHA256 autossh-1.4g.cksums | cut -f2 -d=  | xargs -I % echo % autossh-1.4g.tgz | sha256sum -c
tar zxvf autossh-1.4g.tgz
cd autossh-1.4g
./configure
make
```
### Screen <a name="screen"></a>
Start a screen session in the backgroup
```
screen -d -m -S autossh
```
Send a command into the session to run [Autossh](https://www.harding.motd.ca/autossh/autossh-1.4g.tgz) 
```
screen -S autossh -X stuff 'autossh -M 12345 hostname ^M'
```
* Split screen vertically  : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Shift</kbd>+<kbd>\ </kbd>
* Split screen horizentally: <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Shift</kbd>+<kbd>s</kbd> 
* Switch region            : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Tab</kbd>
* Close region             : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Shift</kbd>+<kbd>x</kbd> 
* New window               : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>c</kbd>
* Next window              : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>n</kbd>
* List windows             : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>w</kbd> 
* Switch window            : <kbd>CTRL</kbd>+<kbd>a</kbd> Then window_number
* Kill window              : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>k</kbd>  
### Parallelism
```
ls | head | xargs -n 1 -P 3 program_X
```
* -n num of arguments for each program
### [Move files](https://unix.stackexchange.com/a/230536)
* Exclude something
```
rsync -rv --include '*/' --include '*.js' --exclude '*' --prune-empty-dirs --remove-source-files Source/ Target/ 
```
* Over SSH (remote_123 should be valid setting in SSH configuration)
```
rsync -azv --exclude unwanted/directory/in/source remote_123:/source/ local_target/
```
### Turn off screen [Credit to Siva Charan](https://superuser.com/a/374661)
```
sleep 5 ; xset dpms force off 
```
### Youtube-dl
```
wget https://yt-dl.org/downloads/latest/youtube-dl 
youtube-dl --sub-lang en --write-sub --skip-download https://www.youtube.com/watch?v=xxx 
youtube-dl --all-subs    --write-sub --cookies cookies.txt --user-agent "Safari/537.36" https://www.youtube.com/watch?v=xxx 
```
### Lack of so (Dynamic Link Library)
* Take libffi.so.6 as the example
```
wget http://mirrors.kernel.org/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-8_amd64.deb
ar x libffi6_3.2.1-8_amd64.deb
tar Jxf data.tar.xz 
export LD_LIBRARY_PATH=$PWD/usr/lib/x86_64-linux-gnu/
```
### Power behavior
* Not suspended after close the lid
```
cat << EOF >> sudo tee -a /etc/systemd/logind.conf
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=ignore
EOF
sudo systemctl restart systemd-logind
```
