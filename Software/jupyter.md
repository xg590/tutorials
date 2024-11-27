### Embedded Dev On Ubuntu
* Install Jupyter in venv
```
sudo apt update && sudo apt install python3-pip python3-venv

dd if=/dev/zero of=/var/www/html/jupyter123.ext3 bs=1M status=progress count=1000
mkfs.ext3 /var/www/html/jupyter123.ext3
mkdir -p /tmp/jupyter123
sudo mount -o loop /var/www/html/jupyter123.ext3 /tmp/jupyter123
sudo chown $USER /tmp/jupyter123 

python3 -m venv /tmp/jupyter123
source /tmp/jupyter123/bin/activate
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install --upgrade pip
pip3 install jupyter jupyter_contrib_nbextensions wheel notebook==6.4.12 traitlets==5.9.0
jupyter contrib nbextension install --sys-prefix
jupyter nbextension enable codefolding/main
jupyter nbextension enable execute_time/ExecuteTime
sudo umount /tmp/jupyter123
```
* Run
```
mkdir -p /tmp/jupyter123
sudo mount -o loop /var/www/html/jupyter123.ext3 /tmp/jupyter123
screen -S benchmark -d -m
screen -S benchmark -X stuff "source /tmp/jupyter123/bin/activate ^M"
screen -S benchmark -X stuff "export PYTHONPATH=/home/pi/new_site_packages ^M"
screen -S benchmark -X stuff "export PIP_TARGET=/home/pi/new_site_packages ^M"
screen -S benchmark -X stuff "jupyter-notebook ^M"
```
* [Example](https://github.com/xg590/IoT/blob/master/MicroPython/MicroPython_ESP8266_Jupyter.ipynb)
### Tricks
* Work remotely
```
mkdir -p ~/.jupyter
cat << EOF > ~/.jupyter/jupyter_notebook_config.py 
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888 
c.NotebookApp.open_browser = False
c.NotebookApp.password = u'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'  
#c.NotebookApp.keyfile = u'/absolute/path/to/your/certificate/privkey.pem' 
#c.NotebookApp.certfile = u'/absolute/path/to/your/certificate/fullchain.pem'
EOF
```
* Run a jupyter notebook in command line [Credit](https://discourse.jupyter.org/t/jupyter-run-requires-notebook-to-be-previously-run/12250/2)
```
jupyter-execute xg590.ipynb
```
* Prepare a hashed password of notebook server 
```
from notebook.auth import passwd
passwd()
```
* Install/Uninstall more python backend/kernel for jupyter 
```
python3 -m pip install ipykernel
python3 -m ipykernel install --user --name myenv --display-name "Python (myenv)"
python3 -m jupyter_micropython_kernel.install
pip3 install jupyter_micropython_kernel

jupyter kernelspec list  
jupyter kernelspec uninstall unwanted-kernel
``` 
* ImportError: libcblas.so.3: cannot open shared object file: No such file or directory when numpy==1.24 
```
sudo apt-get install libatlas-base-dev libopenblas-dev
```
### New
```
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install notebook==7.2.2 wheel

cat << EOF >> $HOME/.bashrc
export PIP_ROOT=$HOME
export PIP_PREFIX=".abc123"
export PYTHONPATH="$HOME/.abc123/lib/python3.12/site-packages"
export JUPYTER_CONFIG_DIR="$HOME/.abc123/cfg" 
export PATH="$HOME/.abc123/bin:\$PYTHONPATH/bin:\$PATH"
EOF

mkdir -p   $HOME/.abc123/cfg  
cat << EOF >  $HOME/.abc123/cfg/jupyter_notebook_config.py
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.allow_root = True
c.ServerApp.open_browser = False
c.ServerApp.root_dir = '$HOME'
EOF
```