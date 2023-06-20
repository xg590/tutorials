### Point to Point Tunneling Protocol 
* PPTP Server
```
apt-get install pptpd 
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