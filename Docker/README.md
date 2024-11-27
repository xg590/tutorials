## Personal Understanding
* Docker supports and isolates the contained software (in a container) with independent filesystem and networking. 
* The internal port of the container could be exposed / published to the external network of host machine, so docker is a good platform to run a server program in the container. 
* Copying the container is effortless so that running a server anywhere is effortless. 
### Architecture
* Client: Commander
  * Command example: docker run hello-world
* Daemon: Executor of commands
  * Get hello-world image from the configured registry 
* Registry: Hub of image
  * hello-world is a published image deposited in a public registry called dockerhub
### Docker objects
* Images: An image is a read-only template with instructions for creating a Docker container.
  * Each instruction is a new layer in the process of building a container
  * Change an instruction will alter the building procedure
* Container: A container is a runnable instance of an image.
  * Container has its own network interface and filesystem 
  * Varibles can be configured for a container
## Tutorial
1. [Set up docker](setup.md)
   * Install docker in Ubuntu18.04
   * Test installation
   * Get docker-compose
2. [Configure a dockerized software](dockerized_nginx.md)
   * Run a nginx webserver
3. [Explore the networking](networking.md)
   * Run two separate containers so that we can ping one from the another via internal network.
4. [Orchestration between containers](dockerized_nextcloud)
   * Serve Nextcloud with the assitance from Let's Encrypt, MariaDB, and Nginx. (Perfer the 5th item)
   * All containers are created from official images. No new image is created. 
5. [Build an image and use it with other containers](https://github.com/xg590/nextcloud)
   * New image is composed and built.
   * Serve Nextcloud with MariaDB and Apache.
6. [Deploy a flask-based web](flask.md)
   * Dockerfile and resource to build an image that runs flask
7. [Deploy a local nextcloud server](nextcloud_lan.md)
   * Run a nextcloud server in LAN.
     ``` 
     cd /var/www/html
     wget https://raw.githubusercontent.com/xg590/tutorials/master/Docker/nextcloud.sh
     bash nextcloud.sh
     docker-compose -f nextcloud/docker-compose.yml up
     ```
## Caveat
* By referring to the option "--publish [ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort | containerPort]", there is clearly no way of exposing ports on loopback interface. One should ask program that runs in container to listen on 0.0.0.0
## Quick Reference
* [Command-line reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
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
docker rm $(docker container ls -f 'status=exited' --quiet) # remove exited containers
```
* Remove untagged images
```
docker rmi $(docker images -f "dangling=true" -q)
```
* Access the shell
``` 
#           --interactive --tty  
docker exec  -i            -t   02e786c5c7b5 bash
```
* Run ss in container
```
sudo nsenter -t $(docker inspect -f '{{.State.Pid}}' new_york_city) -n ss -nplt
```
* Refresh containers created by [docker-compose](https://github.com/xg590/tutorials/blob/master/docker/nextcloud.md) 
```
$ docker-compose rm -v -s -f
$ docker volume ls
$ docker volume rm new_york_univ_db_volume new_york_univ_nextcloud_vol
``` 
* Publish port
  * docker run -p=[ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort | containerPort]   
``` 
  docker run -dp 192.168.xxx.xxx:4321:3000 getting-started
```
* Prune
```
docker system prune -a
```
* Inspect container
```
docker container top  container-name
docker container port container-name
```
* From container to host
```
docker cp container-name:/etc/passwd .
```
* Save and container
```
docker container ls 
docker container ls -f 'status=exited'
docker export container-id > foo.tar
docker import foo.tar put_any_name_here:latest
```
* Save and load image
```
docker image ls
docker save image-id > bar.tar
docker load < bar.tar
```
* Migrate
```
docker container ls
docker commit container-id nextcloud
docker save nextcloud > nextcloud.tar
docker load --input nextcloud.tar
docker-compose.yml
   image: nextcloud
```
* ENTRYPOINT vs CMD
  * The ENTRYPOINT specifies a command that will always be executed when the container starts. The CMD specifies arguments that will be fed to the ENTRYPOINT.
```yaml
FROM debian:wheezy
ENTRYPOINT ["/bin/ping"]
CMD ["localhost"]
```
* Change settings
```
mkdir /mnt/docker_root123
cat << EOF > /etc/docker/daemon.json
{
  "data-root": "/mnt/docker_root123"
}
EOF
systemctl daemon-reload && systemctl restart docker
docker info -f '{{ .DockerRootDir}}'
```
* Change container's setting
```
docker inspect -f "{{json .HostConfig}}" <container_name> # old settings
docker inspect -f "{{.ID}}" <container_name> # Get the hash of container
docker stop                 <container_name>
vim /var/lib/docker/containers/<container_hash>/hostconfig.json
systemctl restart docker
docker inspect -f "{{json .HostConfig}}" <container_name> # new settings
docker inspect -f "{{json .HostConfig.PortBindings}}" <container_name>
```
* Tag an image
```
docker image tag container-id gsa:v0
```