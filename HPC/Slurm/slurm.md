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
* Test nodes
  ```
  mkdir test
  cd    test
  cp /home/share/example/test.gjf .
  grep node /etc/hosts | awk '{print $2}' | xargs -I % cp test.gjf %.gjf 
  grep node /etc/hosts | awk '{print $2}' | xargs -I % /home/share/script/subg16c_test %.gjf 
  grep node /etc/hosts | awk '{print $2}' | xargs -I % sbatch --nodelist=% %.script 
  ``` 
* S
  ```
  sbatch --nodelist=node-11 node-11.script
  scontrol update nodename=node-[2-9],login3 state=idle
  srun --nodelist=node-11 --chdir /tmp --pty /bin/bash
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
  ```
  [xg590@log-3 ~]$ sacct --format=JobID,Start,End,Elapsed,NCPUS -j 31502997
  JobID                      Start                 End    Elapsed      NCPUS
  ------------ ------------------- ------------------- ---------- ----------
  31502997     2023-03-31T16:15:11 2023-03-31T16:15:35   00:00:24          1
  31502997.ba+ 2023-03-31T16:15:11 2023-03-31T16:15:35   00:00:24          1
  31502997.ex+ 2023-03-31T16:15:11 2023-03-31T16:15:35   00:00:24          1
  31502997.0   2023-03-31T16:15:12 2023-03-31T16:15:23   00:00:11          1
  31502997.1   2023-03-31T16:15:23 2023-03-31T16:15:35   00:00:12          1
  ``` 
* Task: For the following two jobs, one job will be finish in 23 second because only one task could be run at the same time while another job finish in 12 second because two tasks could be run at the same time. [Credit](https://stackoverflow.com/a/53759961) 
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
  ``` 
  scontrol update nodename=node-[2-57],$HOSTNAME state=idle
  ```