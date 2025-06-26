### Embedded Dev On Ubuntu
* Install Jupyter in venv
```
sudo apt update -y && sudo apt install -y python3-pip python3-venv

dd if=/dev/zero of=/var/www/html/jupyter123.ext3 bs=1M status=progress count=1000
mkfs.ext3 /var/www/html/jupyter123.ext3
mkdir -p /tmp/jupyter123
sudo mount -o loop /var/www/html/jupyter123.ext3 /tmp/jupyter123
sudo chown $USER /tmp/jupyter123 

python3 -m venv /tmp/jupyter123
source /tmp/jupyter123/bin/activate
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install --upgrade pip
pip install notebook==7.2.2 wheel
pip cache purge

mkdir -p /tmp/jupyter123/cfg
cat << EOF > /tmp/jupyter123/cfg/jupyter_notebook_config.py
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.allow_root = True
c.ServerApp.open_browser = False
EOF

sudo umount /tmp/jupyter123
```
* Run
```
cat << EOF > jupyter.sh
mkdir -p /tmp/jupyter123
sudo mount -o loop /var/www/html/jupyter123.ext3 /tmp/jupyter123
screen -S jupyter456 -d -m
screen -S jupyter456 -X stuff "source /tmp/jupyter123/bin/activate ^M"
screen -S jupyter456 -X stuff "export PIP_ROOT='/tmp' ^M"
screen -S jupyter456 -X stuff "export PIP_PREFIX='jupyter123' ^M"
screen -S jupyter456 -X stuff "export PYTHONPATH='/tmp/jupyter123/lib/python3.11/site-packages' ^M"
screen -S jupyter456 -X stuff "export PATH='/tmp/jupyter123/bin:\$PYTHONPATH/bin:\$PATH' ^M"
screen -S jupyter456 -X stuff "export JUPYTER_CONFIG_DIR='/tmp/jupyter123/cfg' ^M"
screen -S jupyter456 -X stuff "jupyter-notebook ^M"
EOF

chmod o+x jupyter.sh
```
* [Example](https://github.com/xg590/IoT/blob/master/MicroPython/MicroPython_ESP8266_Jupyter.ipynb)
### Tricks
* Work remotely
```
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
sudo apt-get install -y libatlas-base-dev libopenblas-dev
```
* numpy
```
sudo apt install -y gcc g++ gfortran libopenblas-dev liblapack-dev pkg-config python3-pip python3-dev
git clone https://github.com/numpy/numpy.git
cd numpy/
git submodule update --init
pip install .
```
* Pillow
```
sudo apt install libjpeg-dev zlib1g-dev
```
### Old
```
mkdir -p ~/.jupyter
cat << EOF > ~/.jupyter/jupyter_notebook_config.py 
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888 
c.NotebookApp.open_browser = False
c.NotebookApp.password = ''
c.NotebookApp.token = ''
#c.NotebookApp.keyfile = u'/absolute/path/to/your/certificate/privkey.pem' 
#c.NotebookApp.certfile = u'/absolute/path/to/your/certificate/fullchain.pem'
EOF
```
### dwdwa
```
export PIP_ROOT=$HOME
export PIP_PREFIX="venv"
export PYTHONPATH="$PIP_ROOT/$PIP_PREFIX/lib/python3.11/site-packages"
echo $PYTHONPATH

/home/pi/.local/lib/python3.11/site-packages
echo $PYTHONPATH > /home/pi/.local/lib/python3.11/site-packages/custom_paths.pth

```