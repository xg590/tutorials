
useradd --gid gau --create-home --shell /bin/bash xg590
echo -e "abc123\nabc123" | passwd xg590
DIR123=$PWD
cd /var/yp && make # run after new user addition
cd $DIR123

 
for i in `seq 2 $CNT_END`; do echo $i; ssh node-$i ls -l /s1; done

 | xargs -I % ssh node-% chmod -R 777 /s1

export CNT_END=56


adduser --gid 1001 --home /home/share/xg590 xg590
sudo -u xg590 mkdir                  /home/share/xg590/.ssh
sudo -u xg590 ssh-keygen -t ed25519 -C '' -N '' -f /home/share/xg590/.ssh/id_ed25519
sudo -u xg590 cp /home/share/xg590/.ssh/id_ed25519 /home/share/xg590/.ssh/authorized_keys

scontrol update nodename=node-[2-$CNT_END] state=idle

echo "export PATH=$PATH:/home/share/script" >> /etc/profile.d/xg590.conf
mkdir test_gauss && cd test_gauss
CNT_BGN=100
CNT_END=189
seq $CNT_BGN $CNT_END | xargs -I % cp /home/share/example/test.gjf test_%.gjf
seq $CNT_BGN $CNT_END | xargs -I % subg09_test                     test_%.gjf  
for i in `seq $CNT_BGN $CNT_END`; do sbatch --nodelist=node-$i test_$i.script;done

ssh-keygen -t ed25519 -C 'hpc.20251219' -N '' -f ~/.ssh/id_ed25519

grep node /etc/hosts | awk '{print $2}' | xargs -I % 



srun --nodelist=node-2 --chdir $HOME --pty /bin/bash


for i in `seq 2 $CNT_END`; do echo $i; ssh node-$i ls -l /s1; done


sed -i 's/eno1/enp2s0f0/g' /etc/netplan/02-netcfg-abc.yaml
sed -i 's/enp2s0f0/eno1/g' /etc/netplan/02-netcfg-abc.yaml
    cat /var/lib/misc/dnsmasq.leases 
journalctl -u dnsmasq -f 

ssh 192.168.11.119 ip addr show dev enp2s0f0  
ssh 192.168.11.119 sed -i 's/eno1/enp2s0f0/g' /etc/netplan/02-netcfg-abc.yaml 
 

rm  /var/lib/misc/dnsmasq.leases && systemctl restart dnsmasq

seq 2 $CNT_END | xargs -I % scp sources.list 192.168.11.%:/etc/apt/sources.list

export CNT_END=56
seq 2 $CNT_END | xargs -I % ssh-keyscan 192.168.11.%   >> /root/.ssh/known_hosts  
seq 2 $CNT_END | xargs -I % ssh-keyscan        node-%  >> /root/.ssh/known_hosts  
 

ssh  192.168.11.220  shutdown --poweroff now


parallel-ssh -i -t 0 -h /root/current_host 'shutdown --poweroff now' 


seq $CNT_BGN $CNT_END| xargs -I % ssh node-% 'cat /etc/fstab'

srun --nodelist=node-3 --chdir /tmp --pty /bin/bash
srun --nodelist=node-3 --chdir /tmp --pty hostname

apt install -y munge libmunge2 libmunge-dev slurmd nfs-common nis
43 51 
 
sudo nmcli conn mod  "Wired connection 1" ipv4.method manual ipv4.addr "192.168.11.11/24" ipv4.gateway 192.168.11.1 ipv4.dns 8.8.8.8
hostnamectl set-hostname node-11


awk '{ print $3} ' /var/lib/misc/dnsmasq.leases | xargs -I % ssh-keyscan % >> /root/.ssh/known_hosts
awk '{ print $3} ' /var/lib/misc/dnsmasq.leases | xargs -I % ssh % lsb_release -a 
awk '{ print $3} ' /var/lib/misc/dnsmasq.leases | xargs -I % ssh % hostname 
awk '{ print $3} ' /var/lib/misc/dnsmasq.leases | xargs -I % ssh % init 0
 
awk '{ print $3} ' /var/lib/misc/dnsmasq.leases | xargs -I % ping -c 1 -t 1 % 2> /dev/null && echo %
for i in b c d e f g h;do echo $i;  ./clone.sh ubuntu24042.v251218.disk.img.for.dd sd$i;done 

cat /var/lib/misc/dnsmasq.leases  ; rm /var/lib/misc/dnsmasq.leases ; systemctl restart dnsmasq


echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuOpQEp+qHoqeaP3ycWMH5YyCkz4IWtZ0m8wavA+UXt hpc.251218" >> /root/.ssh/authorized_keys


seq 100 189 | xargs -I % ssh 192.168.11.% cat /tmp/.cnt
seq 100 189 | xargs -I % ssh 192.168.11.% hostname
seq 100 189 | xargs -I % ssh 192.168.11.% hostnamectl set-hostname node-%  
seq 100 189 | xargs -I % ssh-keyscan 192.168.11.% >> /root/.ssh/known_hosts


seq 100 189  | xargs -I % scp /etc/hosts node-%:/etc/hosts 
seq 100 189 | xargs -I % ssh node-% 'hostname ; showmount -e login'

seq 100 189 | xargs -I % ssh 192.168.11.% grep munge /etc/passwd

  parallel-ssh -i -t 0 -h /root/sys_conf/pssh_new_host_file 'cp /etc/passwd /etc/passwd.bak;cp /etc/group /etc/group.bak;cp /etc/shadow /etc/shadow.bak;cp /etc/gshadow /etc/gshadow.bak'

seq $CNT_BGN $CNT_END | xargs -I % scp /etc/{passwd,group,shadow,gshadow} node-%:/etc/

chown -R munge:munge /var/log/munge/ /var/lib/munge/ /etc/munge/ 

node-120 node-125 node-148 