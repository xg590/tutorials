### Teamviewer on Ubuntu 22043 Desktop
* Sign up Teamviewer and get an account.
* Installed the Downloaded debian package of TeamViewer Host remotely
```
wget https://download.teamviewer.com/download/TeamViewer_Host_Setup_x64.exe
wget https://download.teamviewer.com/download/linux/teamviewer-host_arm64.deb 
wget https://download.teamviewer.com/download/linux/teamviewer-host_amd64.deb
sudo apt --fix-broken install teamviewer-host_xxx_amd64.deb
```
* Configure Teamviewer and assign an account to the Host
```
sudo teamviewer setup
```
* Enter login info twice remotely
```
Accept License Agreement? (y/n) y
Please enter your email / username: 
Please enter your password:
We have sent you a confirmation email containing a device authorization link.
Please enter your email / username: 
Adding this device as 'xxx' to the group 'xxx' of your account xxx. 
```
* Accept the license agreement on the remote machine 
```
sudo teamviewer license accept
```
* Disable Wayland so we do not need "allow " on the remote machine
```
cat << EOF | sudo tee -a /etc/gdm3/custom.conf 
WaylandEnable=false
EOF
reboot
```
### Misc
* Change Default lang = en
```
cat << EOF >> ~/.config/teamviewer/client.conf
[strng] SelectedLanguage = "en"
EOF
```
  