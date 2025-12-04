echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopw
sudo apt autoremove -y unattended-upgrades update-notifier update-manager
sudo systemctl stop    cups cups-browsed
sudo systemctl disable cups cups-browsed
sudo apt remove -y brltty
cat << EOF | sudo tee /etc/ssh/sshd_config.d/allow_root.conf
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin prohibit-password
EOF

hostnamectl set-hostname $hostname

apt install -y nvidia-driver-565-server

sudo systemctl disable avahi-daemon.socket avahi-daemon.service nbmd
sudo systemctl stop    avahi-daemon.socket avahi-daemon.service nbmd