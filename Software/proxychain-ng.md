```shell
apt install proxychains4

cat << EOF > proxychains4.conf
dynamic_chain
proxy_dns
[ProxyList]
socks5  192.168.3.3 1080
EOF
proxychains4 -q -f proxychains4.conf curl ipinfo.io/ip
```