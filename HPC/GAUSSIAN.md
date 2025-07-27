```shell
echo "export PATH=\$PATH:/home/share/script:/home/share/bin" > /etc/profile.d/newPATH.sh
sbatch --nodelist=node-31 test.sh
  

srun --nodelist=node-31 --pty /bin/bash


grep node /etc/hosts | awk '{print $2}' > /root/sys_conf/pssh_new_host_file
parallel-ssh -i -h /root/sys_conf/pssh_new_host_file 'mkdir /s1/'
parallel-ssh -i -h /root/sys_conf/pssh_new_host_file 'chmod 777 /s1'


grep node\- *.log
grep termina *log
 
scontrol update nodename=node001 state=idle
``` 


    ```shell
    #!/bin/bash
    user_name=$1
    groupadd gau
    useradd --gid gau --create-home --shell /bin/bash $user_name
    echo -e "htu2024\nhtu2024" | passwd $user_name
    DIR123=$PWD
    cd /var/yp && make # run after new user addition
    cd $DIR123
    #userdel --remove test