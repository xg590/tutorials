## Self-signed Certificate for Jupyter Notebook Server
### Background Knowledge
* 申请者申请数字证书之前需要准备自己的密钥文件和CSR文件（Certificate Signing Request File 是您的公钥证书原始文件，包含了您的服务器信息和您的单位信息，需要提交给 CA 认证中心进行审核）。
  * C  | Country Code：申请单位所属国家，只能是两个字母的国家码。例如，中国填写为 CN。
  * ST | State or Province Name：州名或省份名称，可以是中文或英文。
  * L  | Locality Name：城市名称，可以是中文或英文。
  * O  | Organization Name：公司名称，可以是中文或英文。
  * OU | Organizational Unit Name：部门名称，可以是中文或英文。
  * CN | Common Name：申请 SSL 证书的具体网站域名。
  * Email Address：可选择不输入。
  * Challenge Password：可选择不输入。
### Server-side
* Prepare Server-side file (server.csr)
```shell
mkdir ~/.jupyter ~/learn
Public_IP=`curl ipinfo.io/ip` 
echo $Public_IP
# New Private Key and CSR
openssl req -nodes -newkey rsa:4096 -subj "/C=US/ST=abcd1234/L=efgh1234/O=higk1234/OU=lmno1234/CN=$Public_IP" -keyout $HOME/.jupyter/server.key -out $HOME/.jupyter/server.csr
#openssl req -text -in $HOME/.jupyter/server.csr -noout -verify 
```
* Jupyter Config
```shell  
#PSWD=`python -c 'from notebook.auth import passwd ; print(passwd())'` 
cat << EOF > ~/.jupyter/jupyter_notebook_config.py 
c.NotebookApp.ip = '*'
c.NotebookApp.port = 5555 
c.NotebookApp.open_browser = False
#c.NotebookApp.password = u'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55' 
c.NotebookApp.notebook_dir = u'$HOME/learn'
c.NotebookApp.keyfile  = u'$HOME/.jupyter/server.key' 
c.NotebookApp.certfile = u'$HOME/.jupyter/server.crt'
EOF
```
### Certificate Authority-side
* Prepare CA-side files
```shell
# CA root key and certificate
openssl req -x509 -new -nodes -sha256 -newkey rsa:4096 -subj "/C=US/ST=abcd1234/L=efgh1234/O=higk1234/OU=lmno1234/CN=ca4nbserv" -keyout $HOME/.jupyter/ca.key -out $HOME/.jupyter/ca.crt
cp $HOME/.jupyter/ca.crt /var/www/html/ca4nbserv.crt 
```
* Generate the certificate for server based on server.csr
```shell
openssl x509 -req -extfile <(printf "subjectAltName=IP:$Public_IP") -days 365 \
  -CA    $HOME/.jupyter/ca.crt     \
  -CAkey $HOME/.jupyter/ca.key     \
  -in    $HOME/.jupyter/server.csr \
  -out   $HOME/.jupyter/server.crt 
#sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 127.0.0.1:5555
```
* For Windows user
```shell
cat << EOF > /var/www/html/ca4nbserv.bat
cd %~dp0
powershell -Command "Invoke-WebRequest -URI 'http://$Public_IP/ca4nbserv.crt' -OutFile ca4nbserv.crt"
powershell -Command "Import-Certificate -FilePath ca4nbserv.crt -CertStoreLocation 'Cert:\LocalMachine\Root'" 
pause
EOF
```