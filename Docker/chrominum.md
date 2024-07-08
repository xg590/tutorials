[Chrominum Homepage @ dockerhub](https://hub.docker.com/r/linuxserver/chromium)
```shell
docker run -d \
  --name=chromium \
  --security-opt seccomp=unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e DOCKER_MODS=linuxserver/mods:universal-package-install \
  -e INSTALL_PACKAGES=fonts-noto-cjk \
  -e LC_ALL=zh_CN.UTF-8 \
  -p 0.0.0.0:3000:3000 \
  -v ${HOME}/chromium:/config \
  --shm-size="2gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/chromium:latest
```
* Stop and rerun
```shell
docker stop  chromium
docker start chromium
```