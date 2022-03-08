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
### Run a GPU-accelerated Job
``` 
srun --job-name=${HOSTNAME}-${PWD##*/} --nodes=1 --time=10:00:00 --cpus-per-task=1 --mem=10GB --gres=gpu:rtx8000:1 --pty /bin/bash
``` 
### t5chem
```
singularity exec --nv --overlay ~/software/t5chem.ext3 /scratch/work/public/singularity/cuda11.4.2-cudnn8.2.4-devel-ubuntu20.04.3.sif /bin/bash
source /ext3/miniconda3/bin/activate t5chem
python3
```
### Office
```
singularity exec --overlay=software/t5chem/t5chem.ext3 software/t5chem/ubuntu-20.04.1.sif /bin/bash
source /ext3/miniconda3/bin/activate t5chem
jupyter-notebook
```
