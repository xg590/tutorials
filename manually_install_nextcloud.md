Prerequisite: ubuntu 18.04.03 lts (Feb 06 2020) <br>
1. Switch to superuser<br>
```
$ sudo su
``` 
2. Stop current webserver like apache2<br>
```
# systemctl stop apache2
```
3. Install softwares<br>
```
# apt install nginx mysql-server letsencrypt -y
# apt install php-fpm php-curl php-gd php-mysql php-zip php-mbstring php-xml -y
```
4. Configure mysql<br>
4.1 Set root password for mysql<br> 
``` # mysql_secure_installation ``` <br> 
4.2 Create a database for nextcloud (you will be asked for root password set in previous stop) 
``` 
  # mysql -u root -p 
  mysql> create database database_name_you_like;
  mysql> create user 'username_you_like'@'localhost' identified by 'password_you_like';
  mysql> grant all on database_name_you_like.* to 'username_you_like'@'localhost' identified by 'password_you_like' with grant option;
  mysql> flush privileges;
  mysql> exit;
```
5. Get SSL certificate and key, then they appear at /etc/letsencrypt/live/your_domain_name/
```
# certbot certonly --standalone -d your_domain_name
```
6. Get NextCould
```
# wget https://download.nextcloud.com/server/releases/latest.zip
# unzip latest.zip -d /var/www/
# chown -R www-data:www-data /var/www/nextcloud/
```
7. Create a config of nextcloud for nginx<sup> [3]</sup>
```
# cat << EOF > /etc/nginx/sites-enabled/nextcloud
upstream php-handler {
    server unix:/var/run/php/php7.2-fpm.sock;
} 

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name your_domain_name; 

    # Use Mozilla's guidelines for SSL/TLS settings
    # https://mozilla.github.io/server-side-tls/ssl-config-generator/
    # NOTE: some settings below might be redundant
    ssl_certificate /etc/letsencrypt/live/your_domain_name/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your_domain_name/privkey.pem;  

    # Add headers to serve security related headers
    # Before enabling Strict-Transport-Security headers please read into this
    # topic first.
    # add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;" always;
    #
    # WARNING: Only add the preload option once you read about
    # the consequences in https://hstspreload.org/. This option
    # will add the domain to a hardcoded list that is shipped
    # in all major browsers and getting removed from this list
    # could take several months.
    add_header Referrer-Policy "no-referrer" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Download-Options "noopen" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Permitted-Cross-Domain-Policies "none" always;
    add_header X-Robots-Tag "none" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Remove X-Powered-By, which is an information leak
    fastcgi_hide_header X-Powered-By;

    # Path to the root of your installation
    root /var/www/nextcloud;

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # The following 2 rules are only needed for the user_webfinger app.
    # Uncomment it if you're planning to use this app.
    #rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
    #rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;

    # The following rule is only needed for the Social app.
    # Uncomment it if you're planning to use this app.
    #rewrite ^/.well-known/webfinger /public.php?service=webfinger last;

    location = /.well-known/carddav {
      return 301 $scheme://$host:$server_port/remote.php/dav;
    }
    location = /.well-known/caldav {
      return 301 $scheme://$host:$server_port/remote.php/dav;
    }

    # set max upload size
    client_max_body_size 512M;
    fastcgi_buffers 64 4K;

    # Enable gzip but do not remove ETag headers
    gzip on;
    gzip_vary on;
    gzip_comp_level 4;
    gzip_min_length 256;
    gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
    gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

    # Uncomment if your server is build with the ngx_pagespeed module
    # This module is currently not supported.
    #pagespeed off;

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
        # Avoid sending the security headers twice
        fastcgi_param modHeadersAvailable true;
        # Enable pretty urls
        fastcgi_param front_controller_active true;
        fastcgi_pass php-handler;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off;
    }

    location ~ ^\/(?:updater|oc[ms]-provider)(?:$|\/) {
        try_files $uri/ =404;
        index index.php;
    }

    # Adding the cache control header for js, css and map files
    # Make sure it is BELOW the PHP block
    location ~ \.(?:css|js|woff2?|svg|gif|map)$ {
        try_files $uri /index.php$request_uri;
        add_header Cache-Control "public, max-age=15778463";
        # Add headers to serve security related headers (It is intended to
        # have those duplicated to the ones above)
        # Before enabling Strict-Transport-Security headers please read into
        # this topic first.
        #add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;" always;
        #
        # WARNING: Only add the preload option once you read about
        # the consequences in https://hstspreload.org/. This option
        # will add the domain to a hardcoded list that is shipped
        # in all major browsers and getting removed from this list
        # could take several months.
        add_header Referrer-Policy "no-referrer" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Download-Options "noopen" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Permitted-Cross-Domain-Policies "none" always;
        add_header X-Robots-Tag "none" always;
        add_header X-XSS-Protection "1; mode=block" always;

        # Optional: Don't log access to assets
        access_log off;
    }

    location ~ \.(?:png|html|ttf|ico|jpg|jpeg|bcmap)$ {
        try_files $uri /index.php$request_uri;
        # Optional: Don't log access to other assets
        access_log off;
    }
}
EOF
```
Don't forget change your_domain_name
```
# sed -i 's/your_domain_name/???/g' /etc/nginx/sites-enabled/nextcloud
```
8. Restart nginx and php-fpm
```
# systemctl start nginx 
# systemctl start php7.2-fpm
```
Reference:
1. [Install NextCloud On Ubuntu 17.04 | 17.10 With Nginx, MariaDB And PHP](https://websiteforstudents.com/install-nextcloud-on-ubuntu-17-04-17-10-with-nginx-mariadb-and-php/)
2. [How to Install Nextcloud with Nginx on Ubuntu 18.04 LTS](https://www.howtoforge.com/tutorial/ubuntu-nginx-nextcloud/)
3. [Nginx config](https://docs.nextcloud.com/server/latest/admin_manual/installation/nginx.html)

