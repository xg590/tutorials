1. [Set up](https://github.com/xg590/tutorials/blob/master/docker/setup.md) docker-compose
2. Create a clean folder <b>new_york_univ</b> and get into it
```
$ mkdir new_york_univ
$ cd new_york_univ
```
3. Compose a file <b>docker-compose.yaml</b> for docker-compose
```
nginx:
    image: nginx:latest
    ports:
        - "8080:80"
    volumes:
        - ./html:/html
        - ./default.conf:/etc/nginx/conf.d/default.conf
```
4. Compose a file <b>default.conf</b> for nginx
```
server {
    listen       80;
    server_name  localhost;
    location / {
        root   /html;
        index  index.html index.htm;
    }
}
```
5. Create a folder <b>html</b> for test.html
```
$ mkdir html
$ echo "Success~" > html/test.html
```
6. See what we have
```
$ find . 
./default.conf
./docker-compose.yaml
./html
./html/test.html
```
7. Start ngnix
```
$ docker-compose up
```
8. Using browser to visit http://your_domain_name:8080/test.html
