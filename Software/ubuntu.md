```
https://mirror.sjtu.edu.cn/ubuntu-releases/
https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/
https://mirrors.aliyun.com/ubuntu-releases/
```
```sh
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak_`date "+%y_%m_%d"`
sudo sed -i 's/http:\/\/.*.ubuntu.com/https:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list
```
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
```
sudo apt install zlib1g-dev libjpeg-dev python3-dev 
```
```
wpa_passphrase <SSID> <KEY>
```