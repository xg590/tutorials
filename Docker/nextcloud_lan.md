* 
```
sudo apt update && sudo apt install apache2
cd /var/www/html
wget https://raw.githubusercontent.com/xg590/tutorials/master/Docker/dockerized_nextcloud_lan.sh
docker-compose -f nextcloud/docker-compose.yml up
```