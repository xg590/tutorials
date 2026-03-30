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
snap list

sudo snap remove --purge firefox
sudo snap remove --purge snap-store
sudo snap remove --purge gnome-42-2204    
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge snapd-desktop-integration
sudo snap remove --purge bare
sudo snap remove --purge core22
sudo snap remove --purge snapd
```