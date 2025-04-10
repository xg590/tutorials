apt autoremove unattended-upgrades update-notifier update-manager
systemctl disable cups cups-browsed nmbd
apt install -y nvidia-driver-565-server

echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopw

cat << EOF > /etc/ssh/sshd_config.d/allow_root.conf
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin prohibit-password
EOF