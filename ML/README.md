
```
singularity shell --nv --env PATH=~/bin:$PATH --overlay pytorch.ex3 /scratch/work/public/singularity/cuda11.8.86-cudnn8.7-devel-ubuntu22.04.2.sif
/ext3/miniconda3/bin/conda create -c pytorch -c nvidia -n pytorch pytorch torchvision torchaudio pytorch-cuda=11.8
source /ext3/miniconda3/bin/activate pytorch
```
* Accelerate: If <b>training.py</b> run on GPU by calling model.to(device) then [modify it accordingly](https://huggingface.co/course/en/chapter3/4?fw=pt#supercharge-your-training-loop-with-accelerate) and accelerate it. 
```
accelerate launch ~/training.py
```