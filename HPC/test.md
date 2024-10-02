screen -S torch2.3.0 -d -m
screen -S torch2.3.0 -X stuff "docker run -it --gpus \"device=${GPU}\" --rm -p ${PORT}:8888 -v $PWD:/workspace torch2.3.0:notebook ^M"
screen -S torch2.3.0 -X stuff "jupyter-notebook ^M"



Node- 9 10 11 13 14   15 16 8   3      4 6 7 2 


wget http://192.168.1.101/Clone.sh ; chmod 755 Clone.sh ; mv Clone.sh /usr/local/bin/

   
for i in b c d e f;do /usr/local/bin/Clone.sh /dev/sdh /dev/sd$i ;done

cat << EOF > /tmp/a.sh
rm -v /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server
systemctl restart ssh
EOF

grep node /etc/hosts | awk '{print $2}' | xargs -I % scp /tmp/a.sh %:/tmp


systemctl restart dnsmasq
sleep 5
journalctl -u dnsmasq -f 

hostnamectl set-hostname node-33


ip route add 192.168.11.0/24 via 192.168.11.1 
grep node /etc/hosts | awk '{print $2}' | xargs -I % ssh -o stricthostkeychecking=no % hostname





CNT_END=36
seq 2 $CNT_END | xargs -I % ssh-keyscan 192.168.11.%   >> /root/.ssh/known_hosts  
seq 2 $CNT_END | xargs -I % ssh-keyscan        node-%  >> /root/.ssh/known_hosts 
seq 2 $CNT_END | xargs -I % ping -c 1 -t 1 node-% 2> /dev/null && echo %
seq 2 $CNT_END | xargs -I % ssh node-% hostname 
   
CNT_END=57
CNT_BGN=2
grep node /etc/hosts | awk '{print $2}' > /root/sys_conf/pssh_new_host_file
parallel-ssh --timeout 5 -i -h a reboot

for i in `grep node /etc/hosts| awk '{print $1}' `; do echo $i ; ssh $i hostname ;done

systemctl stop  slurmctld slurmd 
seq 2 52 | xargs -I % ssh node-% systemctl restart slurmd 
systemctl start slurmctld slurmd 

ip route add 192.168.11.0/24 via 192.168.11.1 



seq 100 200 | xargs --max-procs=30 -I % ping -c 1 -t 1 192.168.11.% >> result.txt

seq 100 200 | xargs -I % ping -c 1 -t 1 192.168.11.% >> result.txt

64 bytes from 192.168.11.185 
64 bytes from 192.168.11.192 

systemctl stop  slurmctld slurmd 
 parallel-ssh -i -t 0 -h /root/sys_conf/pssh_new_host_file 'systemctl restart slurmd '
systemctl start slurmctld slurmd 
 parallel-ssh -i -t 0 -h /root/sys_conf/pssh_new_host_file 'mkdir /s1; chmod 777 /s1'
 parallel-ssh -i -t 0 -h /root/sys_conf/pssh_new_host_file 'init 0'



 parallel-ssh -i -t 0 -h /root/sys_conf/pssh_new_host_file 'df'

 for i in `seq 2 57`;do cp test.gjf test$i.gjf ;done
 for i in `seq 2 57`;do subg16c test$i.gjf ;done