## Server Side
* Compile and test SoftEther. 
* Pay attention to the print which saying "All checks passed. It is most likely that SoftEther VPN Server / Bridge can operate normally on this system."
```
sudo apt-get install -y build-essential libssl-dev
tar zxvf softether-vpnserver-v4.42-9798-rtm-2023.06.30-linux-x64-64bit.tar.gz
cd vpnserver 
make 
```
* Run softether in user-mode (privileged port (443) will not be used)
```
./vpnserver start
```
* Configure the server
```
./vpncmd
```
* Connect to vpnserver and configure it
```
>>> Select 1, 2 or 3: 1
```
* Connect to the vpnserver via port 5555 since 443 is not working in user mode
```
>>> Hostname of IP Address of Destination: localhost:5555 
```
* We haven't create virtual hub yet so don't specify anything
```
>>> Specify Virtual Hub Name: [Enter]
```
* Now we have the admin previlege of the softether server we create a moment ago and let's create a virtual hub
```
VPN Server> HubCreate SoftEtherHub123
```
* Choose hub SoftEtherHub123
```
VPN Server>Hub SoftEtherHub123
```
* Configure the hub named SoftEtherHub123
```
VPN Server/SoftEtherHub123>SecureNatEnable
```
* Create a user and authenticate it via password
```

VPN Server/SoftEtherHub123>UserCreate user123
VPN Server/SoftEtherHub123>UserPasswordSet user123 /PASSWORD "password321"
```
* Setup SSTP (VPN_Server_IP is 192.168.0.109, it could be FQDN)
```
VPN Server/SoftEtherHub123>ServerCertRegenerate 192.168.0.109
VPN Server/SoftEtherHub123>ServerCertGet \tmp\aliyun.cer
VPN Server/SoftEtherHub123>SstpEnable yes
```
## Client Side - Windows
* Run a batch file, which has the following content, with Admin privilege.  
```
cat << EOF > /var/www/html/vpn_add.bat
cd %~dp0
powershell -Command "Import-Certificate -FilePath aliyun.cer -CertStoreLocation 'Cert:\LocalMachine\Root'"
powershell -Command "Add-VpnConnection -Name 'aliyun' -TunnelType 'Sstp' -EncryptionLevel 'Required' -AuthenticationMethod MsChapv2 -RememberCredential -ServerAddress '192.168.0.109:5555'"
pause
EOF

cat << EOF > /var/www/html/vpn_connect.bat
rasdial "aliyun" "user123@SoftEtherHub123" "password321" 
pause
EOF
```
## Client Side - Linux
* Run vpnclient
```
sudo ./vpnclient start 
```
* Configure the Client
```
sudo ./vpncmd  
Select 1, 2 or 3: 2 
Hostname of IP Address of Destination: [Enter] 
```
* Create a VPN interface
```
VPN Client>NicCreate SoftEtherAdapter 
```
* Set up a connection
``` 
VPN Client>AccountCreate aliyun  
Destination VPN Server Host Name and Port Number: 192.168.0.109:5555 
Destination Virtual Hub Name: SoftEtherHub123 
Connecting User Name: user123
Used Virtual Network Adapter Name: SoftEtherAdapter 
```
* Connect to VpnServer
```
VPN Client> AccountPasswordSet aliyun /PASSWORD:password321 /TYPE:standard 
VPN Client> CertAdd \tmp\aliyun.cer # Use backslash instead of slash
VPN Client> AccountServerCertEnable aliyun 
VPN Client> AccountConnect aliyun 
VPN Client> AccountStatusGet aliyun 
VPN Client>exit
```
## Configure the Server
```
VPN Server/SoftEtherHub123>DhcpSet 
Start Point for Distributed Address Band: 192.168.3.100
End   Point for Distributed Address Band: 192.168.3.200
Subnet Mask: 255.255.255.0
Lease Limit (Seconds): 7200
Default Gateway ('none' to not set this): 192.168.30.2  
DNS Server 1 ('none' to not set this): 8.8.8.8 
DNS Server 2 ('none' to not set this): 8.8.4.4
```
