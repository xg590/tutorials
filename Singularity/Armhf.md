### Soc and OS
* Raspberry Pi 4 8GB
* 2022-09-22-raspios-bullseye-armhf-lite.img
### Build jupyter
* Build a container
```
singularity build --sandbox  jupyter docker://debian:bullseye
sudo singularity shell --writable jupyter << EOF
apt update && apt install -y python3 python3-pip python3-venv libffi-dev libxml2 libxslt-dev
apt clean 
exit
EOF

singularity shell --writable jupyter << EOF
mkdir /ext && chmod 777 /ext && cd /ext
python3 -m venv jupyter
source jupyter/bin/activate
pip install jupyter jupyter_contrib_nbextensions
pip cache purge
jupyter contrib nbextension install
exit
EOF
```
* Build the SIF
``` 
sudo chmod 644 jupyter/./var/cache/apt/archives/lock	 
sudo chmod 644 jupyter/./var/cache/ldconfig/aux-cache	 
sudo chmod 644 jupyter/./var/lib/apt/lists/lock		 
sudo chmod 644 jupyter/./var/log/apt/term.log			 
sudo chmod 755 jupyter/./var/cache/apt/archives/partial 
sudo chmod 755 jupyter/./var/lib/apt/lists/partial		 
sudo chmod 755 jupyter/./etc/ssl/private

cat << EOF > jupyter.def
BootStrap: localimage
From: ${HOME}/jupyter

%environment
    export THIS_IS_A_TEST="foo bar" 
    export JUPYTER_CONFIG_DIR="/ext/cfg" 
    export PIP_TARGET="/ext/site-packages"
    export PYTHONPATH="/ext/site-packages"

%runscript
    # debian:bullseye is different than Ubuntu
    /bin/bash -c "source /ext/jupyter/bin/activate ; jupyter-notebook --notebook-dir='/ext/dev'"  

%help
    Help Message~

%labels
    Author xg590
EOF
singularity build  --fakeroot jupyter.sif jupyter.def
singularity inspect --deffile jupyter.sif
```
* Overlay (You don't have the write permission of jupyter.sif. Use a overlay so you can create file. Otherwise, jupyter notebook sever will not run because it cannot create temporary files.)
```
mkdir -p tmp_123/upper tmp_123/work
dd if=/dev/zero of=jupyter.img bs=1M count=100
mkfs.ext3 -d tmp_123 jupyter.img
rm -rf tmp_123
```
* Configure
```
singularity shell --overlay jupyter.img jupyter.sif << EOF_OUT
mkdir /ext/cfg /ext/dev 
cat << EOF_IN > /ext/cfg/jupyter_notebook_config.py #
c.NotebookApp.ip = '*'
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
c.NotebookApp.open_browser = False 
EOF_IN
exit
EOF_OUT
```
* Run
```
singularity run --overlay jupyter.img jupyter.sif
```

