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
apt install -y curl jq openssh-server locales sudo git python3 python3-pip
apt clean

rm -rf /var/lib/apt/lists/*
git config --global user.name  "Xiaokang Guo"   # This info is nothing to do with GitHub
git config --global user.email "43154552+xg590@users.noreply.github.com"  # This info is nothing to do with GitHub
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8

ssh-keygen -t ed25519 -C 'claude_in_container' -N '' -f /root/.ssh/id_ed25519
cp /root/.ssh/id_ed25519.pub /root/.ssh/authorized_keys
service ssh start
ssh localhost

curl -fsSL https://download.aicodemirror.com/env_deploy/env-install.sh | bash
npm install -g @anthropic-ai/claude-code
curl -s https://co.yes.vg/setup-claude-code.sh | bash -s -- --url https://co.yes.vg --key cr_920xxxx

docker container commit --pause --author xg590@nyu.edu --change='CMD ["/usr/sbin/sshd", "-D"]' 6105a7f5a989 claude:sshd

docker image prune -f
```
## Run
* Start 
```sh
cat << EOF > .bashrc
umask 0000
cd ${PWD}
EOF
cp ~/.ssh/id_ed25519.pub ~/.ssh/.pub4claude
chmod 600                ~/.ssh/.pub4claude
sudo chown root:root     ~/.ssh/.pub4claude 
docker run --rm -d -v $PWD:$PWD --name claude -p 127.0.0.1:2222:22 -v $PWD/.bashrc:/root/.bashrc claude:sshd
```
* Login
```sh
ssh -p 2222 root@localhost
```

## Misc
```sh
docker run --rm -it --name claude_maker claude:base bash
docker container commit --pause --author xg590@nyu.edu --change='CMD ["/usr/sbin/sshd", "-D"]' claude_maker claude:v251206
```
* wsl
```sh
netsh interface portproxy add v4tov4 connectaddress=127.0.0.1 connectport=44444 listenaddress=0.0.0.0 listenport=4444

docker run -d -v $PWD:$PWD               \
           --name claude                 \
           -p 0.0.0.0:2222:22            \
           -v $PWD:$PWD                  \
           -v $PWD/.bashrc:/root/.bashrc \
           -v $HOME/.ssh/.pub4claude:/root/.ssh/authorized_keys  \
           claude:v251206

docker stop claude && docker rm claude

docker exec claude cat /root/.ssh/authorized_keys

docker exec claude ls -lh /root/.ssh
```