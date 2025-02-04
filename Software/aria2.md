#### Aria2
* You must check if RPC feature of aria2c is enabled. 
```
apt install aria2
aria2c -v 
```
```
cookies.json2txt.py --json-filename youtube.com.json

aria2c --enable-rpc=true     \
       --rpc-listen-all=true \
       --dir=~/Download      \
       --load-cookies=youtube.com.txt
```