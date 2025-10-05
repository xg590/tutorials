# Put Claude Code in Docker container

## Dockerize Claude Code
* Get the image
```shell
docker pull node:24.9.0-trixie-slim
docker save node:24.9.0-trixie-slim | gzip > node24.9.0-trixie-slim.amd64.tgz
docker load < node24.9.0-trixie-slim.amd64.tgz
```
* Create the container
```sh
docker run --rm -it node:24.9.0-trixie-slim bash

echo "umask 0000" > /root/.bashrc
cat << EOF > /etc/apt/sources.list.d/debian.sources
Types: deb
URIs: http://mirrors.tuna.tsinghua.edu.cn/debian
Suites: trixie trixie-updates trixie-backports
Components: main contrib
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://security.debian.org/debian-security
Suites: trixie-security
Components: main contrib
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

apt update
apt install -y curl jq openssh-server locales sudo
apt clean
rm -rf /var/lib/apt/lists/*
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8

curl -fsSL https://download.aicodemirror.com/env_deploy/env-install.sh | bash
npm install -g @anthropic-ai/claude-code
curl -s https://co.yes.vg/setup-claude-code.sh | bash -s -- --url https://co.yes.vg --key cr_920xxxx
ssh-keygen -t ed25519 -C 'claude_in_container' -N '' -f /root/.ssh/id_ed25519
cp /root/.ssh/id_ed25519 /root/.ssh/authorized_keys
service ssh start
ssh localhost

docker container commit --pause --author xg590@nyu.edu --change='CMD ["/usr/sbin/sshd", "-D"]' 6105a7f5a989 claude:sshd

docker image prune -f
```
## Run
* Start 
```sh
docker run --rm -d -v $PWD:$PWD --name claude -p 127.0.0.1:2222:22 claude:sshd
docker run --rm -d -v $PWD:$PWD --name claude -p           2222:22 claude:sshd
```
* Login
```sh
ssh -i claude_container -p 2222 localhost -l root
```