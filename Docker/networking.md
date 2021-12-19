1. [Set up](https://github.com/xg590/tutorials/blob/master/docker/setup.md) docker-compose
2. Create a clean folder <b>new_york_univ</b> and get into it
```
$ mkdir new_york_univ
$ cd new_york_univ
```
3. Compose a file <b>docker-compose.yaml</b> for docker-compose
```
version: '3'

services:
  container1:
    container_name: container_1
    image: alpine   
    command: ash 
    networks:
      - proxy-tier
    stdin_open: true
    tty: true 

  container2:
    container_name: container_2
    image: alpine
    command: ash 
    networks:
      - proxy-tier 
    stdin_open: true
    tty: true 

networks:
  proxy-tier:

```
4. Start all containers
```
$ docker-compose up -d
```
5. Access the terminal of first container 
```
$ docker attach container_1
/ # 
```
6. Both service name <b>container2</b> and container name <b>container_2</b> are OK to ping
```
/ # ping -c 1 container2
PING container2 (172.18.0.3): 56 data bytes
64 bytes from 172.18.0.3: seq=0 ttl=64 time=0.071 ms
--- container2 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.071/0.071/0.071 ms

/ # ping -c 1 container_2
PING container_2 (172.18.0.3): 56 data bytes
64 bytes from 172.18.0.3: seq=0 ttl=64 time=0.074 ms
--- container_2 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.074/0.074/0.074 ms
```
