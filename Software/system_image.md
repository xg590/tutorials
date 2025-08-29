# System image

## Download

|Name|Provider|URL|
|-|-|-|
|ubuntu-24.04.3-desktop-**arm64**.iso|Tsinghua|<a href="https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cdimage/ubuntu/releases/24.04.3/release/">https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cdimage/ubuntu/releases/24.04.3/release/</a>|
|ubuntu-24.04.3-desktop-**amd64**.iso|Tsinghua|<a href="https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/24.04.3/">https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/24.04.3/</a>|
|2025-05-13-raspios-bookworm-arm64.img.xz|Tsinghua|<a href="https://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os-images/raspios_arm64/images/raspios_arm64-2025-05-13/">https://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os-images/raspios_arm64/images/raspios_arm64-2025-05-13/</a>|
|2025-05-13-raspios-bookworm-arm64-lite.img.xz|Tsinghua|<a href="https://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os-images/raspios_lite_arm64/images/raspios_lite_arm64-2025-05-13/">https://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os-images/raspios_lite_arm64/images/raspios_lite_arm64-2025-05-13/</a>|

## Change Source

* Ubuntu24.04.3

```sh
cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.`date "+%y_%m_%d"`

cat << EOF > /etc/apt/sources.list.d/ubuntu.sources
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg 

Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg 
EOF

apt update
```

* Ubuntu22.04.5

```sh
sed -i 's/us.archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
```

* Ubuntu22.04.5

```sh
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
```
