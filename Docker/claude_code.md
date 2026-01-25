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
docker run --rm -it --name claude_build node:24.9.0-trixie-slim bash

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

git config --global user.name  "Xiaokang Guo"   # This info is nothing to do with GitHub
git config --global user.email "43154552+xg590@users.noreply.github.com"  # This info is nothing to do with GitHub
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8

cat << EOF > /etc/ssh/sshd_config.d/allow_root.conf
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin prohibit-password
EOF
service ssh start

ssh localhost
touch /root/.ssh/authorized_keys
sed -i 's|exec|# For ssh login\ncat /tmp/authorized_keys > /root/.ssh/authorized_keys\n\nexec|g' /usr/local/bin/docker-entrypoint.sh

curl -fsSL https://download.aicodemirror.com/env_deploy/env-install.sh | bash
npm install -g @anthropic-ai/claude-code

apt clean
rm -rf /var/lib/apt/lists/* 

docker container commit --pause --author xg590@nyu.edu --change='CMD ["/usr/sbin/sshd", "-D"]' claude_build claude:$(date "+%Y%m%d")

docker image prune -f
```
## Configure
```sh
ANTHROPIC_AUTH_TOKEN=

cat << EOF > .bashrc
export ANTHROPIC_BASE_URL="https://api.aicodemirror.com/api/claudecode"
export ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_AUTH_TOKEN"
umask 0000
cd ${PWD}
EOF
ssh-keygen -t ed25519 -C 'claude' -N '' -f .ssh.pem
```
## Run
* Start 
```sh
docker run --rm -d --name claude -p 127.0.0.1:2222:22 \
       -v $PWD:$PWD \
       -v $PWD/.bashrc:/root/.bashrc \
       -v $PWD/.ssh.pem.pub:/tmp/authorized_keys \
       claude:$(date "+%Y%m%d")
```
* Login
```sh
ssh -p 2222 -i .ssh.pem root@localhost
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