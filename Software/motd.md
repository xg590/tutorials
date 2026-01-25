* Greeting
```sh
cat << EOF | sudo tee /etc/update-motd.d/99-netinfo
#!/bin/sh
echo "Network interfaces:"
ip -4 addr show | awk '/inet / {print "  "\$2"  "\$NF}'
EOF
sudo chmod +x /etc/update-motd.d/99-netinfo
```