## IKEv2
* If I am playing this on <b style="color: red; font-size: large"> Raspberry Pi</b>, I will use arm64 version of Raspbian OS.
* Here is the tutorial I follows: [DigitalOcean Tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-ikev2-vpn-server-with-strongswan-on-ubuntu-22-04) 
#### Install strongSwan, set varibles and secrets on the VPN server.
```
sudo apt install -y strongswan strongswan-pki libcharon-extra-plugins libcharon-extauth-plugins libstrongswan-extra-plugins libtss2-tcti-tabrmd0 

export IKEv2_SERVER_NAME=IKEv2@${HOSTNAME}
export IKEv2_SERVER_IP=192.168.3.3
export IKEv2_SUBNET=40.0.0.0/24

echo $IKEv2_SERVER_NAME ${IKEv2_SERVER_IP} $IKEv2_SUBNET

cat << EOF > /etc/ipsec.secrets
: RSA "server-key.pem"
username123 : EAP "password321"
EOF
```
#### I will blindly run the following code. 
* DigitalOcean Tutorial has clear explanation.
* The DigitalOcean Tutorial gives a ipsec.conf that does not work well with MacOS Ventura so I replaced both ike and esp cipher suites with what I found somewhere else.
```
pki --gen --type rsa --size 4096 --outform pem > /etc/ipsec.d/private/ca-key.pem 
pki --self --ca --lifetime 3650 --type rsa --in  /etc/ipsec.d/private/ca-key.pem --dn "CN=$IKEv2_SERVER_NAME" --outform pem > /etc/ipsec.d/cacerts/ca-cert.pem

pki --gen --type rsa --size 4096 --outform pem > /etc/ipsec.d/private/server-key.pem
pki --pub --type rsa --in /etc/ipsec.d/private/server-key.pem | pki --issue --lifetime 1825 --flag serverAuth --flag ikeIntermediate --cacert /etc/ipsec.d/cacerts/ca-cert.pem --cakey /etc/ipsec.d/private/ca-key.pem --dn "CN=${IKEv2_SERVER_IP}" --san @${IKEv2_SERVER_IP} --san ${IKEv2_SERVER_IP} --outform pem > /etc/ipsec.d/certs/server-cert.pem

cp /etc/ipsec.d/cacerts/ca-cert.pem /var/www/html/ca.cer

cat << EOF > /etc/ipsec.conf
config setup
    charondebug="ike 1, knl 1, cfg 0"
    uniqueids=no

conn ikev2-vpn
    auto=add
    compress=no
    type=tunnel
    keyexchange=ikev2
    fragmentation=yes
    forceencaps=yes 
    dpdaction=clear
    dpddelay=300s
    rekey=no 
    left=%any
    leftid=${IKEv2_SERVER_IP}
    leftcert=server-cert.pem
    leftsendcert=always
    leftsubnet=0.0.0.0/0 
    right=%any
    rightid=%any
    rightauth=eap-mschapv2
    rightsourceip=${IKEv2_SUBNET}
    rightdns=8.8.8.8,8.8.4.4
    rightsendcert=never 
    eap_identity=%identity 
    ike=aes256-sha256-modp1024,aes256-sha1-modp1024,3des-sha1-modp1024
    esp=aes256-sha256,aes256-sha1,3des-sha1
EOF

cat /etc/ipsec.conf
```
#### Start the service 
```
ipsec restart ; sleep 3; ipsec statusall
```
#### Stop the service
```
ipsec stop # Stopping strongSwan IPsec...
```
#### DigitalOcean Tutorial has instructions for client setup.
* MacOS
  * Download /etc/ipsec.d/cacerts/ca-cert.pem
  * Double Click it 
  * Trust it for IP Security in Keychain Access (Default Keychain -> Login)
  * Settings -> VPN -> IKEv2 -> Server Address : 192.168.3.3, Remote ID : 192.168.3.3, Local ID : \<NULL\> , Username / Password
* Windows
  ``` 
  powershell -Command "Invoke-WebRequest  -URI 'http://192.168.3.3/ca.cer' -OutFile ca.cer "
  powershell -Command "Import-Certificate -FilePath ca.cer -CertStoreLocation 'Cert:\LocalMachine\Root' "
  powershell -Command "Add-VpnConnection  -Name 'IKEv2_123' -ServerAddress '192.168.3.3' -TunnelType IKEv2 -EncryptionLevel Maximum -RememberCredential "
  
  rasdial "IKEv2_123" "username123" "password321"
  ```
* Ubuntu
  ```
  wget http://192.168.3.3/ca.cer -O ${HOME}/.config/ca.cer
  sudo apt install -y strongswan network-manager-strongswan libcharon-extra-plugins

  cat << EOF | sudo tee /etc/IKEv2.conf
  export CONNECTION_NAME=IKEv2_123
  export VPN_SERVER_IP=192.168.3.3
  export YOUR_USERNAME=username123
  export YOUR_PASSWORD=password321
  export CA_CERT_PATH=${HOME}/.config/ca.cer
  EOF
  sudo su

  source /etc/IKEv2.conf
  nmcli connection add type vpn vpn-type IKEv2 \
    connection.autoconnect false               \
    con-name    ${CONNECTION_NAME}             \
    vpn.data    "address=${VPN_SERVER_IP}"     \
   +vpn.data    "user=${YOUR_USERNAME}"        \
    vpn.secrets "password=${YOUR_PASSWORD}"    \
   +vpn.data    "encap=yes"                    \
   +vpn.data    "ike=aes256-sha256-modp1024"   \
   +vpn.data    "ipcomp=no"                    \
   +vpn.data    "method=eap"                   \
   +vpn.data    "password-flags=0"             \
   +vpn.data    "proposal=yes"                 \
   +vpn.data    "virtual=yes"                  \
   +vpn.data    "certificate=${CA_CERT_PATH}"  \
   vpn.service-type "org.freedesktop.NetworkManager.strongswan"
 
  nmcli connection up IKEv2_123
  ```
  * Bring the VPN down
  ```
  nmcli connection down IKEv2_123
  ```  
* misc
  ```
  #sudo update-ca-certificates 
  ```