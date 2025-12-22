#### Aria2
* You must check if RPC feature of aria2c is enabled. 
```sh
apt-get update
apt install -y aria2 curl
rm -rf /var/lib/apt/lists/*
aria2c -v 
```
```sh
cat << EOF > ~/.config/aria2.conf
daemon=true
dir=~/Downloads
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
rpc-listen-port=6800
EOF

aria2c --conf-path ~/.config/aria2.conf
```