## Running Python Script on Apache2
### Install Apache2 && Enable Common Gateway Interface Daemon && Create First Script 
```shell
# As root
apt install -y apache2 python3 python3-pip
a2enmod cgid
systemctl restart apache2
cat << EOF > /usr/lib/cgi-bin/test.py
#!/usr/bin/python3
# -*- coding: UTF-8 -*- 
print("""Content-type:text/html

<html>
    <head>
        <meta charset=\"utf-8\"> 
        <title>This is a TEST</title> 
    </head> 
    <body>
        Everything works fine! <br>
    </body> 
</html>""")
EOF
chmod o+x /usr/lib/cgi-bin/test.py
```
Visit http://your_domain/cgi-bin/test.py
### Using Additional Module  
```shell
# As root
pip3 install --target /var/www/additional_module boto3
cat << EOF > /usr/lib/cgi-bin/test.py
#!/usr/bin/python3
# -*- coding: UTF-8 -*- 
import sys
sys.path.append("/var/www/additional_module")
import boto3
print(f"""Content-type:text/html

<html>
    <head>
        <meta charset=\"utf-8\"> 
        <title>This is a TEST</title>  
    </head> 
    <body>
        Your boto3's version is {boto3.__version__} <br>
    </body> 
</html>""")
EOF
```
