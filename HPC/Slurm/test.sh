
useradd --gid gxk --create-home --shell /bin/bash xg590
echo -e "abc123\nabc123" | passwd xg590
DIR123=$PWD
cd /var/yp && make # run after new user addition
cd $DIR123

 
for i in `seq 2 $CNT_END`; do echo $i; ssh node-$i ls -l /s1; done

 | xargs -I % ssh node-% chmod -R 777 /s1

export CNT_END=56

mkdir test_gauss && cd test_gauss
seq 2 $CNT_END | xargs -I % cp /home/share/example/test.gjf test_%.gjf
seq 2 $CNT_END | xargs -I % subg09_test                     test_%.gjf  
for i in `seq 2 $CNT_END`; do sbatch --nodelist=node-$i test_$i.script;done
grep node /etc/hosts | awk '{print $2}' | xargs -I % 



srun --nodelist=node-5 --chdir /tmp --pty /bin/bash


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