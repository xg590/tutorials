### Install VNC on remote Ubuntu Machine (Ubuntu Desktop or Ubuntu Server)
1. Disable gfx (Graphics) shell, a.k.a, desktop environment, which is GNOME if you are running Ubuntu Desktop. Do nothing if Ubuntu Server is used. 
```
sudo systemctl set-default multi-user.target
sudo reboot
```
2. Now we are running at Runlevel 2, install Xfce (new desktop env) and VNC server
```
sudo apt install -y xfce4 xfce4-goodies tightvncserver

mkdir .vnc
cat << EOF > ~/.vnc/xstartup
#!/bin/sh
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup
```
3. Run VNC server and connect to it.



```
mkdir .vnc
cat << EOF > ~/.vnc/xstartup
#!/bin/sh

# Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# exec /etc/X11/xinit/xinitrc

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
x-window-manager &

gnome-panel &
#gnome-settings-daemon &
metacity &
nautilus &
EOF

sudo chmod +x ~/.vnc/xstartup


 