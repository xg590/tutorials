### Install on Ubuntu 20.04.1
* Install Dependencies
```
sudo apt-get update && sudo apt-get install -y build-essential uuid-dev libgpgme-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup-bin
```
* Install Go 1.14.12
```
export VERSION=1.14.12 OS=linux ARCH=amd64 && wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && rm go$VERSION.$OS-$ARCH.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
```
* Download Singularity 3.7.0
```
export VERSION=3.7.0 && wget https://github.com/hpcng/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && tar -xzf singularity-${VERSION}.tar.gz 
```
* Build Singularity
```
cd singularity && ./mconfig && make -C ./builddir && sudo make -C ./builddir install
```
Source bash completion file
```
. /usr/local/etc/bash_completion.d/singularity
```
Testing & Checking the Build Configuration
```
singularity exec library://alpine cat /etc/alpine-release
```
### Play with it (Install rdkit on NYU HPC GREENE)
* Install
```
cp /scratch/work/public/overlay-fs-ext3/overlay-5GB-200K.ext3.gz /scratch/${USER}/
gzip -d overlay-5GB-200K.ext3.gz
singularity exec --overlay overlay-5GB-200K.ext3 /scratch/work/public/singularity/ubuntu-20.04.1.sif /bin/bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p /ext3/miniconda3/
wget https://yzlab3.chem.nyu.edu/share/rdkit_on_hpc.yml
/ext3/miniconda3/bin/conda-env create -f rdkit_on_hpc.yml 
source /ext3/miniconda3/bin/activate rdkit_on_hpc 
/ext3/miniconda3/envs/rdkit_on_hpc/bin/jupyter contrib nbextension install --user
mkdir ~/.jupyter
# from notebook.auth import passwd
cat << EOF >> ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.ip = '0.0.0.0' 
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
EOF
cat <<EOF > ~/bin/jupyter.sh
#!/bin/bash
source /ext3/miniconda3/bin/activate rdkit_on_hpc
XDG_RUNTIME_DIR=/scratch/xg590
port=\$(shuf -i 10000-19999 -n 1) 
jupyter notebook --no-browser --port \$port --notebook-dir=`pwd` &
/usr/bin/ssh -N -R 39073:localhost:\$port iMac
EOF
chmod 700 ~/bin/jupyter.sh
```
* Run
```
singularity exec --overlay overlay-5GB-200K.ext3 /scratch/work/public/singularity/ubuntu-20.04.1.sif ~/bin/jupyter.sh
``` 
