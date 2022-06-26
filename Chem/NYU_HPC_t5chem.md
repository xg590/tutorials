### Create T5Chem ext3
```
scp greene:/scratch/work/public/overlay-fs-ext3/overlay-10GB-400K.ext3.gz .  
gzip -dk overlay-10GB-400K.ext3.gz
mv overlay-10GB-400K.ext3 newT5ChemAndRDKit.ext3
singularity exec --overlay newT5ChemAndRDKit.ext3 ubuntu-20.04.1.sif /bin/bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p /ext3/miniconda3/
/ext3/miniconda3/bin/conda create -n newT5ChemAndRDKit python=3.8
source /ext3/miniconda3/bin/activate newT5ChemAndRDKit
pip install jupyter jupyter_contrib_nbextensions
pip install t5chem 
# jupyter contrib nbextension install --use
``` 
### T5Chem_prop
```python3
#pip install h5py 
import sys, os
sys.path.insert(0,f'{os.getenv("HOME")}/software/t5chem_prop')
sys.path.insert(1,f'{os.getenv("HOME")}/software/t5chem_prop/t5chem') 
import t5chem 
t5chem.__version__
```
### What kind of GPUs in Greene HPC @ NYU?
```
[user@log-3 slurm]$ grep -i gres=gpu /opt/slurm/etc/slurm.conf
NodeName=gv[001-010]   CPUs=48 Boards=1 SocketsPerBoard=2 CoresPerSocket=24 ThreadsPerCore=1 RealMemory=377856 State=UNKNOWN Gres=gpu:v100:4
NodeName=gr[001-073]  CPUs=48 Boards=1 SocketsPerBoard=2 CoresPerSocket=24 ThreadsPerCore=1 RealMemory=377856 State=UNKNOWN Gres=gpu:rtx8000:4
NodeName=gm[001-020]  CPUs=96 Boards=1 SocketsPerBoard=1 CoresPerSocket=48 ThreadsPerCore=2 RealMemory=506880 State=UNKNOWN Gres=gpu:mi50:8
NodeName=gv011 CPUs=40 Boards=1 SocketsPerBoard=2 CoresPerSocket=20 ThreadsPerCore=1 RealMemory=515000 Features=v100,dev32g,nvlink State=UNKNOWN Gres=gpu:v100:8
NodeName=gv012 CPUs=40 Boards=1 SocketsPerBoard=2 CoresPerSocket=20 ThreadsPerCore=1 RealMemory=385000 Features=v100,dev32g,nvlink State=UNKNOWN Gres=gpu:v100:4
NodeName=gv[013-018] CPUs=40 Boards=1 SocketsPerBoard=2 CoresPerSocket=20 ThreadsPerCore=1 RealMemory=385000 Features=v100,dev16g,nvlink State=UNKNOWN Gres=gpu:v100:4
```
* So one can use v100, rtx8000, and mi50 cards.
* rtx8000 is better than v100 while mi50 is an AMD card
### Run a GPU-accelerated Job
``` 
srun --job-name=${HOSTNAME}-${PWD##*/} --nodes=1 --time=10:00:00 --cpus-per-task=1 --mem=10GB --gres=gpu:rtx8000:1 --pty /bin/bash
``` 
### T5Chem_prop
```
singularity exec --nv --overlay ~/software/newT5ChemAndRDKit_t5chem.ext3 /scratch/work/public/singularity/cuda11.4.2-cudnn8.2.4-devel-ubuntu20.04.3.sif /bin/bash
source /ext3/miniconda3/bin/activate newT5ChemAndRDKit
Singularity> t5chem.sh
```
