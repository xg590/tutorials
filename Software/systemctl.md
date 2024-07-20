### DNS
```
cat << EOF > /etc/systemd/network/dns123.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

systemctl restart resolv
``` 
### Remove Services, which will not start after reboot
```
systemctl disable apache2 
systemctl disable cups cups-browsed nmbd apache2 smbd
```
### Check if disabling works. Equvialent to CentOS's "chkconfig --list"
```
systemctl list-unit-files --state=enabled 
```
### Apache2 will stop instantly
```
systemctl stop apache2    
```
### Check if stopping works
```
systemctl status apache2    
```
### List running service
```
systemctl list-units --type=service --state=running
systemctl list-units --type=service --all
```
### Power behavior of Laptop
* Not suspended after close the lid
```
sudo tee -a /etc/systemd/logind.conf << EOF >> /dev/null
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=ignore
EOF
sudo systemctl restart systemd-logind
```
### Switching between CLI and GUI
#### Boot Sequence
```
Boot (Ubuntu 20.04)
  \_systemD (another init system than system V)
     |\
     | \_multi-user.target
     |        \
     |         \_startx (X session)  
     |
      \__graphical.target
             \
              \_Display Manager / graphical login manager (Xorg / Wayland)
                    \
                     \_Window Manager (X session)
```
#### Boot into text mode: 
```
sudo systemctl set-default multi-user.target 
```
#### Boot into graphical mode: 
```
sudo systemctl set-default graphical.target 
```
#### Switch to text mode from graphical mode without reboot: 
```
sudo systemctl start multi-user.target 
```
#### Oppositely, do: 
```
sudo systemctl start graphical.target
``` 