* Password-less access to Root
```
DATE=`date|sed 's/ /_/g'`
ssh-keygen -q -t ed25519 -C "install@$DATE" -N '' -f ~/.ssh/installation
ssh slave_node sudo mkdir /root/.ssh
echo `ssh-keygen -f ~/.ssh/installation -y` | ssh slave_node sudo tee -a /root/.ssh/authorized_keys 1>/dev/null
```
```
$ export MUNGEUSER=1001
$ groupadd -g $MUNGEUSER munge
$ useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
$ export SLURMUSER=1002
$ groupadd -g $SLURMUSER slurm
$ useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm
```
```
yum install munge munge-libs munge-devel -y

/usr/sbin/create-munge-key

scp /etc/munge/munge.key $host:/etc/munge 



chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
$ chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
$ cexec chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
$ cexec chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/

$ systemctl enable munge
$ systemctl start munge
$ cexec systemctl enable munge
$ cexec systemctl start munge

```

* Test
```
$ munge -n | unmunge
$ munge -n | ssh <somehost_in_cluster> unmunge
```