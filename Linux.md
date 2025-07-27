# Content 
* [CLI and GUI](#cliandgui)
* [iptables](#iptables)
* [DHCP](#dhcp)
* [nmcli](#nmcli)
* [ip](#ip)
* [FTP](#ftp)
* [Samba](#samba)
* [screen](#screen)
* [Assign IP address in Ubuntu, permanently](#ubuntu-static-ip)
* [Assign IP address in Ubuntu, temporarily](#ip-addr-ubuntu-temp)
* [Assign IP address in Raspbian, permanently](#raspbian-static-ip)
# Networking
## Static IP addr <a name="raspbian-static-ip"></a>
```
cat << EOF >> /etc/dhcpcd.conf # This is config file for dhcp client 
interface eth0
static ip_address=192.168.3.3/24
static routers=192.168.3.0
EOF
```
## Restart network interface 
``` 
sudo ip link set wlan0 down
sudo ip link set wlan0 up
``` 
## iptables <a name="iptables"></a>
#### Example
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
 
iptables -P INPUT DROP # Since we accept ESTABLISHED connection, the reply of our outgoing request will not be dropped. 
iptables -P OUTPUT ACCEPT 
iptables -P FORWARD ACCEPT
```
#### Sometime switch function is needed so (POSTROUTING is to manipulate outgoing packet)
```
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -d 172.16.1.0/24 -j ACCEPT
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -j MASQUERADE
```
#### DELETE
```
iptables -D INPUT 1      # Delete the first rule in INPUT chain of table filter
```
#### Redirect Port
```
# add
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 44332 
iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 443 -j REDIRECT --to-ports 44332
# del
iptables -t nat -D PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 44332 
iptables -t nat -D OUTPUT -p tcp -d 127.0.0.1 --dport 443 -j REDIRECT --to-ports 44332
```
# System <a name="cliandgui"></a>
## APT Source
#### arm64
```
deb http://deb.debian.org/debian bullseye main contrib non-free
deb https://mirrors.aliyun.com/debian bullseye main contrib non-free
```
## pip Source
```
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```
## Virtual Terminal
### Change VT (equals to press Crtl+Alt+Fx)
```
sudo chvt N
```
### Current N
```
sudo fgconsole
```
### Repair grub after MS Windows installation. 
* Use USB installation stick to try Ubuntu and run following code 
```
sudo add-apt-repository ppa:yannubuntu/boot-repair 
sudo apt update && sudo apt install boot-repair boot-repair 
``` 
### Single User Mode
  * Press F10 to select boot media
  * Choose hard disk and press ESC
  * Land into grub menu and use key E to edit "Ubuntu"
  * Add "single" after line starting with "linux"
  * Press F10 to save and exit
### Update Time (Thanks [Shrukul Habib](https://askubuntu.com/a/683136))
```
sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
```
### Change Ubuntu Repo Src
```
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak_`date "+%y_%m_%d"`
sudo sed -i 's/http:\/\/.*.ubuntu.com/https:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list
sudo apt update && sudo apt full-upgrade
```
# Software
* VNC
```
export DISPLAY=:1
xhost +
```
* X11vnc
  * Thanks [Ziyue Yang](https://yzygitzh.github.io/productivity/2017/09/05/remote-desktop-solutions.html) for   mentioning x11vnc
  * One weird problem: The ubuntu MUST have a monitor   connected to it otherwise I will freeze. So I bought a dummy monitor dongle.
  * Install the needed software.
      ```
      sudo apt install -y x11vnc
      ```
  * Things are in the best scenario if you enabled automatic login. You can use x11vnc out of box by running.
      ```
      x11vnc -display :0 
      ```
  * Thinge are complicated if you are using a greeting screen because we need to enter password somewhere to login an account.

    0. Try this command and connect port 5900. If it succeeds, then goto step 6. 
        ```
        sudo x11vnc -display :0 -auth /run/user/125/gdm/  Xauthority
        ``` 
    1. Disable Wayland and enable Xorg display server if     necessary.
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
        sudo x11vnc -display :0 -auth /run/user/gdm_uid/gdm/    Xauthority 
        ``` 
    5. By using vnc viewer to log in, our vnc viewer will went black because vt1 goes dormat and a new virtual terminal is activated. 
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
        * Specify a interface by using -listen IP binded on it. 
        * Disable ipv6 by using -no6 and -rfbportv6 -1 (Invalid Port). 
        * We need a new port for Xorg by specifying -display :1 
          ```
          x11vnc -display :1 -no6 -rfbportv6 -1 -rfbport 5900 -listen 192.168.0.???
          ```

* crontab ([credit](https://stackoverflow.com/users/45978/joe-casadonte))
  * I dont know why but it is better to use absolute path of a command
    ```
    (crontab -l 2>/dev/null; echo "@reboot date > /tmp/date") | crontab -
    ```
* SSH
  * Remove fingerprint
    ```
    sed -i.old '/192.168./d' known_hosts
    ```
  * Pipe via SSH
    ```
    echo LOL | ssh remoteHost 'cat > /tmp/pipeOverSSH'
    ```
  * ssh-agent
    ```
    eval `ssh-agent`
    ssh-add path_to_private_key
    ```
  * SSH jumphost
    ```
    scp -i .ssh/targetHostIdentityFileOnMiddleHost -oProxyCommand="ssh -i .ssh/middleHostIdentityFileOnLocalHost -W %h:%p middleHost" targetHost:/some/path/to/file ./
    ```
  * SSH config
    ```
        ProxyJump host123
        RemoteForward  8080 127.0.0.1:22
    ```
## aria2c
```
aria2c -j5 --header="User-Agent: Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36"  
```
## Don't Starve Together Server
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
## Fritzing
```
sudo apt-get install -y qt5-default libqt5serialport5
```
## Capture Screen
Save 10 sec screenshot 
```
ffmpeg -f x11grab -i :0.0 -video_size 1024x768 -framerate 25 -t 10 output.mp4
```
Broadcast screenshot via tcp 
```
ffmpeg -f x11grab -i :0.0 -framerate 25 -video_size 1024x768 -listen 1 -f mpegts tcp://0.0.0.0:12345
```
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
### Parallelism
```
ls | head | xargs -n 1 -P 3 program_X 
# -n num of arguments for each program 
```
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
.local/bin/yt-dlp -x --audio-quality 0 https://youtu.be/SWaqajXUbaw?si=GgBxb38EhOFmHTU-
```
### Lack of so (Dynamic Link Library)
* Take libffi.so.6 as the example
```
wget http://mirrors.kernel.org/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-8_amd64.deb
ar x libffi6_3.2.1-8_amd64.deb
tar Jxf data.tar.xz 
export LD_LIBRARY_PATH=$PWD/usr/lib/x86_64-linux-gnu/
```
## Fresh Installation
```
sudo tee -a /etc/sudoers << EOF >> /dev/null
$USER ALL=(ALL:ALL) NOPASSWD:ALL
EOF
```
## How to disable Chrome Keyring?
```
Post by agordon1050 » Fri Jan 08, 2021 2:01 am 
1. Launch Passwords & Keys
2. GNUPG Keys, click back button.
3. Click +, select Password Keyring
4. Call it Default
5. Click Continue for an Empty Password & Continue again when asked if you want to store passwords unencrypted.
6. Right click on Default in the list (may have to mouse over to see choices), click Select as Default.   
```
## Key Binding
1. Know what we are typing verbatim. Press <kbd>Ctrl</kbd> + <kbd>v</kbd>. Then press left arrow <kbd>⇦</kbd>.
```
a@a:~$ ^[[D
```
2. See [this answer](https://unix.stackexchange.com/a/222903) to know what '^[[D' mean.
3. Again, press <kbd>Ctrl</kbd> + <kbd>v</kbd>. Then press <kbd>Alt</kbd> + <kbd>b</kbd>. 

```
a@a:~$ ^[b
```
4. Bind key but replace <kbd>^[</kbd> with <kbd>\e</kbd>
```
a@a:~$ bind '"\e[D":"\eb"'
```
5. Now, the function of key <kbd>⇦</kbd> equals to <kbd>Alt</kbd> + <kbd>b</kbd>.
## Default Application
* When I removed firefox from my Ubuntu_aarch64, my apps in it cannot get a default web browser to login when it is needed. 
* How can I install a web browser manually and make it the default in my Ubuntu?
  * Get firefox in all versions [here](https://www.firefox.com/en-US/download/all/desktop-nightly/linux64-aarch64/en-US/)
  * Configure Env Var PATH so you can run firefox in CLI.
  * Copy a /usr/share/applications/firefox.desktop from any other Ubuntu machine and place it in the same spot. Voila~
## Default editor
```
sudo update-alternatives --config editor
```