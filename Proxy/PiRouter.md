### PiRouter
* I have a Linux machine (Raspberry Pi) and an AP so I can make a transparent proxy router for my other devices (like Oculus 2 VR goggle)
* Env variables
  ```
  sudo su

  cat << EOF >> /root/.bashrc
  export IFNAME0=wlan0 # connect to existing network
  export IFNAME1=eth0  # connect to AP.
  EOF
  source ~/.bashrc
  echo [existed] $IFNAME0 [AP] $IFNAME1
  ```
* Every setting is ephemeral except this. Delete /etc/systemd/network/disable-dhcp-for-IFNAME1.network if you want DHCP back
  ```
  cat << EOF > /etc/systemd/network/disable-dhcp-for-IFNAME1.network
  [Match]
  Name=$IFNAME1

  [Network]
  DHCP=no
  EOF
  sudo systemctl restart systemd-networkd
  ```
#### Router First
* Configure an persistent IP for eth0
  ```
  nmcli conn del "Wired connection 1"
  nmcli connection add type ethernet con-name PiRouter ip4 192.168.3.3/24 ipv4.route-metric 50 ifname $IFNAME1
  ```
* Configure an persistent rule in kernel for packet forward
  ```
  echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf
  sysctl --system
  ```
* Configure an firewall rule for packet forward
  ```
  sudo apt-get install -y iptables
  iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o $IFNAME0 -j MASQUERADE # iptables -P FORWARD ACCEPT
  ```
* Configure DHCP service
  ```
  apt update -y && apt install -y dnsmasq

  cat << EOF > /etc/dnsmasq.conf
  bind-interfaces
  interface=$IFNAME1
  dhcp-range=$IFNAME1,192.168.3.100,192.168.3.200,255.255.255.0,6h

  # dhcp-option https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
  dhcp-option=$IFNAME1,3,192.168.3.3
  dhcp-option=$IFNAME1,6,8.8.8.8,8.8.4.4       # DHCP Option 6 (Primary DNS Server)
  EOF

  mkdir -p     /etc/systemd/system/dnsmasq.service.d
  cat << EOF > /etc/systemd/system/dnsmasq.service.d/network-online.conf
  [Unit]
  After=network-online.target
  Requires=network-online.target
  EOF
  sudo systemctl daemon-reload
  systemctl restart dnsmasq
  ```
* Check if DHCP is working
  ```
  cat /var/lib/misc/dnsmasq.leases && systemctl status dnsmasq
  ```
#### Proxy Second
* Configure
  ```
  cat << EOF >> ~/.bashrc
  export SSH_SERVER_IP=XX.XX.XX.XX
  EOF
  echo $SSH_SERVER_IP

  mkdir /root/.ssh/
  cat << EOF > /root/.ssh/config
  Host proxy
    Hostname $SSH_SERVER_IP
    User root
    TCPKeepAlive yes
    ServerAliveCountMax 1
    ServerAliveInterval 5
  EOF
  ```
* Keep.sh
  ```sh
  SSH_SERVER_IP=
  LOCAL_ID=7
  REMOTE_ID=9
  
  apt install -y pptpd screen iptables
  PATH_IP=`which ip`
  PATH_AWK=`which awk`
  PATH_CURL=`which curl`
  PATH_PPPD=`which pppd`
  PATH_SLEEP=`which sleep`
  PATH_SCREEN=`which screen`
  PATH_IPTABLES=`which iptables`

  cat << EOF > /root/keep.sh
  ${PATH_SLEEP} 50
  GATEWAY_IP=\$(${PATH_IP} route get 8.8.8.8 | ${PATH_AWK} '{ for(i=1;i<=NF;i++) if(\$i=="via"){print \$(i+1); exit} }')
  ${PATH_IP} route add ${SSH_SERVER_IP}/32 via \${GATEWAY_IP}
  ${PATH_IPTABLES} -t nat -A POSTROUTING -s 192.168.3.0/24 -o ppp${LOCAL_ID}${REMOTE_ID} -j MASQUERADE
  echo GATEWAY_IP: \${GATEWAY_IP}
  newConn() {
    echo "New Tunnel"
    ${PATH_IP} link del ppp${LOCAL_ID}${REMOTE_ID}
    ${PATH_PPPD} unit ${LOCAL_ID}${REMOTE_ID} updetach noauth silent nodeflate defaultroute replacedefaultroute pty "ssh proxy pppd unit ${REMOTE_ID}${LOCAL_ID} nodetach notty noauth" ipparam vpn 10.0.0.${LOCAL_ID}:10.0.0.${REMOTE_ID}
  }

  ${PATH_SLEEP} 10

  while true
  do
      myIP=\$(${PATH_CURL} --interface ppp${LOCAL_ID}${REMOTE_ID} ipinfo.io/ip 2>/dev/null)
      if [ "\$myIP" != "${SSH_SERVER_IP}" ]; then
          echo "[\$myIP] New Tunnel"
          newConn
      else
          echo "[\$myIP] Old Tunnel"
      fi
      ${PATH_SLEEP} 180 
  done
  EOF
  ```
* After Reboot
  ```
  # journalctl -u dnsmasq -f
  cat << EOF > startup.sh
  ${PATH_SCREEN} -dmS KEEP
  ${PATH_SCREEN} -S KEEP -X readbuf /root/keep.sh
  ${PATH_SCREEN} -S KEEP -X paste .
  EOF
  chmod 755 /root/startup.sh
  (crontab -l ; echo "@reboot /root/startup.sh") | crontab -

  screen -S keep123 -X stuff '^M'
  /proc/sys/net/ipv4/ip_forward
  ```