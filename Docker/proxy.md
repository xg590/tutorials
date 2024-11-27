* Use proxy for a container
```
docker run --env  http_proxy="socks5h://PROXYHOST:PROXYPORT" \
           --env https_proxy="socks5h://PROXYHOST:PROXYPORT" \
           --rm -it ubuntu:22.04 bash
apt update -y; apt install -y curl wget iputils-ping
docker container commit --pause --author xg590@nyu.edu <container-id> ubuntu:test
echo -n "[http] "; curl http://ipinfo.io/ip; echo -n " [https] "; curl https://ipinfo.io/ip; echo ;
```



export  http_proxy="socks5h://172.17.0.1:1080"
export https_proxy="socks5h://172.17.0.1:1080"
export  HTTP_PROXY="socks5h://172.17.0.1:1080"
export HTTPS_PROXY="socks5h://172.17.0.1:1080"

docker run --env  http_proxy="socks5h://192.168.1.106:1080" \
           --env https_proxy="socks5h://192.168.1.106:1080" \
           --rm -it --name proxified_zous ubuntu:test bash

docker run --rm -it -name noproxy ubuntu:test bash

docker exec -it noproxy bash
docker exec -it proxified bash