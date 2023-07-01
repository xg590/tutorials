## IKEv2
* Here is the tutorial I follows: [DigitalOcean Tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-ikev2-vpn-server-with-strongswan-on-ubuntu-22-04) 
#### Install strongSwan, set varibles, and secrets on the VPN server
```
sudo apt install -y strongswan strongswan-pki libcharon-extra-plugins libcharon-extauth-plugins libstrongswan-extra-plugins libtss2-tcti-tabrmd0 

VPN_INBOUND_IP=192.168.56.102
VPN_SUBNET=40.0.0.0/24

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
pki --self --ca --lifetime 3650 --type rsa --in  /etc/ipsec.d/private/ca-key.pem --dn "CN=strongSwan root CA" --outform pem > /etc/ipsec.d/cacerts/ca-cert.pem

pki --gen --type rsa --size 4096 --outform pem > /etc/ipsec.d/private/server-key.pem 
pki --pub --type rsa --in                        /etc/ipsec.d/private/server-key.pem | pki --issue --outform pem --lifetime 1825 \
        --flag serverAuth --flag ikeIntermediate --cacert /etc/ipsec.d/cacerts/ca-cert.pem --cakey /etc/ipsec.d/private/ca-key.pem \
        --dn "CN=$VPN_INBOUND_IP" --san @$VPN_INBOUND_IP --san $VPN_INBOUND_IP > /etc/ipsec.d/certs/server-cert.pem

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
    leftid=$VPN_INBOUND_IP
    leftcert=server-cert.pem
    leftsendcert=always
    leftsubnet=0.0.0.0/0 
    right=%any
    rightid=%any
    rightauth=eap-mschapv2
    rightsourceip=$VPN_SUBNET
    rightdns=8.8.8.8,8.8.4.4
    rightsendcert=never 
    eap_identity=%identity 
    ike=aes256-sha256-modp1024,aes256-sha1-modp1024,3des-sha1-modp1024
    esp=aes256-sha256,aes256-sha1,3des-sha1
EOF
```
#### Start the service 
```
ipsec restart
ipsec statusall
echo 1 > /proc/sys/net/ipv4/ip_forward 
iptables -t nat -A POSTROUTING -s $VPN_SUBNET -o ppp0 -j MASQUERADE 
```
#### DigitalOcean Tutorial has instructions for client setup.
### Trubleshooting
* ipsec works poorly with 32bit (armhf) raspbian OS (bullseye), use arm64 raspbian.