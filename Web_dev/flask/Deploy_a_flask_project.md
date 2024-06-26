### Deploy a wsgi application with Apache Webserver
#### 1. Create a Flask app
##### 1.1 Install pip, apache2, mod_wsgi, and flask
```
sudo su
apt update && apt install -y python3-pip apache2 libapache2-mod-wsgi-py3
pip3 install --target /var/www/py3_mod Flask
```
##### 1.2 Test a Flask app
```python3
mkdir -p /var/www/wsgi/foo/bar
cat << EOF > /var/www/wsgi/foo/bar/__init__.py 
import sys
sys.path.append('/var/www/py3_mod')
from flask import Flask
app = Flask(__name__)
@app.route("/")
def index():
    return "FrontPage"
@app.route('/hello')
def hello():
    return "Hello World"
if __name__ == "__main__":
    app.run()
EOF
python3 /var/www/wsgi/foo/bar/__init__.py 
```
###### You will see the output
```
 * Serving Flask app "__init__" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
```
* Now we can visit http://127.0.0.1:5000/ and http://127.0.0.1:5000/hello to see the test result
#### 2. WSGI configuration
##### 2.1 A wsgi file
```python 
cat << EOF > /var/www/wsgi/foo/bar/.wsgi
#!/usr/bin/python3
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.append("/var/www/wsgi/foo")

from bar import app as application # Do not change the alias name "application" 
application.secret_key = 'Add your secret key'
EOF
```
##### 2.2 A conf file
* WSGIScriptAlias /barInURL /var/www/wsgi/foo/bar/.wsgi
``` 
cat << EOF > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
    WSGIScriptAlias /bar /var/www/wsgi/foo/bar/.wsgi
    <Directory /var/www/wsgi/foo/bar>
        Order allow,deny
        Allow from all
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    LogLevel warn
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
```
##### Bring the app online
```shell
systemctl restart apache2
```
* Now we can visit http://127.0.0.1/bar and http://127.0.0.1/bar/hello to see the test result 
##### Troubleshooting
* client denied by server configuration
```
    <Directory /var/www/wsgi/foo/bar>
        Require all granted
    </Directory>
```
