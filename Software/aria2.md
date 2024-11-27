#### Aria2
* You must check if RPC feature of aria2c is enabled. 
```
apt install aria2
aria2c -v 
```
* Build from src
```
apt install libxml2-dev libcppunit-dev autoconf automake autotools-dev autopoint libtool  pkg-config libssl-dev liblzma-dev
wget https://github.com/aria2/aria2/archive/refs/heads/master.zip
autoreconf -i
./configure ARIA2_STATIC=yes --without-gnutls --with-openssl
```
```
aria2c -d ~/Downloads --enable-rpc=true --rpc-listen-all=true
```