cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak
cat << EOF > /etc/apt/sources.list.d/ubuntu.sources
Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopw
cat << EOF | sudo tee /etc/ssh/sshd_config.d/allow_root.conf
PubkeyAuthentication yes
PermitRootLogin prohibit-password
#PasswordAuthentication no
EOF
sudo apt autoremove -y unattended-upgrades update-notifier update-manager brltty
sudo systemctl stop    cups cups-browsed avahi-daemon.socket avahi-daemon.service
sudo systemctl disable cups cups-browsed avahi-daemon.socket avahi-daemon.service

hostnamectl set-hostname $hostname

apt install -y nvidia-driver-565-server

```

sudo apt update -y && sudo apt install -y openssh-server apache2
netsh interface portproxy add v4tov4 connectaddress=127.0.0.1 connectport=22 listenaddress=0.0.0.0 listenport=22 
netsh interface portproxy add v4tov4 connectaddress=127.0.0.1 connectport=80 listenaddress=0.0.0.0 listenport=80 
netsh advfirewall firewall add rule name="Allow sshd"  dir=in protocol=TCP action=allow localport=22
netsh advfirewall firewall add rule name="Allow httpd" dir=in protocol=TCP action=allow localport=80


```