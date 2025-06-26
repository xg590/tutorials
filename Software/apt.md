### Install mdadm for Ubuntu22.04 offline
* Download apt-offline on the online machine for the offline machine
  ```
  apt download apt-offline python3-magic 
  # get apt-offline_1.8.4-1_all.deb python3-magic_2:0.4.24-2_all.deb 
  ```
* On the offline machine 
  ```
  dpkg -i apt-offline_1.8.4-1_all.deb python3-magic_2%3a0.4.24-2_all.deb
  apt-offline   set --install-packages mdadm --update apt-offline.sig
  # apt-offline set                          --update apt-offline.sig # if you want to update the repo
  # apt-offline set --upgrade                --update apt-offline.sig
  ```
* Back to the online machine. 
  * The apt-offline_1.8.4-1_all.deb in the offical depo of Ubuntu 2204 since it has bugs.
  * Visit https://github.com/rickysarraf/apt-offline/releases to get the latest [apt-offline](https://github.com/rickysarraf/apt-offline/releases/download/v1.8.5/apt-offline-1.8.5.tar.gz). 
  ```
  tar zxvf apt-offline-1.8.5.tar.gz
  ./apt-offline/apt-offline get --bundle bundle.zip apt-offline.sig 
  ```
* Back to the offline machine.
  ```
  apt-offline install bundle.zip
  apt-get install mdadm
  ```
### APT source
x86 架构的源
```
cat << EOF > /etc/apt/sources.list 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-updates main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-backports main restricted universe multiverse 

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-security main restricted universe multiverse
EOF
```
ARM等其它架构的源
```
cat << EOF > /etc/apt/sources.list 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-updates main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-backports main restricted universe multiverse

# 安全更新软件源
deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted
deb http://ports.ubuntu.com/ubuntu-ports jammy-security universe
deb http://ports.ubuntu.com/ubuntu-ports jammy-security multiverse
EOF
```
在 Ubuntu 24.04 之前，Ubuntu 的软件源配置文件使用传统的 One-Line-Style，路径为 /etc/apt/sources.list；从 Ubuntu 24.04 开始，Ubuntu 的软件源配置文件变更为 DEB822 格式，路径为 /etc/apt/sources.list.d/ubuntu.sources。