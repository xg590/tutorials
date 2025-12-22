#### Aria2
* You must check if RPC feature of aria2c is enabled. 
  ```
  apt install aria2
  aria2c -v 
  ```
 
* Build
```shell 
git clone https://github.com/ziahamza/webui-aria2.git
docker pull alpine:3.23.0
cat << EOF > Dockerfile
FROM alpine:3.23.0
RUN apt update
RUN apt install -y aria2
RUN rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/bin/aria2c"]
CMD ["--conf-path", "/etc/aria2.conf"]
# aria2 RPC port
EXPOSE 6800/tcp
EOF
docker build -t aria2:1.36.0 .

cat << EOF > aria2.conf
dir=/tmp/Downloads
enable-rpc=true
rpc-allow-origin-all=true
disable-ipv6=true
rpc-listen-all=true
rpc-listen-port=6800
#daemon=true
EOF

docker run --rm -it -p 6800:6800/tcp -v $PWD/aria2.conf:/etc/aria2.conf --name test aria2:1.36.0


cat << EOF > Dockerfile
FROM httpd:2.4 
COPY ./webui-aria2/docs/ /usr/local/apache2/htdocs/
EXPOSE 80/tcp
EOF
docker build -t aria2webui:251214 .

# apache2
EXPOSE 80/tcp
COPY webui-aria2/docs/ /var/www/html/

``` 

```
version: "3.9"

services:
  aria2:
    build:
      context: ./aria2
    container_name: aria2
    command:
      - --conf-path
      - /etc/aria2.conf
    volumes:
      - ./aria2/aria2.conf:/etc/aria2.conf:ro
      - ./downloads:/downloads
    ports:
      - "6800:6800"
    restart: unless-stopped

  httpd:
    build:
      context: ./httpd
    container_name: httpd
    depends_on:
      - aria2
    ports:
      - "8080:80"
    volumes:
      - ./downloads:/usr/local/apache2/htdocs/downloads:ro
    restart: unless-stopped




cookies.json2txt.py --json-filename youtube.com.json

aria2c --enable-rpc=true --rpc-listen-all=true --dir=~/Download


aria2c --conf-path ~/.config/aria2.conf 

apt-get update && apt-get install -y aria2 curl #&& rm -rf /var/lib/apt/lists/*
 