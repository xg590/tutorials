```
singularity      build --sandbox  apache_samba library://ubuntu
sudo singularity shell --writable apache_samba 
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