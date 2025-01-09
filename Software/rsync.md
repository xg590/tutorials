
### Run a Rsync Server
```
cat << EOF > /etc/rsyncd.conf
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsync.log
port = 8873

[my_remote_dir]
path = /tmp/rsync
comment = Rsync files
timeout = 300
read only = false
EOF
rsync --daemon
rsync -azP /local_dir/ rsync://host:port/my_remote_dir/
```
### Client
* Rsync recurrently
```
rsync -azv --delete /mnt/e/ /mnt/h/
```
* Folder exclusion (you cannot exclude '/var/www/html/software/docker' because there is no '/var/www/html/software/docker' under '/var/www')
```
rsync -rtP --exclude 'www/html/software/docker' /var/www /media/aaa/AutoChem_Backup/
```