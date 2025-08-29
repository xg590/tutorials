## Offline Installation of OpenSSH-server

* Download apt-offline on the online machine (Ubuntu2404) for the offline machine

  ```sh
  apt download apt-offline python3-magic # python3-magic is needed for apt-offline
  # get apt-offline_1.8.5-1_all.deb python3-magic_2%3a0.4.27-3_all.deb
  ```

* On the offline machine, create abc123.sig

  ```sh
  dpkg -i apt-offline_1.8.5-1_all.deb python3-magic_2%3a0.4.27-3_all.deb
  apt-offline set --install-packages openssh-server --update abc123.sig
  ```

* Back to the online machine. (The apt-offline_1.8.4-1_all.deb in the offical depo of Ubuntu 2204 since it has bugs. Visit https://github.com/rickysarraf/apt-offline/releases to get the latest [apt-offline](https://github.com/rickysarraf/apt-offline/releases/download/v1.8.5/apt-offline-1.8.5.tar.gz)).

  ```sh
  # sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g;s/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' abc123.sig
  apt-offline get --bundle efg456.zip abc123.sig 
  ```

* Back to the offline machine.

  ```sh
  apt-offline install efg456.zip
  apt-get install -y openssh-server
  ```

## APT source

x86 架构的源

```sh
cat << EOF > /etc/apt/sources.list 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-updates main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-backports main restricted universe multiverse 

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-security main restricted universe multiverse
EOF
```

* X86_64 Jammy

```sh
cat << EOF > /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse  
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
EOF
```

ARM等其它架构的源

```sh
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

### Troubleshooting

#### signature problem

* NO_PUBKEY

```sh
Err:1 https://mirrors.tuna.tsinghua.edu.cn/debian bookworm InRelease
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 0E98404D386FA1D9   NO_PUBKEY 6ED0E7B82643E131 NO_PUBKEY F8D2585B8783D481
```

* Solution

```sh
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
```
