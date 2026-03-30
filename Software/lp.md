172.16.100.79



host aliyun
 hostname 60.205.105.42
 user ycdl
 port 22222 

Host zzu_gpu
 HostName 127.0.0.1
 Port 30900
 proxyjump aliyun
 TCPKeepAlive yes
 ServerAliveCountMax 1
 ServerAliveInterval 5