### Using dockerized nextcloud vs. Dockerizing nextcloud
* Knowing how to dockerize nextcloud gives me the freedom to serve website and nextcloud at the same time
<i>/var/www/html/</i> will serves files for downloading while <i>/var/www/html/nextcloud</i> for personal cloud.
1. Build a docker image
```
Download ubuntu base image, 
update ubuntu, 
install nginx and fpm, 
copy server certificates and a nginx conf into the image. 
```
2. Nextcloud directory should be placed into the webroot
```
docker build -t my_nextcloud .
```
3. 
