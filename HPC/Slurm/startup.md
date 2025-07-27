```

parallel-ssh -i -t 0 -h /root/sys_conf/pssh_every_host_file 'hostname'
parallel-ssh -i -t 0 -h /root/sys_conf/pssh_every_host_file 'mount -t nfs login:/home /home'

sinfo

export CNT_END=56
scontrol update nodename=node-[2-$CNT_END] state=idle
sinfo

srun --nodelist=node-3 --chdir /tmp --pty /bin/bash