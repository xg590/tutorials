Ubuntu 20.04
* Installation
```
sudo apt update -y && apt install -y python3-certbot-apache
sudo certbot --apache --agree-tos --non-interactive --email your_email_address -d your_domain_name
```
* Renew cert
```
sudo letsencrypt renew
``` 
* Location of cert
  * Public cert: /etc/letsencrypt/live/your_domain_name/fullchain.pem
  * Private key: /etc/letsencrypt/live/your_domain_name/privkey.pem
