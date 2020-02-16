## Tutorial
1. [Set up docker](https://github.com/xg590/tutorials/blob/master/docker/setup.md)
2. [Configure a dockerized software](https://github.com/xg590/tutorials/blob/master/docker/dockerized_nginx.md)
3. [Explore the networking / Orchestration between two containers](https://github.com/xg590/tutorials/blob/master/docker/networking.md)
## Quick Reference
Get a shell ( hold down CTRL and type p followed by q to <b>detach</b> )
``` 
$ docker run -d -i -t -name new_york_city nginx bash
$ docker attach new_york_city
``` 
Stop a running container
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
d078614a4c02        nginx:latest        "nginx -g 'daemon of…"   16 minutes ago      Up 3 seconds        0.0.0.0:8080->80/tcp   new_york_univ_nginx_1
$ docker stop d078614a4c02
```
