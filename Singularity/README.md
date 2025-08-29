### Content
* [Install the Singularity](Installation.md)
* Use definition file to build a SIF image: [Development environment for ESP MCU](Def_File_ESP_IDF.md)
* Use Overlay because you should not write to the SIF image: [Build a jupyter notebook server](Overlay_jupyter.md)
* Other Arch: [Build the notebook server for Raspberry Pi](Armhf.md)
### Quick Start <a name="Singularity"></a>
* Download pre-built images (SIF)
```
singularity search ubuntu
singularity pull                       library://ubuntu # Download ubuntu in SIF format 
```
* Download buildable images
```
singularity build --sandbox ubuntu_123 library://ubuntu # ubuntu_123 is the folder name
```
* Need root previlige in Singularity Container (need to use apt?)
```
singularity build --sandbox       ubuntu_123 library://ubuntu
sudo singularity shell --writable ubuntu_123
Singularity> apt update
Singularity> apt install unix2dos
Singularity> exit   
```
* Build SIF (You cannot and should not change the content of SIF file) 
``` 
singularity build --fakeroot ubuntu.sif ubuntu_123 # Convert the folder to SIF    
singularity shell ubuntu.sif                       # test
```
### Why I choose Singularity
* It is the best solution I can find to deploy jupyter notebook server in a new machine
  1. First I can create a image (sif file) in which jupyter notebook is installed 
  2. Second, I can put a separate overlay image (img file) that caught the writing data.
  3. If I need deploy the notebook server to another machine, I only need to transfer the sif and img files. Then I run them instantly.
  4. See the Procedure [here](Overlay_Jupyter.md).


### 1
```
singularity shell --nv --env PATH=~/bin:$PATH --overlay pytorch.ex3 /scratch/work/public/singularity/cuda11.8.86-cudnn8.7-devel-ubuntu22.04.2.sif
/ext3/miniconda3/bin/conda create -c pytorch -c nvidia -n pytorch pytorch torchvision torchaudio pytorch-cuda=11.8
source /ext3/miniconda3/bin/activate pytorch
```