* Use specific NIC
```
curl --interface eth0 http://ipinfo.io/ip
```
* Upload file through CGI
```
curl -F 'filename=@hello.txt' http://xxx.xxx.xxx.xxx/cgi-bin/save_file.py
```
* Use Socks proxy
```
curl --socks5-hostname "127.0.0.1:1080" "https://ipinfo.io/ip"
```