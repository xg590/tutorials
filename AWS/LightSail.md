### createVM.py
```python
cat << EOF > createVM.py
#!/usr/local/bin/python3
import os, boto3, time, pandas as pd  
'''
Use AWS IAM
  -> Create a user, a usergroup and a new policy. 
  -> Attach the policy and add the user to the usergroup.
  -> Create an access key in the security credentials tab of the user.
'''
aws_access_key_id, aws_secret_access_key = pd.read_csv('~/.ssh/sailor_accessKeys.csv').iloc[0]

region_name = 'us-east-1'
# see https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/lightsail.html 
client = boto3.client('lightsail', region_name=region_name, use_ssl=True, 
                      aws_access_key_id=aws_access_key_id, 
                      aws_secret_access_key=aws_secret_access_key)
'''
df_blueprints = pd.DataFrame(client.get_blueprints()['blueprints'])
df_blueprints = df_blueprints[(df_blueprints['platform']=='LINUX_UNIX') & (df_blueprints['type']=='os')][['blueprintId', 'name', 'version', 'description']]
display(df_blueprints)

df_bundles = pd.DataFrame(client.get_bundles()['bundles'])
df_bundles = df_bundles[df_bundles['instanceType']=='nano']
display(df_bundles)
'''
response = client.create_instances(
    instanceNames=['created_from_python',],
    availabilityZone=region_name+'a',
    blueprintId='ubuntu_22_04',
    bundleId='nano_3_0',
    userData='echo "success">/home/ubuntu/test.log', # Initialization shellscript
    keyPairName='lightsail.20250129.va'
)

while 1:
    response = client.get_instance_state(instanceName='created_from_python')
    if response['state']['name'] == 'running': 
        print('New Instance is ready~')
        break
    else:
        print('New Instance not ready~') 
    time.sleep(10)

response = client.get_instance(
    instanceName='created_from_python'
)
ephemeral_ip = response['instance']['publicIpAddress']
print('tmp_ip:', ephemeral_ip)

ssh_config = f'''
host va
 hostname {ephemeral_ip}
 user ubuntu
 identityfile ~/.ssh/lightsail.20250129.va.pem
 stricthostkeychecking no
 dynamicforward 192.168.3.3:1081
'''
with open('/tmp/lightsail.conf', 'w') as fw:
    fw.write(ssh_config)
EOF


cat << EOF > ~/.bashrc
alias createVM='docker run --rm -it -v ~/.ssh/config.d:/tmp boto3:lightsail createVM'
EOF
```
### deleteVM.py and queryVM.py
```python
cat << EOF > deleteVM.py
#!/usr/local/bin/python3
import boto3, time, pandas as pd  
aws_access_key_id, aws_secret_access_key = pd.read_csv('~/.ssh/sailor_accessKeys.csv').iloc[0]

region_name = 'us-east-1'
# see https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/lightsail.html 
client = boto3.client('lightsail', region_name=region_name, use_ssl=True, 
                      aws_access_key_id=aws_access_key_id, 
                      aws_secret_access_key=aws_secret_access_key)

response = client.delete_instance(
    instanceName='created_from_python', 
)
print('Delete instance created_from_python:', response['operations'][0]['status'])
EOF

cat << EOF > queryVM.py
#!/usr/local/bin/python3
import boto3, time, pandas as pd  
aws_access_key_id, aws_secret_access_key = pd.read_csv('~/.ssh/sailor_accessKeys.csv').iloc[0]

region_name = 'us-east-1'
# see https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/lightsail.html 
client = boto3.client('lightsail', region_name=region_name, use_ssl=True, 
                      aws_access_key_id=aws_access_key_id, 
                      aws_secret_access_key=aws_secret_access_key)

try:
    response = client.get_instance_state(instanceName='created_from_python') 
    print(f'The Instance created_from_python is {response['state']['name']}')
except boto3.exceptions.botocore.exceptions.ClientError as error:
    print('The Instance created_from_python does not exist')
EOF

cat << EOF > ~/.bashrc
alias  queryVM='docker run --rm -it -v ~/.ssh/lightsail:/root/.ssh boto3:lightsail queryVM'
alias deleteVM='docker run --rm -it -v ~/.ssh/lightsail:/root/.ssh boto3:lightsail deleteVM'
EOF
``` 