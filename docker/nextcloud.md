### Highlights
* All images ( mariadb / nextcloud:fpm-alpine / nginx:alpine) are official. 
* I don't like JrCs/docker-letsencrypt-nginx-proxy-companion or jwilder/nginx-proxy:alpine since I am a newcomer for docker. It's hard for me to understand other projects. 
* Use existed SSL certificate if you already have.
* Provide you a clear understanding about the orchestration.
### Summary
* Install docker
* Get ssl certificate
* Create two configuration files in a new folder
* Substitute your_domain_name in files
* Start nextcloud.
### Caveat
* docker-compose.yaml and nginx.conf are intertwined, since the nginx forward php request to nextcloud_fpm_version:9000. 
* MySQL host needed in the second service (nextcloud_fpm_version) is created by the first service (db_service).
* SSL certificate is provided to the third service (this_is_proxy_service), which starts a nginx proxy server.
* Nextcloud installation without docker is [here](https://github.com/xg590/tutorials/tree/master/nextcloud).
### Procedure
1. [Set up](https://github.com/xg590/tutorials/blob/master/docker/setup.md) docker-compose
2. Get SSL certificate and key, then they appear at /etc/letsencrypt/live/your_domain_name/
```
# apt install letsencrypt -y 
# certbot certonly --standalone -d your_domain_name
```
3. Create a clean folder <b>new_york_univ</b> and get into it
```
$ mkdir new_york_univ
$ cd new_york_univ
```
4. Compose a file <b>docker-compose.yaml</b> for docker-compose (you better change the Environment variable)
```
version: '3'

services:
  db_service: 
    container_name: db_container
    image: mariadb
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    restart: always
    volumes:
      - db_volume:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=my_root_passwd
      - MYSQL_DATABASE=db_name_for_nextcloud
      - MYSQL_USER=user_in_sql_for_nextcloud
      - MYSQL_PASSWORD=passwd_in_sql_for_nextcloud
    networks:
      - intranet_of_any_name

  nextcloud_fpm_version: 
    image: nextcloud:fpm-alpine
    restart: always
    volumes:
      - nextcloud_vol:/var/www/html
    environment:
      - MYSQL_HOST=db_container:3306
      - MYSQL_DATABASE=db_name_for_nextcloud
      - MYSQL_USER=user_in_sql_for_nextcloud
      - MYSQL_PASSWORD=passwd_in_sql_for_nextcloud
    depends_on:
      - db_service
    networks:
      - intranet_of_any_name

  this_is_proxy_service:
    image: nginx:alpine
    restart: always
    ports:
      - 443:443
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - /etc/letsencrypt/live/your_domain_name/privkey.pem:/ssl/privkey.pem
      - /etc/letsencrypt/live/your_domain_name/fullchain.pem:/ssl/fullchain.pem
      - nextcloud_vol:/var/www/html:ro
    depends_on:
      - nextcloud_fpm_version
    networks:
      - intranet_of_any_name

volumes:
  db_volume:
  nextcloud_vol:

networks:
  intranet_of_any_name:
```
5. Compose a another file <b>nginx.conf</b> for nginx
```
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
  worker_connections 768;
}
http {
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  ssl_prefer_server_ciphers on;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  gzip on;
  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;
  upstream php-handler {
    server nextcloud_fpm_version:9000;
  }
  server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name your_domain_name; 
    ssl_certificate /ssl/fullchain.pem;
    ssl_certificate_key /ssl/privkey.pem; 
	
    add_header Referrer-Policy "no-referrer" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Download-Options "noopen" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Permitted-Cross-Domain-Policies "none" always;
    add_header X-Robots-Tag "none" always;
    add_header X-XSS-Protection "1; mode=block" always;
    fastcgi_hide_header X-Powered-By;
    root /var/www/html;
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
    location = /.well-known/carddav {
      return 301 $scheme://$host:$server_port/remote.php/dav;
    }
    location = /.well-known/caldav {
      return 301 $scheme://$host:$server_port/remote.php/dav;
    }
    client_max_body_size 512M;
    fastcgi_buffers 64 4K;
    gzip on;
    gzip_vary on;
    gzip_comp_level 4;
    gzip_min_length 256;
    gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
    gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
    location / {
        rewrite ^ /index.php;
    }
    location ~ ^\/(?:build|tests|config|lib|3rdparty|templates|data)\/ {
        deny all;
    }
    location ~ ^\/(?:\.|autotest|occ|issue|indie|db_|console) {
        deny all;
    }
    location ~ ^\/(?:index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+)\.php(?:$|\/) {
        fastcgi_split_path_info ^(.+?\.php)(\/.*|)$;
        set $path_info $fastcgi_path_info;
        try_files $fastcgi_script_name =404;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $path_info;
        fastcgi_param HTTPS on;
        fastcgi_param modHeadersAvailable true;
        fastcgi_param front_controller_active true;
        fastcgi_pass php-handler;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off;
    }
    location ~ ^\/(?:updater|oc[ms]-provider)(?:$|\/) {
        try_files $uri/ =404;
        index index.php;
    }
    location ~ \.(?:css|js|woff2?|svg|gif|map)$ {
        try_files $uri /index.php$request_uri;
        add_header Cache-Control "public, max-age=15778463";
        add_header Referrer-Policy "no-referrer" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Download-Options "noopen" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Permitted-Cross-Domain-Policies "none" always;
        add_header X-Robots-Tag "none" always;
        add_header X-XSS-Protection "1; mode=block" always;
        access_log off;
    }
    location ~ \.(?:png|html|ttf|ico|jpg|jpeg|bcmap)$ {
        try_files $uri /index.php$request_uri;
        access_log off;
    }
  } 
}
```
6. Substitute <b>your_domain_name</b> in <b>docker-compose.yaml</b> and <b>nginx.conf</b>
```
$ sed -i 's/your_domain_name/???/g' docker-compose.yaml nginx.conf  
``` 
7. Start Nextcloud
```
$ docker-compose up
```
8. Using browser to visit https://your_domain_name
9. Stop Nextcloud
```
$ docker-compose stop
```
### Preserve Data
In the above docker-compose.yaml, we have
```
services:
  nextcloud_fpm_version: 
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf 
      - nextcloud_vol:/var/www/html 
```
* Mount host directory to container in volume, and the data of each user will retain at /var/www/nextcloud of host machine.
``` 
    volumes:
      - /var/www/nextcloud/data:/var/www/html/data
```
* Name a volume and the data will stay at /var/lib/docker/volumes/
``` 
    volumes:
      - nextcloud_vol:/var/www/html
```
### Refresh Nextcloud
Remove containers and volumes
```
$ docker-compose rm -v -s -f
$ docker volume ls
$ docker volume rm new_york_univ_db_volume new_york_univ_nextcloud_vol
```
