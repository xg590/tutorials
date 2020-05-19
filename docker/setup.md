# On Ubuntu 20.04 (Apr 29 2020)
Install docker and get [docker-compose](https://github.com/docker/compose/releases) (standalone) 
```
$ sudo apt update
$ sudo apt install -y docker.io
$ sudo usermod -aG docker $USER
$ wget https://github.com/docker/compose/releases/download/1.25.5/docker-compose-Linux-x86_64 -O docker-compose
$ chmod 500 docker-compose
$ sudo mv docker-compose /usr/local/bin
``` 
Test installation
```
$ newgrp docker
$ docker run hello-world
```
You get following message
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```
