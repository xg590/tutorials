```
mkdir ~/.ssh
cat << EOF > ~/.ssh/authorized_keys
ssh-ed25519 AAAAAAAAAAAAABBBBBBBBBBBBBBBCCCCCCCCCCCCCC aaa.bbb
EOF
chmod -R 700 ~/.ssh/

echo "a ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopw

cat << EOF > /etc/ssh/sshd_config.d/allow_root.conf
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin prohibit-password
EOF

systemctl restart sshd
systemctl stop    cups cups-browsed
systemctl disable cups cups-browsed
```
