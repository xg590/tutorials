## SoftEther VPN (Server and Client)
* Linux Server   : A vpnserver on one Ubuntu 22.04 machine 
* Linux Client   : A vpnclient on one Ubuntu (or Raspbian Bullseye) Machine 
* Windows Client : Windows 10 has built-in client
## Server Side (batch mode, see the appendix for a step by step configuration)
* Compile
```
sudo apt-get install -y build-essential libssl-dev
tar zxvf softether-vpnserver-v4.42-9798-rtm-2023.06.30-linux-x64-64bit.tar.gz
cd vpnserver 
make # only [hamcore.se2, vpncmd, vpnserver] are necessary. 
```
* Make Configuration Files
```
IP=$VPN_Server_IP # Public IP or FQDN of VPN Server 
passwd1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1) # password of VPN Hub
passwd2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1) # password of User 1
passwd3=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1) # password of User 2

# For Linux server: Configure the server 
cat << EOF > server123.cmd
HubCreate Hub123 /PASSWORD:$passwd1
Hub Hub123
SecureNatEnable
DhcpSet /START:192.168.30.100 /END:192.168.30.200 /MASK:255.255.255.0 /EXPIRE:7200 /GW:192.168.30.33 /DNS:8.8.8.8 /DNS2:8.8.4.4 /DOMAIN: /LOG:yes 
UserCreate user123 /GROUP:none /REALNAME:none /NOTE:none
UserCreate user456 /GROUP:none /REALNAME:none /NOTE:none
UserPasswordSet user123 /PASSWORD:$passwd2
UserPasswordSet user456 /PASSWORD:$passwd3
ServerCertRegenerate $IP
ServerCertGet \tmp\vpn123.cer
SstpEnable yes
EOF

# For Linux user: Configure the vpn connection
cat << EOF > /tmp/client123.cmd
NicCreate Adapter123 # Create a VPN interface for the Linux (why we need root privilege?)
AccountCreate conn123 /SERVER:$IP:5555 /HUB:Hub123 /USERNAME:user123 /NICNAME:Adapter123
AccountPasswordSet conn123 /PASSWORD:$passwd2 /TYPE:standard 
CertAdd \tmp\vpn123.cer # Use backslash instead of slash
AccountServerCertEnable conn123 
AccountStartupSet conn123
AccountConnect conn123
EOF

# For Windows user: Configure the vpn connection
cat << EOF > /tmp/vpn_add.bat
cd %~dp0
REM powershell -Command "Invoke-WebRequest -URI 'http://$IP/vpn123.cer' -OutFile vpn123.cer"
powershell -Command "Import-Certificate -FilePath vpn123.cer -CertStoreLocation 'Cert:\LocalMachine\Root'"
powershell -Command "Add-VpnConnection -Name 'conn123' -TunnelType 'Sstp' -EncryptionLevel 'Required' -AuthenticationMethod MsChapv2 -RememberCredential -ServerAddress '$IP:5555'"
pause
EOF

cat << EOF > /tmp/vpn_connect.bat
rasdial "conn123" "user456@Hub123" "$passwd3" 
pause
EOF
```
* Configure softether in user-mode (privileged port (443) will not be used) on VPN Server
```
# Start a server at localhost:5555 
./vpnserver start
# Connect to vpnserver and configure it
./vpncmd localhost:5555 /SERVER /IN:server123.cmd
# Pay attention to the print which saying "All checks passed. It is most likely that SoftEther VPN Server / Bridge can operate normally on this system."

# Prepare a zip file vpn123.zip (of vpn_add.bat, vpn_connect.bat, client123.cmd and vpn123.cer) for Windows user
zip ~/vpn123.zip /tmp/vpn123.cer /tmp/client123.cmd /tmp/vpn_add.bat /tmp/vpn_connect.bat
```
## Client Side - Windows
* Run vpn_add.bat with Admin privilege and run vpn_connect.bat without privilege
## Manage Server
* New users
```
./vpncmd localhost:5555
VPN Server>Hub Hub123
UserCreate user789 /GROUP:none /REALNAME:none /NOTE:none 
UserPasswordSet user789 /PASSWORD:123456 
```
## VPN Client in Batch Mode
* Compile
```
sudo su
tar zxvf softether-vpnclient-v4.42-9798-rtm-2023.06.30-linux-x64-64bit.tar.gz
unzip vpn123.zip -d /
```
* Configure the client as root
```
 # Run the client 
./vpnclient start

# Configure the client via vpncmd
./vpncmd localhost /CLIENT /IN:/tmp/client123.cmd
./vpncmd localhost /CLIENT /CMD AccountStatusGet conn123
ip addr add 192.168.30.33/24 dev vpn_adapter123
# echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/forward123.conf && sysctl --system
```
* More things
``` 
sudo su
/root/vpnclient/vpnclient start
#/root/vpnclient/vpncmd localhost /CLIENT /CMD AccountStatusGet conn123 
ip addr add 192.168.30.33/24 dev vpn_adapter123
#/root/vpnclient/vpncmd localhost /CLIENT /CMD AccountConnect conn123 
#/root/vpnclient/vpncmd localhost /CLIENT /CMD AccountDisconnect conn123 
iptables -t nat -A POSTROUTING -s 192.168.30.0/24 -o enp0s3 -j MASQUERADE  
```   