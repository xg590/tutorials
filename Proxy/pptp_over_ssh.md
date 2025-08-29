# PPTP over SSH

* The SSH server (1.2.3.4) can be accessed with authorized_keys on the local machine (192.168.1.2). 
* 192.168.1.1 is the ip of local network.

```sh
sudo su
cat << EOF >> /root/.bashrc

export SSH_SERVER_IP=1.2.3.4
export GATEWAY_IP=192.168.3.1
export IKEv2_SERVER_IP=192.168.3.3
export IKEv2_SERVER_NAME=IKEv2@${HOSTNAME}
export IKEv2_SUBNET=40.0.0.0/24
export LOCAL_ID=81
export REMOTE_ID=17
EOF

vim /root/.bashrc
source ~/.bashrc
echo $SSH_SERVER_IP $GATEWAY_IP ${IKEv2_SERVER_IP} $IKEv2_SERVER_NAME $IKEv2_SUBNET $LOCAL_ID $REMOTE_ID
```

## Login the remote SSH server and configure it for proxy purpose

* Root privilege on both machines and public key authentication (SSH) are required

```sh
cat << EOF > /etc/ssh/sshd_config.d/proxy123.conf
PermitRootLogin yes
PermitTunnel yes
EOF

cat << EOF > /etc/sysctl.d/forward123.conf
net.ipv4.ip_forward = 1
EOF

iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE

systemctl restart sshd
sysctl --system
apt-get install -y pptpd
```

## Configure the local machine

```sh
mkdir /root/.ssh/
cat << EOF > /root/.ssh/config
Host proxy
  Hostname $SSH_SERVER_IP
  User root
  TCPKeepAlive yes
  ServerAliveCountMax 1
  ServerAliveInterval 5
  DynamicForward $IKEv2_SERVER_IP:1080
EOF
```

* In one command, we will create one ppp81 network interface (10.0.0.81) on local machine, create another ppp17 interface (10.0.0.17) on remote SSH Machine, link two ppp interfaces together via a SSH tunnel, and replace the default route (via gateway_ip 192.168.3.1) on local Ubuntu machine.

```sh
ip route add ${SSH_SERVER_IP}/32 via ${GATEWAY_IP}
pppd unit $LOCAL_ID updetach noauth silent nodeflate defaultroute replacedefaultroute pty "/usr/bin/ssh proxy /usr/sbin/pppd unit $REMOTE_ID nodetach notty noauth" ipparam vpn 10.0.0.$LOCAL_ID:10.0.0.$REMOTE_ID
```

* Now all traffic on the local machine is routed through SSH server

## Bring All Things Down

```sh
ip link del ppp$LOCAL_ID # Simply delete one ppp on either side
```

## Forward traffic from LAN

* [Create](./ikev2.md) a IKEv2 VPN server on the local machine so that machines in the LAN can login and hide in $IKEv2_SUBNET (40.0.0.0/24) behind the local machine.
* Configure the local machine so it will allow the traffic forwarding.

```sh
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf
sysctl --system
```

* Create a new routing table so a new default gateway can be set for it. We can then add a rule so the IKEv2 subnet will follow the new routing table.

```sh
echo -e "200 src123" > /etc/iproute2/rt_tables.d/new123.conf # Policy Routing 
```
