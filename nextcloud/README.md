Prerequisite: ubuntu 18.04.03 lts (Feb 06 2020) <br>
1. Switch to superuser<br>
```
$ sudo su
```  
2. Install softwares<br>
```
# apt install nginx mysql-server letsencrypt -y
# apt install php-fpm php-curl php-gd php-mysql php-zip php-mbstring php-xml -y
# systemctl stop apache2
# systemctl stop nginx
```
3. Configure mysql<br>
3.1 Set root password for mysql (Yes to all)<br> 
``` # mysql_secure_installation ``` <br> 
3.2 Create a database for nextcloud (you will be asked for root password set in previous stop) 
``` 
  # mysql -u root -p 
  mysql> create database database_name_you_like;
  mysql> create user 'username_you_like'@'localhost' identified by 'password_you_like';
  mysql> grant all on database_name_you_like.* to 'username_you_like'@'localhost' identified by 'password_you_like' with grant option;
  mysql> flush privileges;
  mysql> exit;
```
4. Get SSL certificate and key, then they appear at /etc/letsencrypt/live/your_domain_name/
```
# certbot certonly --standalone -d your_domain_name
```
5. Get NextCould
```
# wget https://download.nextcloud.com/server/releases/latest.zip
# unzip latest.zip -d /var/www/
# chown -R www-data:www-data /var/www/nextcloud/
```
6. Get a config of nextcloud for nginx<sup> [3]</sup>
```
# wget https://raw.githubusercontent.com/xg590/tutorials/master/nextcloud/nextcloud.conf
# mv nginx.conf /etc/nginx/sites-enabled/
# rm /etc/nginx/sites-enabled/default
```
Don't forget change your_domain_name
```
# sed -i 's/your_domain_name/???/g' /etc/nginx/sites-enabled/nextcloud.conf
```
7. Restart nginx and php-fpm
```
# systemctl start nginx 
# systemctl start php7.2-fpm
```
Reference:
1. [Install NextCloud On Ubuntu 17.04 | 17.10 With Nginx, MariaDB And PHP](https://websiteforstudents.com/install-nextcloud-on-ubuntu-17-04-17-10-with-nginx-mariadb-and-php/)
2. [How to Install Nextcloud with Nginx on Ubuntu 18.04 LTS](https://www.howtoforge.com/tutorial/ubuntu-nginx-nextcloud/)
3. [Nginx config](https://docs.nextcloud.com/server/latest/admin_manual/installation/nginx.html)
