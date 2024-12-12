```
cat << EOF > /etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-updates main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-backports main restricted universe multiverse

# 安全更新软件源
deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted
deb http://ports.ubuntu.com/ubuntu-ports jammy-security universe
deb http://ports.ubuntu.com/ubuntu-ports jammy-security multiverse
EOF
```