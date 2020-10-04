### Screenshot
* Page 1
<br/>![alt text](https://raw.githubusercontent.com/xg590/tutorials/master/AWS/Upload2S3/config.png "config")
* Page 2
<br/>![alt text](https://raw.githubusercontent.com/xg590/tutorials/master/AWS/Upload2S3/upload.png "config")
### Create a private bucket
```python
region_name    = 'ap-northeast-2'
Bucket         = 'mybucketname2077'   # Only alphanumericals
access_key_csv = 'access_key.csv'     # Path to Your Key File

import csv
with open(access_key_csv) as f:
    aws_access_key_id, aws_secret_access_key = [i for i in csv.reader(f)][1]

import boto3
from botocore.config import Config
session = boto3.Session(region_name           = region_name          ,
                        aws_access_key_id     = aws_access_key_id    ,
                        aws_secret_access_key = aws_secret_access_key)

client = session.client(service_name = 's3',
                        config       = Config(signature_version='s3v4'))


_ = client.create_bucket(Bucket=Bucket,
                         CreateBucketConfiguration={
                            'LocationConstraint': region_name
                         },
)

_ = client.put_public_access_block(Bucket=Bucket,
                                   PublicAccessBlockConfiguration={
                                       'BlockPublicAcls': True,
                                       'IgnorePublicAcls': True,
                                       'BlockPublicPolicy': True,
                                       'RestrictPublicBuckets': True
                                   })
```

### Install Apache2 && Enable Common Gateway Interface Daemon
```shell
# As root
apt install -y apache2 python3 python3-pip
a2enmod cgid
systemctl restart apache2
```
### Install Necessary Module
```shell
# As root
pip3 install --target /var/www/module_for_cgi boto3
```

### Upload Frontpage 
```html
# As root
cat << EOF > /var/www/html/s3.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Upload to S3</title>
    <style>
    #inp {height: 30px; width: 400px}
    #sub {height: 400px; width: 400px}
</style>
  </head>
  <body>
    <form enctype="multipart/form-data" action="/cgi-bin/s3.py" method="post">
      <table>
        <tr>
          <td>Key:</td>
          <td>
            <input type="text"
                   name="Key"
                   placeholder="What would be the name for your file on S3?"
                   id="inp"
            />
          </td>
        </tr>
        <tr>
          <td><span title="Which location should the file store?">Expires in min.:</span></td>
          <td><input type="text" name="ExpiresIn" value="60" id="inp"/></td>
        </tr>
        <tr>
          <td><span title="Which location should the file store?">Storage Region:</span></td>
          <td><input type="text" name="region_name" value="ap-northeast-2" id="inp"/></td>
        </tr>
        <tr>
          <td><span title="Which bucket should use to store?">Bucket name:</span></td>
          <td><input type="text" name="Bucket" value="mybucketname2077" id="inp"/></td>
        </tr>
      </table>
      <input type="submit" value="Next Step" id="sub"/>
    </form>
  </body>
</html>
EOF
```
### Upload Python Script 
```python
# As root
cat << EOF > /usr/lib/cgi-bin/s3.py
#!/usr/bin/python3
# -*- coding: UTF-8 -*-
import cgi, cgitb; cgitb.enable()
form = cgi.FieldStorage()
Key         = form['Key'].value
ExpiresIn   = form['ExpiresIn'].value
region_name = form['region_name'].value
Bucket      = form['Bucket'].value

import csv
with open('access_key.csv') as f:
    aws_access_key_id, aws_secret_access_key = [i for i in csv.reader(f)][1]

import sys
sys.path.append('/var/www/module_for_cgi')
import boto3
from botocore.config import Config
session = boto3.Session(region_name           = region_name          ,
                        aws_access_key_id     = aws_access_key_id    ,
                        aws_secret_access_key = aws_secret_access_key)
client = session.client(service_name = 's3',
                        config       = Config(signature_version='s3v4'))
download_link = client.generate_presigned_url(ClientMethod = 'get_object',
                                              Params       = {'Bucket': Bucket, 'Key': Key},
                                              ExpiresIn    = int(ExpiresIn) * 60)
upload_link   = client.generate_presigned_post(Bucket      = Bucket,
                                               Key         = Key,
                                               ExpiresIn   = int(ExpiresIn) * 60)

input_field = ''.join([f'<input type="hidden" name="{i}" value="{j}" />' for i, j in upload_link['fields'].items()])
 
print(f'''Content-type:text/html

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  </head>
  <body>
    <form action="{upload_link['url']}" method="post" enctype="multipart/form-data">
      {input_field}
      <input type="file"   name="file" style="height: 200px; width: 400px"/> <br />
      <input type="submit" name="submit" value="Upload to Amazon S3" style="height: 200px; width: 400px"/>
    </form>
  <br>Upload your file then you can share the following link so everyone can download it.<br>
  <a href="{download_link}">{download_link}</a>
  </body>
</html>''')
EOF
chmod o+x /usr/lib/cgi-bin/s3.py
```
### Put AWS Access Key in cgi-bin Folder
```shell
# As root
cat << EOF > /usr/lib/cgi-bin/access_key.csv
Access key ID,Secret access key
AKIAJDWIOJDWBRKQW,im89hw31b89h24UEBGWD9
EOF
chown www-data:www-data /usr/lib/cgi-bin/access_key.csv
```
