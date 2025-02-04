[Chrominum Homepage @ dockerhub](https://hub.docker.com/r/linuxserver/chromium)
```shell
docker run -d                                               \
  --name=chromium                                           \
  --security-opt seccomp=unconfined                         \
  -e PUID=1000                                              \
  -e PGID=1000                                              \
  -e TZ=Etc/UTC                                             \
  -e DOCKER_MODS=linuxserver/mods:universal-package-install \
  -e INSTALL_PACKAGES=fonts-noto-cjk                        \
  -e LC_ALL=zh_CN.UTF-8                                     \
  -p 0.0.0.0:9000:3000                                      \
  -v $PWD:/config                                            \
  --shm-size="2gb"                                          \
  --restart unless-stopped                                  \
  lscr.io/linuxserver/chromium:latest
```
* Do not care i18n
```shell
docker run -d                                \
  --name=chromium                            \
  --security-opt seccomp=unconfined          \
  -e PUID=1000                               \
  -e PGID=1000                               \
  -e TZ=Etc/UTC                              \
  -p 0.0.0.0:9000:3000                       \
  -v $PWD:/config                            \
  --shm-size="2gb"                           \
  --restart unless-stopped                   \
  lscr.io/linuxserver/chromium:latest
```
* Stop and rerun
```shell
docker stop  chromium
docker start chromium
```
```
alias chromium='cd ~/Documents/docker_run ; rm -rf chromium ; tar xf chromium.tar ; docker run -d --rm --name=chromium --security-opt seccomp=unconfined -e PUID=1000 -e PGID=1000 -e TZ=Etc/UTC -e DOCKER_MODS=linuxserver/mods:universal-package-install -e INSTALL_PACKAGES=fonts-noto-cjk -e LC_ALL=zh_CN.UTF-8 -p 0.0.0.0:9000:3000 -v $PWD/chromium:/config --shm-size="2gb" chromium:i18n'
```