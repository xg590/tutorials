```cmd
ssh-keygen -t ed25519
cd .ssh
type id_ed25519.pub
( echo ) > config
notepad config

host aliyun
 hostname 60.205.xxx.xxx
 user xxx

host Office
 hostname localhost
 port 44444
 user py
 Proxyjump  aliyun
```