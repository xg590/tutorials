### Prepare a hashed password of notebook server 
```
from notebook.auth import passwd
passwd()
```
### Create a config file
```
mkdir ~/.jupyter
cat << EOF > ~/.jupyter/jupyter_notebook_config.py 
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888 
c.NotebookApp.open_browser = False
c.NotebookApp.password = u'sha1:bcd259ccf...<your hashed password here>'
c.NotebookApp.keyfile = u'/absolute/path/to/your/certificate/privkey.pem' 
c.NotebookApp.certfile = u'/absolute/path/to/your/certificate/fullchain.pem'
EOF
```
### Install jupyter
```
sudo apt update && sudo apt install python3-pip python3-venv
python3 -m venv test
source test/bin/activate
pip3 install jupyter jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
```
