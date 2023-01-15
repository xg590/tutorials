#!/bin/bash
# Customized Envs
read -e -p "Port to serve nextcloud: " -i "12345" port

port=12345
# Randomized Envs
mysql_root_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
mysql_dbname=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
mysql_dbuser=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
mysql_dbpass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
nextcloud_admin_username=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 3 | head -n 1)$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 7 | head -n 1)
nextcloud_admin_passwd=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

mkdir nextcloud
nextcloud_dir=`realpath nextcloud`
cd $nextcloud_dir
mkdir app_123 config data

uid=`id -u`
gid=`id -g`

# Dockerfile
cat << EOF > app_123/Dockerfile
FROM ubuntu:latest
ENV TZ=America/New_York
# Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/\$TZ /etc/localtime && echo \$TZ > /etc/timezone
RUN apt update
RUN apt install -y apache2 wget \
                   php-gd       \
                   php-xml      \
                   php-zip      \
                   php-intl     \
                   php-curl     \
                   php-mysql    \
                   php-imagick  \
                   php-mbstring \
                   libapache2-mod-php
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*
RUN addgroup --gid $gid            newuser
RUN useradd  --gid $gid --uid $uid newuser
RUN chown -R newuser:newuser /var/lock/apache2
RUN chown -R newuser:newuser /var/log/apache2
RUN sed -i 's/=www-data/=newuser/g' /etc/apache2/envvars
RUN wget https://download.nextcloud.com/server/releases/latest.tar.bz2 >/dev/null 2>&1
RUN chown -R newuser:newuser /var/www/html
USER newuser
RUN tar jxvf latest.tar.bz2 -C /var/www/html/
USER root
RUN rm latest.tar.bz2
CMD ["apachectl", "-D", "FOREGROUND"]
EOF

# Config
touch config/CAN_INSTALL
cat << EOF > config/autoconfig.php
<?php
\$AUTOCONFIG = array(
  "dbtype"        => "mysql",
  "dbname"        => "$mysql_dbname",
  "dbuser"        => "$mysql_dbuser",
  "dbpass"        => "$mysql_dbpass",
  "dbhost"        => "db:3306",
  "dbtableprefix" => "",
  "adminlogin"    => "$nextcloud_admin_username",
  "adminpass"     => "$nextcloud_admin_passwd",
  "directory"     => "/var/www/html/nextcloud/data",
);
EOF

# docker-compose
cat << EOF > docker-compose.yml
version: '3'

services:
  db:
    image: mariadb
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    restart: always
    volumes:
      - db_vol:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=$mysql_root_password
      - MYSQL_DATABASE=$mysql_dbname
      - MYSQL_USER=$mysql_dbuser
      - MYSQL_PASSWORD=$mysql_dbpass
    networks:
      - intranet

  app_456:
    container_name: nextcloud
    depends_on:
      - db
    build: ./app_123
    restart: always
    ports:
      - $port:80
    volumes:
      - $nextcloud_dir/config:/var/www/html/nextcloud/config
      - $nextcloud_dir/data:/var/www/html/nextcloud/data
    networks:
      - intranet

volumes:
  db_vol:

networks:
  intranet:

EOF

cat << EOF > admin.info
How to start nextcloud:
  cd $nextcloud_dir && docker-compose up
Administration account info:
  Admin_username: $nextcloud_admin_username
  Admin_password: $nextcloud_admin_passwd
EOF
