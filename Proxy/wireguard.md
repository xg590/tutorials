### Wireguard VPN
* Client Side 
```
sudo apt install wireguard-tools resolvconf
 
wg_server=192.168.56.102
privatekey_server=$(wg genkey)
publickey_server=$(echo $privatekey_server | wg pubkey)
privateKey_client=$(wg genkey)
publickey_client=$(echo $privateKey_client | wg pubkey)

sudo tee wg_server123.conf << EOF > /dev/null
[Interface]
PrivateKey = $privatekey_server
Address    = 10.0.0.1/24
PostUp     = echo "1" > /proc/sys/net/ipv4/ip_forward; iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
PostDown   = echo "0" > /proc/sys/net/ipv4/ip_forward; iptables -t nat -D POSTROUTING -o enp0s3 -j MASQUERADE
ListenPort = 51820

[Peer]
PublicKey  = $publickey_client
AllowedIPs = 10.0.0.2/32
EOF

sudo tee /etc/wireguard/wg_client456.conf << EOF > /dev/null 
[Interface]
Address    = 10.0.0.2/32
PrivateKey = $privateKey_client
DNS        = 8.8.8.8

[Peer]
PublicKey  = $publickey_server
Endpoint   = $wg_server:51820
AllowedIPs = 0.0.0.0/0, ::/0
EOF

scp wg_server123.conf $wg_server: 
```
* Server Side
```
sudo apt install -y wireguard resolvconf
sudo mv wg_server123.conf /etc/wireguard/
wg-quick up wg_server123
```
* Client Side
```
sudo su 
wg-quick up wg_client456
```
