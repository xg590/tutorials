# On Ubuntu 20.04 (Aug 07 2020)
Install docker and get [docker-compose](https://github.com/docker/compose/releases) (standalone) 
```
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker $USER
sudo su
wget https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-linux-x86_64 -O /usr/local/bin/docker-compose
chmod 555 /usr/local/bin/docker-compose 
# "data-root": "/path/to/your/docker"
cat << EOF > /etc/docker/daemon.json  
{
  "registry-mirrors": [
    "https://docker.nju.edu.cn/"
  ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
``` 
Test installation
```
newgrp docker
docker run hello-world
```
You get following message
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```
