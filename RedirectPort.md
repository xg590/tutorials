```
# add
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 44332 
iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 443 -j REDIRECT --to-ports 44332
# del
iptables -t nat -D PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 44332 
iptables -t nat -D OUTPUT -p tcp -d 127.0.0.1 --dport 443 -j REDIRECT --to-ports 44332
```
