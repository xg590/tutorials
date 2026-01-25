# OpenList: A Personal Hub of Cloud Storage Services
* You need aria2
  * OpenList only lists and previews files in your cloud storage and lets you manually download through your browser. 
* You need aria2-pro and ariang
  * Aria-next-gen is the GUI frontend while aria2-pro is a downloader with RPC-support feature.
* Conf
```sh
mkdir openlist && cd openlist
cat << EOF > env.conf
# =============================================================================
# 基础配置 | Basic Configuration
# =============================================================================
# 用户和组 ID（确保文件权限正确）| User and group ID (ensure correct file permissions)
OPLISTDX_PUID=$(id -u)
OPLISTDX_PGID=$(id -g)

# 时区设置 | Timezone setting
OPLISTDX_TZ=Asia/Shanghai

# =============================================================================
# 路径配置 | Path Configuration
# =============================================================================
# 主数据目录 | Main data directory
OPLISTDX_DATA=./data

# 临时文件目录 | Temporary files directory
OPLISTDX_TEMP=./temp

# # 下载目录 | Downloads directory
OPLISTDX_DOWNLOADS=./downloads

# # =============================================================================
# # Aria2 配置 | Aria2 Configuration
# # =============================================================================
# # Aria2 RPC 密钥 | Aria2 RPC secret token
OPLISTDX_ARIA2TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo \$OPLISTDX_PUID \$OPLISTDX_PGID \$OPLISTDX_TZ \$OPLISTDX_DATA \$OPLISTDX_TEMP \$OPLISTDX_DOWNLOADS \$OPLISTDX_ARIA2TOKEN
EOF
```
* docker-compose
```sh
source env.conf
mkdir -p ${OPLISTDX_DATA}/openlist ${OPLISTDX_DATA}/aria2-pro ${OPLISTDX_TEMP}/aria2 ${OPLISTDX_TEMP}/aria2 ${OPLISTDX_DOWNLOADS}/aria2

cat << EOF > docker-compose.yml
services:
  # OpenList | OpenList Core Service
  openlist:
    image: 'openlistteam/openlist:latest'
    container_name: openlist
    volumes:
      - '${OPLISTDX_DATA}/openlist:/opt/openlist/data'
      - '${OPLISTDX_TEMP}/aria2:/opt/openlist/data/temp/aria2'
    user: '${OPLISTDX_PUID}:${OPLISTDX_PGID}'
    ports:
      - '5244:5244'
    environment:
      - TZ=${OPLISTDX_TZ}
      - UMASK=022
    restart: unless-stopped
  
  # Aria2 Downloader 
  aria2-pro:
    image: p3terx/aria2-pro
    container_name: aria2-pro
    restart: unless-stopped
    ports:
      - '6800:6800'
      - '6888:6888'
      - '6888:6888/udp'
    volumes:
      - '${OPLISTDX_DATA}/aria2-pro:/config'
      - '${OPLISTDX_DOWNLOADS}/aria2:/downloads'
      - '${OPLISTDX_TEMP}/aria2:/opt/openlist/data/temp/aria2'
    environment:
      - 'PUID=${OPLISTDX_PUID}'
      - 'PGID=${OPLISTDX_PGID}'
      - 'TZ=${OPLISTDX_TZ}'
      - 'UMASK_SET=022'
      - 'RPC_SECRET=${OPLISTDX_ARIA2TOKEN}'
      - 'RPC_PORT=6800'
      - 'LISTEN_PORT=6888'
  
  # Aria2 WebUI
  ariang:
    container_name: ariang
    image: p3terx/ariang
    command: --port 6880
    ports:
      - 6880:6880
    restart: unless-stopped
    environment:
      - 'PUID=${OPLISTDX_PUID}'
      - 'PGID=${OPLISTDX_PGID}'
      - 'TZ=${OPLISTDX_TZ}'
    logging:
      driver: json-file
      options:
        max-size: 1m
    depends_on:
      - aria2-pro
EOF
```
```sh
docker-compose pull
docker save openlistteam/openlist:latest > openlistteam.tar
docker save p3terx/aria2-pro             > aria2pro.tar
docker save p3terx/ariang                > aria2ui.tar
```
```sh
docker-compose up -d
```
### Test AriaNg
* Curl
```sh
$ curl -X POST http://localhost:6800/jsonrpc \
  -H 'Content-Type: application/json' \
  -d '{
    "jsonrpc": "2.0",
    "id": "test",
    "method": "aria2.getVersion",
    "params": ["token:iweuxmDg57t1Fei1DATl9BXq2cKJmwVQ"]
  }'
```
* Right response
```sh
{"id":"test","jsonrpc":"2.0","result":{"enabledFeatures":["Async DNS","BitTorrent","Firefox3 Cookie","GZip","HTTPS","Message Digest","Metalink","XML-RPC","SFTP"],"version":"1.36.0"}} 
```
* Authorization failed
```sh
{"id":"test","jsonrpc":"2.0","error":{"code":1,"message":"Unauthorized"}}
```
### Use AiraNg in Browser
* Visit http://192.168.3.3:6880
  * Left panel: AriaNg -> Settings -> AriaNg Settings -> Global -> RPC (HostIP:6800) -> Aria2 RPC Secret Token : iweuxmDg57t1Fei1DATl9BXq2cKJmwVQ
### Use OpenList
1. The first time you run `docker-compose up -d` you should run `docker logs openlist` to see the admin’s info thereafter
```sh
Successfully created the admin user and the initial password is: DnyIpRI9
start HTTP server @ 0.0.0.0:5244
```
2. Not the first Run
```sh
# Randomly generate password
docker exec -it openlist ./openlist admin random

# Manually set password to `NEW_PASSWORD` (replace this)
docker exec -it openlist ./openlist admin set NEW_PASSWORD
```
### How to
* Get links for multiple flies

* [Quark](https://doc.oplist.org.cn/guide/drivers/quark)
 