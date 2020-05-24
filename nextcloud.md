Run mysql 
```
apt update && apt install -y docker.io
docker run --name db -p 127.0.0.1:33066:3306 \
           -e MYSQL_ROOT_PASSWORD=123456     \
           -e MYSQL_DATABASE=dbname          \
           -e MYSQL_USER=username            \
           -e MYSQL_PASSWORD=passwd          \
		       -it mariadb
```
Setup Nextcloud
``` 
wget https://download.nextcloud.com/server/releases/latest.tar.bz2 
mkdir /var/www/html/nextcloud 
chown www-data:www-data /var/www/html/nextcloud  
sudo -u www-data tar jxvf latest.tar.bz2 -C /var/www/html 
cat << EOF > /var/www/html/nextcloud/config/autoconfig.php
<?php
\$AUTOCONFIG = array(
  "dbtype"        => "mysql",
  "dbname"        => "dbname",
  "dbuser"        => "username",
  "dbpass"        => "passwd",
  "dbhost"        => "127.0.0.1:33066",
  "dbtableprefix" => "",
  "adminlogin"    => "admin_name",
  "adminpass"     => "admin_passwd",
  "directory"     => "/var/www/html/nextcloud/data",
); 
EOF
```
Setup Apache2
``` 
apt install -y apache2 php-gd       \
                       php-xml      \
                       php-zip      \
                       php-intl     \
                       php-curl     \
                       php-mysql    \
                       php-imagick  \
                       php-mbstring \
                       libapache2-mod-php
cat << EOF > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
	ServerName _ 
	DocumentRoot /var/www/html 
	Alias /cloud /var/www/html/nextcloud/
	<Directory /var/www/html/nextcloud/>
		# See https://docs.nextcloud.com/server/18/admin_manual/installation/source_installation.html
		Require all granted
		AllowOverride All
		Options FollowSymLinks MultiViews
		<IfModule mod_dav.c>
			Dav off
		</IfModule>
	</Directory>
    ErrorLog  ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined   
</VirtualHost> 
EOF
systemctl restart apache2
```
