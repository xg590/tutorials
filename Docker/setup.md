# On Ubuntu 20.04 (Aug 07 2020)
Install docker and get [docker-compose](https://github.com/docker/compose/releases) (standalone) 
```
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker $USER
wget https://github.com/docker/compose/releases/download/1.26.2/docker-compose-Linux-x86_64 -O docker-compose
chmod 555 docker-compose 
sudo mv docker-compose /usr/local/bin/docker-compose
# "data-root": "/path/to/your/docker"
cat << EOF | sudo tee /etc/docker/daemon.json  
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
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
