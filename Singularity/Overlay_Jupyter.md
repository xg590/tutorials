### Overlay
* We can create an image file and then use it as an overlay in Singularity.
* Writing operations are caught by the filesystem overlay.
```
$ sudo su  
# dd if=/dev/zero of=2G.ext3 bs=1M count=2048
# mkfs.ext3 2G.ext3
# chmod 777 2G.ext3
# singularity shell --overlay 2G.ext3  ubuntu.sif
Singularity> mkdir /ext
Singularity> chmod 777 /ext
Singularity> exit
# exit
$ singularity shell --overlay 2G.ext3  ubuntu.sif
Singularity> touch /ext/success
```
* As you can see, an /ext directory is created and data stay in the image file when they are written to /ext.
### Jupyter [(Note about upper in overlayFS)](https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt)
```
singularity build --sandbox  jupyter library://ubuntu
singularity shell --writable jupyter library://ubuntu 
mkdir /ext
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p /ext/miniconda3/
/ext/miniconda3/bin/conda create -n  jupyter python=3
source /ext/miniconda3/bin/activate  jupyter
pip install jupyter jupyter_contrib_nbextensions 
jupyter contrib nbextension install
exit 

mkdir ~/.jupyter
cat << EOF >> ~/.jupyter/jupyter_notebook_config.py # 
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
c.NotebookApp.open_browser = False
c.NotebookApp.notebook_dir = '/var/www/html/'
EOF

mkdir -p tmp_123/upper tmp_123/work
dd if=/dev/zero of=jupyter.img bs=1M count=500
mkfs.ext3 -d tmp_123 jupyter.img
rm -rf tmp_123

singularity shell --overlay jupyter.img jupyter

singularity build --fakeroot jupyter.sif jupyter
```