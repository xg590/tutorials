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
make 
```
* Configure softether in user-mode (privileged port (443) will not be used)
```
./vpnserver start # start a server at localhost:5555

cat << EOF > server123.cmd
HubCreate Hub123 /PASSWORD:abc123
Hub Hub123
SecureNatEnable
DhcpSet /START:192.168.30.100 /END:192.168.30.200 /MASK:255.255.255.0 /EXPIRE:7200 /GW:192.168.30.33 /DNS:8.8.8.8 /DNS2:8.8.4.4 /DOMAIN: /LOG:yes 
UserCreate user123 /GROUP:none /REALNAME:none /NOTE:none
UserCreate user456 /GROUP:none /REALNAME:none /NOTE:none
UserPasswordSet user123 /PASSWORD:password321
UserPasswordSet user456 /PASSWORD:password654 
# VPN_Server_IP is 192.168.56.105, it could be FQDN 
ServerCertRegenerate 192.168.56.105
ServerCertGet \tmp\aliyun.cer
SstpEnable yes
EOF

# Connect to vpnserver and configure it
./vpncmd localhost:5555 /SERVER /IN:server123.cmd 
```
* Pay attention to the print which saying "All checks passed. It is most likely that SoftEther VPN Server / Bridge can operate normally on this system."
* Prepare a zip file aliyun.zip (of vpn_add.bat, vpn_connect.bat and aliyun.cer) for Windows user 
```
cat << EOF > /tmp/vpn_add.bat
cd %~dp0
powershell -Command "Import-Certificate -FilePath aliyun.cer -CertStoreLocation 'Cert:\LocalMachine\Root'"
powershell -Command "Add-VpnConnection -Name 'aliyun' -TunnelType 'Sstp' -EncryptionLevel 'Required' -AuthenticationMethod MsChapv2 -RememberCredential -ServerAddress '192.168.56.105:5555'"
pause
EOF

cat << EOF > /tmp/vpn_connect.bat
rasdial "aliyun" "user456@Hub123" "password654" 
pause
EOF

zip /var/www/html/aliyun.zip /tmp/aliyun.cer /tmp/vpn_add.bat /tmp/vpn_connect.bat
```
## Client Side - Windows
* Run vpn_add.bat with Admin privilege and run vpn_connect.bat without privilege
## VPN Client in Batch Mode
* Compile
```
sudo su
tar zxvf softether-vpnclient-v4.42-9798-rtm-2023.06.30-linux-x64-64bit.tar.gz
unzip aliyun.zip -d /
```
* Configure the client as root
```
./vpnclient start # Run the client 

cat << EOF > client123.cmd
# Create a VPN interface for the Linux (why we need root privilege?)
NicCreate Adapter123
AccountCreate aliyun /SERVER:192.168.56.105:5555 /HUB:Hub123 /USERNAME:user123 /NICNAME:Adapter123
AccountPasswordSet aliyun /PASSWORD:password321 /TYPE:standard 
CertAdd \tmp\aliyun.cer # Use backslash instead of slash
AccountServerCertEnable aliyun 
AccountStartupSet aliyun
AccountConnect aliyun
EOF

# Configure the client via vpncmd
./vpncmd localhost /CLIENT /IN:client123.cmd
./vpncmd localhost /CLIENT /CMD AccountStatusGet aliyun
```
* More things
``` 
sudo ip addr add 192.168.30.33/24 dev vpn_adapter123
sudo iptables -t nat -A POSTROUTING -s 192.168.30.0/24 -o enp0s8 -j MASQUERADE 
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/forward123.conf
sysctl --system
```   