## Apache2 & CGI (Common Gateway Interface)
### Upload  
```shell
apt install -y apache2 python3 python3-pip
a2enmod cgid 
systemctl restart apache2
sed -i 's/\/usr\/lib/\/var\/www/g' /etc/apache2/conf-available/serve-cgi-bin.conf
mkdir -p /var/www/cgi-bin /var/www/upload
```
```python
cat << EOF > /var/www/cgi-bin/save_file.py
#!/usr/bin/python3
import cgi, os
import cgitb; cgitb.enable()
form = cgi.FieldStorage()
# Get filename here.
fileitem = form['filename']
# Test if the file was uploaded
if fileitem.filename:
   # strip leading path from file name to avoid
   # directory traversal attacks
   fn = os.path.basename(fileitem.filename)
   open(f'/var/www/upload/{fn}', 'wb').write(fileitem.file.read())
   message = 'The file "' + fn + '" was uploaded successfully'
 
else:
   message = 'No file was uploaded'
 
print(f"""\
Content-Type: text/html\n
<html>
<body>
   <p>{message}</p>
</body>
</html>
""")
EOF
```
```html
cat << EOF > /var/www/html/upload.html
<html>
<body>
    <form enctype = "multipart/form-data" action = "/cgi-bin/save_file.py" method = "post">
        <p>File: <input type = "file" name = "filename" /></p>
        <p><input type = "submit" value = "Upload" /></p>
    </form>
</body>
</html>
EOF
```
```shell
chmod u+x /var/www/cgi-bin/save_file.py
chown -R www-data:www-data /var/www/cgi-bin/ /var/www/upload/
systemctl restart apache2
```
* Client side
```
echo 'curl -F "filename=@$2" https://$1/cgi-bin/save_file.py' > /usr/local/bin/upload.py
chmod 755  /usr/local/bin/upload.py
```
* [ScriptAlias](https://httpd.apache.org/docs/2.4/howto/cgi.html) 
  * Revise <i>/etc/apache2/conf-available/serve-cgi-bin.conf</i> after <i>a2enmod cgid</i>
```
The ScriptAlias directive tells Apache that a particular directory is set aside for CGI programs
```
### Boto3
```shell
# As root
pip3 install --target /var/www/additional_module boto3
cat << EOF > /usr/lib/cgi-bin/test.py
#!/usr/bin/python3
sys.path.append("/var/www/additional_module")
import boto3 
# -*- coding: UTF-8 -*- 
print("""Content-type:text/html
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
chmod o+x /usr/lib/cgi-bin/test.py
```
* Visit http://your_domain/cgi-bin/test.py  


cat << EOF > /usr/local/bin/upload.py
#!/bin/bash
curl -F "filename=@\$PWD/\$2" https://\$1/cgi-bin/save_file.py
EOF
chmod 755  /usr/local/bin/upload.py 