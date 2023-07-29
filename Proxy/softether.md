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
Hub SoftEtherHub123
```
* Configure the hub named SoftEtherHub123
```
VPN Server/SoftEtherHub123>SecureNatEnable
```
* Create a user and authenticate it via password
```

VPN Server/SoftEtherHub123>UserCreate test
VPN Server/SoftEtherHub123>UserPasswordSet test
```
* Setup SSTP (VPN_Server_IP is 192.168.0.107, it could be FQDN)
```
VPN Server/SoftEtherHub123>ServerCertRegenerate 192.168.0.107
VPN Server/SoftEtherHub123>ServerCertGet ~/cert.cer 
VPN Server/SoftEtherHub123>SstpEnable yes
```
## Client Side 
* Run a batch file, which has the following content, with Admin privilege.  
```
cd %~dp0
powershell -Command "Import-Certificate -FilePath cert.cer -CertStoreLocation 'Cert:\LocalMachine\Root'"
powershell -Command "Add-VpnConnection -Name 'aliyun' -ServerAddress '1.2.3.4:5555' -TunnelType 'Sstp' -EncryptionLevel 'Required' -AuthenticationMethod MsChapv2 -RememberCredential"
rasdial "aliyun" "test@SoftEtherHub123" "password" 
pause
```