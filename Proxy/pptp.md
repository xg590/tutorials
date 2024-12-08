## Point to Point Tunneling Protocol 
### Simple PPTP Server
```
apt-get install -y pptpd 
sudo tee /etc/pptpd.conf << EOF > /dev/null   
localip 20.0.0.1
remoteip 20.0.0.100-200
EOF

sudo tee /etc/ppp/pap-secrets << EOF > /dev/null
# Pick one pptp client authentication method (pap, chap, or ?)
# Any choice is as bad as others
# [username] [service] [plain-text password] [ip]  
username123 *         password321 *
username456 $HOSTNAME password654 * 
username789 $HOSTNAME password987 * 
EOF

sudo tee /etc/ppp/pptpd-options << EOF > /dev/null   
ms-dns 8.8.8.8
ms-dns 8.8.4.4
EOF

systemctl start pptpd  
```
### PPTP Client
```
apt-get install pptp-linux
cat << EOF > /etc/ppp/peers/pptp123
pty "pptp 192.168.1.2 --nolaunchpppd --debug"
name username456
password password654
remotename PPTP
noauth
debug
persist
maxfail 0
defaultroute
replacedefaultroute
usepeerdns
EOF

pon pptp123
```