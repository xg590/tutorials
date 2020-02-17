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
  db:
    image: mariadb
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    restart: always
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=my_root_passwd
      - MYSQL_DATABASE=db_for_nextcloud
      - MYSQL_USER=user_in_sql_for_nextcloud
      - MYSQL_PASSWORD=passwd_in_sql_for_nextcloud

  app:
    image: nextcloud:fpm-alpine
    restart: always
    volumes:
      - nextcloud:/var/www/html
    environment:
      - MYSQL_HOST=db
      - MYSQL_DATABASE=db_for_nextcloud
      - MYSQL_USER=user_in_sql_for_nextcloud
      - MYSQL_PASSWORD=passwd_in_sql_for_nextcloud
    depends_on:
      - db

  web:
    image: nginx:alpine
    restart: always
    ports:
      - 8080:80
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - nextcloud:/var/www/html:ro
    depends_on:
      - app

volumes:
  db:
  nextcloud:
```
4. Compose a file <b>nginx.conf</b> for nginx
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
