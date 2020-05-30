## Personal Understanding
* Docker supports and isolates the contained software (in a container) with independent filesystem and networking. 
* The internal port of the container could be exposed / published to the external network of host machine, so docker is a good platform to run a server program in the container. 
* Copying the container is effortless so that running a server anywhere is effortless.
## Tutorial
1. [Set up docker](https://github.com/xg590/tutorials/blob/master/docker/setup.md)
   * Install docker in Ubuntu18.04
   * Test installation
   * Get docker-compose
2. [Configure a dockerized software](https://github.com/xg590/tutorials/blob/master/docker/dockerized_nginx.md)
   * Run a nginx webserver
3. [Explore the networking](https://github.com/xg590/tutorials/blob/master/docker/networking.md)
   * Run two separate containers so that we can ping one from the another via internal network.
4. [Orchestration between containers](https://github.com/xg590/tutorials/tree/master/dockerized_nextcloud)
   * Serve Nextcloud with the assitance from Let's Encrypt, MariaDB, and Nginx. (Perfer the 5th item)
   * All containers are created from official images. No new image is created. 
5. [Build an image and use it with other containers](https://github.com/xg590/nextcloud)
   * New image is composed and build.
   * Serve Nextcloud with MariaDB and Apache.
## Quick Reference
* Get a shell ( hold down CTRL and type p followed by q to <b>detach</b> )
``` 
$ docker run -d -i -t -name new_york_city nginx bash
$ docker attach new_york_city
``` 
* Run a command
```
docker exec container_name_or_id sh -c "echo a && echo b"
```
* Stop a running container
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
d078614a4c02        nginx:latest        "nginx -g 'daemon of…"   16 minutes ago      Up 3 seconds        0.0.0.0:8080->80/tcp   new_york_univ_nginx_1
$ docker stop d078614a4c02
```
* List stopped container
```
docker container ls -f 'status=exited'
```
* Refresh containers created by [docker-compose](https://github.com/xg590/tutorials/blob/master/docker/nextcloud.md) 
```
$ docker-compose rm -v -s -f
$ docker volume ls
$ docker volume rm new_york_univ_db_volume new_york_univ_nextcloud_vol
``` 
