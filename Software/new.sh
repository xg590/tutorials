echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopw
cat << EOF | sudo tee /etc/ssh/sshd_config.d/allow_root.conf
#PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin prohibit-password
EOF
sudo apt autoremove -y unattended-upgrades update-notifier update-manager brltty
sudo systemctl stop    cups cups-browsed avahi-daemon.socket avahi-daemon.service
sudo systemctl disable cups cups-browsed avahi-daemon.socket avahi-daemon.service

hostnamectl set-hostname $hostname

apt install -y nvidia-driver-565-server