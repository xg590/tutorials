* Play on NYU HPC GREENE
```
coverlay-5GB-200K.ext3.gz /scratch/${USER}/
gzip -d overlay-5GB-200K.ext3.gz
singularity exec --overlay overlay-5GB-200K.ext3 /scratch/work/public/singularity/ubuntu-20.04.1.sif /bin/bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p /ext3/miniconda3/
wget https://yzlab3.chem.nyu.edu/share/rdkit_on_hpc.yml
/ext3/miniconda3/bin/conda-env create -f rdkit_on_hpc.yml 
source /ext3/miniconda3/bin/activate rdkit_on_hpc 
/ext3/miniconda3/envs/rdkit_on_hpc/bin/jupyter contrib nbextension install --sys-prefix
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
* Play t5chem
```
scp greene:/scratch/work/public/overlay-fs-ext3/overlay-5GB-200K.ext3.gzz .
gzip -d overlay-5GB-200K.ext3.gz 
singularity exec --overlay overlay-5GB-200K.ext3 ubuntu-20.04.1.sif /bin/bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p /ext3/miniconda3/
/ext3/miniconda3/bin/conda create -n t5chem python=3.8
source /ext3/miniconda3/bin/activate t5chem 
pip install t5chem torch jupyter jupyter_contrib_nbextensions
jupyter contrib nbextension install --sys-prefix
```