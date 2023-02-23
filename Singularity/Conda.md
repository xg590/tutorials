```
singularity build --sandbox  conda library://ubuntu
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
singularity shell --writable conda << EOF
mkdir -p /ext && chmod 777 /ext
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p /ext/miniconda3/
rm -rf /ext/miniconda3/pkgs
mkdir -p /ext/miniconda3/pkgs && chmod 777 /ext/miniconda3/pkgs
mkdir -p /ext/miniconda3/envs && chmod 777 /ext/miniconda3/envs
exit
EOF

singularity build --fakeroot conda_in_ubuntu.sif conda/ 
```
* Create Overlay
```
mkdir -p tmp_123/upper tmp_123/work
dd if=/dev/zero of=conda.img bs=1M count=100
mkfs.ext3 -d tmp_123 conda.img
rm -rf tmp_123
```
* Pytorch
```
singularity shell --overlay conda.img conda_in_ubuntu.sif
/ext/miniconda3/bin/conda create --prefix /ext/miniconda3/envs/pytorch -c pytorch pytorch torchvision torchaudio cpuonly 
source /ext/miniconda3/bin/active pytorch
pip install jupyter notebook=="6.4.11" jupyter_contrib_nbextensions wheel
jupyter contrib nbextension install --user
mkdir /ext/cfg
cat << EOF > /ext/cfg/jupyter_notebook_config.py #
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.open_browser = False
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
EOF
```
* Run
```
singularity shell --overlay pytorch_cpu_only.img conda_in_ubuntu.sif
source /ext/miniconda3/bin/activate pytorch
export JUPYTER_CONFIG_DIR=/ext/cfg ; jupyter-notebook
```