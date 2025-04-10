```shell
apt install tinyproxy
cat << EOF > tinyproxy.conf
Port 8080
Listen 192.168.3.3
upstream socks5 192.168.3.3:1080

Allow 192.168.3.0/24
EOF

tinyproxy -d -c tinyproxy.conf
```