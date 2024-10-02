/sbin/iptables-save    > /root/iptables.sav
sh -c '/sbin/iptables-restore < /root/iptables.sav'
/sbin/iptables-restore < /etc/iptables/rules.v4'