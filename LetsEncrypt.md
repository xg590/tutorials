Ubuntu 18.04
* Installation
```
sudo apt update
sudo apt install python-certbot-apache
sudo certbot --apache
```
* Renew cert
```
sudo letsencrypt renew
``` 
* Location of cert
  * Public cert: /etc/letsencrypt/live/your_domain_name/fullchain.pem
  * Private key: /etc/letsencrypt/live/your_domain_name/privkey.pem