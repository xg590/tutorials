### SLURM
* Restart all nodes
  ```
  parallel-ssh -i -h /root/sys_conf/pssh_new_host_file 'init 6'
  parallel-ssh -i -h /root/sys_conf/pssh_new_host_file 'mount -t nfs login:/home /home'
  ```
* New user
  ```shell
  groupadd gau
  useradd --gid gau --create-home --shell /bin/bash test
  echo -e "abc123\nabc123" | passwd test
  DIR123=$PWD
  cd /var/yp && make # run after new user addition
  cd $DIR123
  #userdel --remove test
  ```
* New node
  ```shell
  grep node /etc/hosts | awk '{print $2}' | xargs -I % scp /etc/slurm/{slurm.conf,cgroup.conf} %:/etc/slurm/
  systemctl stop  slurmctld slurmd 
  parallel-ssh -i -h /root/sys_conf/pssh_new_host_file 'systemctl restart slurmd' 
  systemctl start slurmctld slurmd 
  ```
* Misc
  ```shell 
  grep node /etc/hosts | awk '{print $2}' | xargs -I  % sbatch --nodelist=% test.sh
  
  for i in sdb sdc sdd sde sdf sdg sdh sdi sdj ;do parted /dev/$i --script mklabel gpt;done
  ls /dev/sd 
  for i in sdb1 sdc1 sdd1 sde1 sdf1 sdg1 sdh1 sdi1 sdj1 ;do ls /dev/$i;done

  apt download slurm-client
  dpkg --contents slurm-client
  cat /var/lib/misc/dnsmasq.leases | awk '{print $3}' | xargs -I  % ping -c 1 -t 1 % 1> /dev/mull 
  cat /var/lib/misc/dnsmasq.leases | awk '{print $3}' | xargs -I  % ssh-keyscan % >> /root/.ssh/known_hosts   
  cat /var/lib/misc/dnsmasq.leases | awk '{print $3}' | xargs -I  % ssh % hostname 
  srun --nodelist=node-9 --chdir /tmp --pty /bin/bash
  journalctl -u dnsmasq -f 
  ```
* Bring up a node
  ```
  scontrol update nodename=node-[2-9],login3 state=idle
  ```
* Job detail
  ```
  [x@log-1 dir]$ scontrol show jobid 21919507
  JobId=21919507 JobName=log-1.hpc.nyu.edu-data
     UserId=x(x) GroupId=x(x) MCS_label=N/A
     Priority=14817 Nice=0 Account=users QOS=interact 
     RunTime=00:13:57 TimeLimit=00:30:00 TimeMin=N/A 
     TresPerNode=gres:gpu:rtx8000:1
  ```
* Task: For the following two jobs, [Credit](https://stackoverflow.com/a/53759961) 
  ```
  sbatch << EOF
  #!/bin/bash
  
  #SBATCH --ntasks=1
  
  srun --ntasks=1 sleep 11 & 
  srun --ntasks=1 sleep 12 &
  wait
  EOF
  
  sbatch << EOF
  #!/bin/bash
  
  #SBATCH --ntasks=2
  
  srun --ntasks=1 sleep 11 & 
  srun --ntasks=1 sleep 12 &
  wait
  EOF
  ```
  one job will be finish in 23 second because only one task could be run at the same time while another job finish in 12 second because two tasks could be run at the same time.
  ```
  [xg590@log-3 ~]$ sacct --format=JobID,Start,End,Elapsed,NCPUS -j 31502997 && \
                   sacct --format=JobID,Start,End,Elapsed,NCPUS -j 31502998
  JobID                      Start                 End    Elapsed      NCPUS
  ------------ ------------------- ------------------- ---------- ----------
  31502997     2023-03-31T16:15:11 2023-03-31T16:15:35   00:00:24          1
  31502997.ba+ 2023-03-31T16:15:11 2023-03-31T16:15:35   00:00:24          1
  31502997.ex+ 2023-03-31T16:15:11 2023-03-31T16:15:35   00:00:24          1
  31502997.0   2023-03-31T16:15:12 2023-03-31T16:15:23   00:00:11          1
  31502997.1   2023-03-31T16:15:23 2023-03-31T16:15:35   00:00:12          1
  JobID                      Start                 End    Elapsed      NCPUS
  ------------ ------------------- ------------------- ---------- ----------
  31502998     2023-03-31T16:15:11 2023-03-31T16:15:24   00:00:13          2
  31502998.ba+ 2023-03-31T16:15:11 2023-03-31T16:15:24   00:00:13          1
  31502998.ex+ 2023-03-31T16:15:11 2023-03-31T16:15:24   00:00:13          2
  31502998.0   2023-03-31T16:15:12 2023-03-31T16:15:23   00:00:11          1 # 
  31502998.1   2023-03-31T16:15:12 2023-03-31T16:15:24   00:00:12          1 #
  ``` 





  ```

    ip route add 192.168.11.0/24 via 192.168.11.1 
    iptables -P FORWARD ACCEPT
    # provide internet for subnet via the internet-connected NIC $IFNAME0
    iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o $IFNAME0 -j MASQUERADE 

parallel-ssh -i -t 0 -h /root/sys_conf/pssh_new_host_file 'hostname'
parallel-ssh -i -t 0 -h /root/sys_conf/pssh_new_host_file 'uptime'
parallel-ssh -i -t 0 -h /root/sys_conf/pssh_new_host_file 'mount -t nfs login:/home /home'

  scontrol update nodename=node-[2-57],$HOSTNAME state=idle

 for i in `seq 2 57`;do subg16c test$i.gjf ;done
    ```