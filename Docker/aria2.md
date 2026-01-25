#### Aria2
* Build Aria2
```sh
mkdir /tmp/aria2.1.37.0-r0
cd    /tmp/aria2.1.37.0-r0

cat << EOF > aria2.conf
dir=/Download
enable-rpc=true
rpc-allow-origin-all=true
disable-ipv6=true
rpc-listen-all=true
rpc-listen-port=6800
#daemon=true
EOF

docker pull alpine:3.23.0

cat << EOF > Dockerfile
FROM alpine:3.23.0
RUN apk add --no-cache aria2
RUN rm -rf /var/cache/apk/*
COPY aria2.conf /etc/aria2.conf
ENTRYPOINT ["/usr/bin/aria2c"]
CMD ["--conf-path", "/etc/aria2.conf"]
# aria2 RPC port
EXPOSE 6800/tcp
EOF

docker build -t aria2:1.37.0-r0 .
```
* Build Aria2webui
```
git clone https://github.com/ziahamza/webui-aria2.git

cat << EOF > Dockerfile
FROM httpd:2.4
COPY ./webui-aria2/docs/ /usr/local/apache2/htdocs/
EXPOSE 80/tcp
EOF

docker build -t httpd2.4:aria2webui251223 .
```
* YAML
```
cat << EOF > docker-compose.yaml
services:
  aria2:
    image: aria2:1.37.0-r0
    container_name: aria2
    ports:
      - "6800:6800"
    volumes:
      - ./Download:/Download
    networks:
      - aria2-net
    restart: unless-stopped

  web:
    image: httpd2.4:aria2webui251223
    container_name: webui
    ports:
      - "8080:80"
    networks:
      - aria2-net
    depends_on:
      - aria2
    restart: unless-stopped

networks:
  aria2-net:
    driver: bridge
EOF
```
* Bring things up
```
mkdir Download
docker-compose up
```