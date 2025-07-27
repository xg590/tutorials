### trueGateway (manual/192.168.3.1)
* Setup
```
nmcli conn mod "Wired connection 1" ipv4.method  manual          \
                                    ipv4.addr   "192.168.3.1/24" \
                                    ipv4.dns     8.8.8.8
nmcli con down "Wired connection 1"
nmcli con up   "Wired connection 1"

echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf
sysctl --system
```
* After reboot
```
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o $IFNAME0 -j MASQUERADE
```
### shadowGateway (manual/192.168.3.3)
```
nmcli dev wifi con "SSID" password "PASSWORD" name "test123"
nmcli conn mod "test123" ipv4.method  manual          \
                         ipv4.addr   "192.168.3.3/24" \
                         ipv4.gateway 192.168.3.1     \
                         ipv4.dns     8.8.8.8
nmcli con up/down "test123"

apt update -y && apt install -y dnsmasq && systemctl disable dnsmasq
cat << EOF > /etc/dnsmasq.conf
bind-interfaces
interface=$IFNAME1
dhcp-range=$IFNAME1,192.168.3.100,192.168.3.200,255.255.255.0,6h
# dhcp-host=b8:ae:ed:7d:4d:5b,192.168.3.1 # MAC binding
# dhcp-option https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
dhcp-option=$IFNAME1,3,192.168.3.3
dhcp-option=$IFNAME1,6,8.8.8.8,8.8.4.4       # DHCP Option 6 (Primary DNS Server)
EOF

echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/forward123.conf
sysctl --system



```
* After reboot
```
ip route add ${SSH_SERVER_IP}/32 via ${GATEWAY_IP}
pppd unit 17 updetach noauth silent nodeflate defaultroute replacedefaultroute pty "/usr/bin/ssh proxy /usr/sbin/pppd unit 71 nodetach notty noauth" ipparam vpn 10.0.0.17:10.0.0.71

iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o ppp17 -j MASQUERADE
systemctl restart dnsmasq


(crontab -l 2>/dev/null; echo "@reboot sleep 60 && sudo bash /root/proxy/setup.sh") | crontab -
cat /var/lib/misc/dnsmasq.leases
# journalctl -u dnsmasq -f
```