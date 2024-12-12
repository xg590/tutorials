### Proxy
* Use proxy for a container
```
docker run --env  http_proxy="socks5h://PROXYHOST:PROXYPORT" \
           --env https_proxy="socks5h://PROXYHOST:PROXYPORT" \
           --rm -it ubuntu:22.04 bash
apt update -y; apt install -y curl wget iputils-ping
docker container commit --pause --author xg590@nyu.edu <container-id> ubuntu:test
echo -n "[http] "; curl http://ipinfo.io/ip; echo -n " [https] "; curl https://ipinfo.io/ip; echo ;
```
### VPN
* Host machine
```
cat << EOF > /etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-updates main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-backports main restricted universe multiverse
# 安全更新软件源
deb http://ports.ubuntu.com/ubuntu-ports/ jammy-security main restricted universe multiverse
EOF

cat << EOF > /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse  
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
EOF

apt update 
apt install -y docker.io

export SSH_SERVER_IP=x.x.x.x
export    GATEWAY_IP=192.168.1.1
export        SUBNET=192.168.3.128/25
echo $SSH_SERVER_IP $GATEWAY_IP $SUBNET

### PERMANENT START ###
mkdir /root/.ssh/
cat << EOF > /root/.ssh/config
Host proxy
  Hostname $SSH_SERVER_IP
  User root
  TCPKeepAlive yes
  ServerAliveCountMax 1
  ServerAliveInterval 5
EOF

docker network create kr-net    \
    --driver=bridge             \
    --subnet=192.168.3.0/24     \
    --gateway 192.168.3.3       \
    --ip-range=192.168.3.128/25
docker network inspect kr-net 

iptables -P FORWARD ACCEPT
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf 
sysctl --system
echo "200 src123"              > /etc/iproute2/rt_tables.d/new123.conf
### PERMANENT END ###

### ephemeral START ###
iptables -I INPUT -i ppp555 -j DROP
iptables -I INPUT -i ppp555 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -t nat -I POSTROUTING -s 192.168.3.128/25 -o ppp555 -j MASQUERADE 

ip route add ${SSH_SERVER_IP}/32 via ${GATEWAY_IP}
pppd unit 555 updetach noauth silent nodeflate pty "/usr/bin/ssh proxy /usr/sbin/pppd unit 666 nodetach notty noauth" ipparam vpn 10.0.0.5:10.0.0.6

ip rule  add from 192.168.3.128/25 lookup src123  
ip route add default via 10.0.0.5 dev ppp555 table src123
echo "rule"; ip rule list lookup src123 ; sleep 0.1 ; echo "route" ; ip route show table src123
echo "rule"; ip rule list lookup src123 ; sleep 0.1 ; echo "route" ; ip route show table src123
### ephemeral END ###
```
* Container
```
docker pull --platform linux/aarch64 ubuntu:22.04
docker run -it --rm --name test ubuntu:22.04 bash
apt update
apt install -y ca-certificates 
apt install -y iputils-ping wget curl iproute2
docker container commit --pause 7e35a20a9b05 ubuntu:test
docker run -it --rm --network kr-net --dns=8.8.8.8 --name test ubuntu:22.04 bash
```