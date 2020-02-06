Prerequisite: ubuntu 18.04.03 lts (Feb 06 2020) 
```
# systemctl stop apache2 
# systemctl disable apache2
# apt install mysql-server nginx letsencrypt -y
# apt install php-fpm php-curl php-gd php-mysql php-zip php-mbstring php-xml
Configure mysql
# mysql_secure_installation
Yes to all questions except being asked for a strong root password of mysql
# mysql -u root -p
Input root password we set in the previous step
Now we are creating a database for nextcloud and colored texts will be used latter
mysql> create database db_name_we_like;
mysql> create user 'username_we_like'@'localhost' identified by 'password_we_like';
mysql> grant all on db_name_we_like.* to 'username_we_like'@'localhost' identified by 'password_we_like' with grant option;
mysql> flush privileges;
mysql> exit;

# wget https://download.nextcloud.com/server/releases/latest.zip
# unzip latest.zip -d /var/www/
# chown -R www-data:www-data /var/www/nextcloud/
 
# certbot certonly --standalone -d your_domain_name
Now we get SSL certificate and key at /etc/letsencrypt/live/your_domain_name/
```
stop apache2 for SSL chanllenge 
