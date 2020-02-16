# On Ubuntu 18.04 (Feb 15 2020)
Install docker and get [docker-compose](https://github.com/docker/compose/releases) (standalone) 
```
$ sudo apt update
$ sudo apt install docker.io
$ sudo usermod -aG docker $USER
$ wget https://github.com/docker/compose/releases/download/1.25.4/docker-compose-Linux-x86_64 -O docker-compose
$ chmod 500 docker-compose
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
