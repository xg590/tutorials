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
c.NotebookApp.password = u'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55' 
#c.NotebookApp.keyfile = u'/absolute/path/to/your/certificate/privkey.pem' 
#c.NotebookApp.certfile = u'/absolute/path/to/your/certificate/fullchain.pem'
EOF
```
### Install jupyter
```
sudo apt update && sudo apt install python3-pip python3-venv
python3 -m venv test
source test/bin/activate
pip install jupyter jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
```
### Install more python backend for jupyter 
```
python3 -m pip install ipykernel
python3 -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```
### Uninstall backend/kernel
```
jupyter kernelspec list  
jupyter kernelspec uninstall unwanted-kernel
```
### Some fucking problem with Python at this time (Jan 13 2021)
* Comand completion does not work because of this error. It is damn fucking annoying. 
```
TypeError: __init__() got an unexpected keyword argument 'column'
```
* Solution: Downgrade two packages.
```
pip install --upgrade parso==0.5.2 jedi==0.15.2
```
