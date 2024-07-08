### Install on Ubuntu 22.04 (8GB VRAM is not enough for some diffusion model)
* I am [Apr 7, 2024] setting up <b>Grounded Segment Anything</b> test env on Google Cloud Platform VM with a Nvidia Tesla P4 GPU. 
* I am installing the following prerequsited software to run G_SAM:
    * Nvidia GPU Driver
    * Nvidia CUDA Toolkit (not a requisite for pytorch but a necessary component during G_SAM installation)
    * Conda / Torch 
* There are compatibility issues so I need to be careful to choose each software.
    * The GPU driver should be compatible with CUDA toolkit (driver 515.105.01 is good with toolkit 11.7). 
        * Go to [NVIDIA Driver Downloads webpage](https://www.nvidia.com/Download/index.aspx?lang=en-us) and choose the [driver](https://www.nvidia.com/Download/driverResults.aspx/200630/en-us/) for Tesla P4.
        * Download and install driver 515.105.01
          ```
          wget https://us.download.nvidia.com/tesla/515.105.01/NVIDIA-Linux-x86_64-515.105.01.run
          # apt install nvidia-driver-515 is OK as well
          nvidia-smi # check if the GPU is supported by the driver
          ```
    * Torch needs the support of CUDA toolkit. (toolkit 11.7 supports pytorch 2.0.1 and torchvision 0.15.2).
        * Go to [CUDA Toolkit Archive](https://developer.nvidia.com/cuda-toolkit-archive) and choose the [toolkit](https://developer.nvidia.com/cuda-11-7-1-download-archive?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local) 11.7.1
          ```
          wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-ubuntu2204-11-7-local_11.7.1-515.65.01-1_amd64.deb
          ```
    * G_SAM requires python>=3.8, as well as pytorch>=1.7 and torchvision>=0.8.
      ```
      conda create pytorch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 pytorch-cuda=11.7 -c pytorch -c nvidia -n torch
      ```
* Following the [instruction](https://github.com/IDEA-Research/Grounded-Segment-Anything?tab=readme-ov-file#install-without-docker)
### Full-course installation procedure for Geforce RTX3080 
  ```shell
  # Install GPU driver 
  sudo apt update 
  sudo apt install -y build-essential nvidia-driver-545
  nvidia-smi # check if the GPU is supported by the driver

  # Install cuda-toolkit-12-3
  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
  sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
  wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda-repo-ubuntu2204-12-3-local_12.3.2-545.23.08-1_amd64.deb
  sudo dpkg -i cuda-repo-ubuntu2204-12-3-local_12.3.2-545.23.08-1_amd64.deb
  sudo cp /var/cuda-repo-ubuntu2204-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
  sudo apt-get update && sudo apt-get -y install cuda-toolkit-12-3
  export CUDA_HOME=/usr/local/cuda-12.3 # dpkg -L cuda-toolkit-12-3
  
  # Install pytorch
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
  export DST_DIR=/ext4
  cd $DST_DIR
  bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $DST_DIR/miniconda3/
  $DST_DIR/miniconda3/bin/conda create -y python=3.11 pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia -n g_sam 
  source $DST_DIR/miniconda3/bin/activate g_sam
  python -c 'import torch; print(torch.cuda.is_available())'
  pip install jupyter jupyter_contrib_nbextensions 
 
  # Install GroundingDINO / Segment Anything Model / DiffusionAI
  git clone --recursive https://github.com/IDEA-Research/Grounded-Segment-Anything.git
  cd Grounded-Segment-Anything
  export AM_I_DOCKER=False
  export BUILD_WITH_CUDA=True 
  export CUDA_HOME=/usr/local/cuda-12.3 # dpkg -L cuda-toolkit-12-3 
  python3 -m pip install -e segment_anything 
  pip install pycocotools==2.0.7 # https://github.com/cocodataset/cocoapi/issues/172 
  pip install --no-build-isolation -e GroundingDINO 
  pip install --upgrade diffusers[torch] diffusers 
  cd grounded-sam-osx && bash install.sh

  pip install --upgrade setuptools # https://github.com/xinyu1205/recognize-anything/issues/107
  pip install git+https://github.com/xinyu1205/recognize-anything.git

  pip install onnxruntime onnx # optional packages that export the model in ONNX format
  ```
### G_SAM installation with Docker
```shell
docker run --interactive --tty --rm -p 8888:8888 \
        -v "${PWD}"/cfg:/root/.jupyter \
        -v "${PWD}"/site-packages:/root/.local/lib/python3.10/site-packages \
        -e             PIP_TARGET=/root/.local/lib/python3.10/site-packages \
        --name=gsa gsa:v0

pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple 
pip install jupyter jupyter_contrib_nbextensions wheel notebook==6.4.12 traitlets==5.9.0
jupyter contrib nbextension install --system
export PATH=/root/.local/lib/python3.10/site-packages/bin:$PATH
cat << EOF > ~/.jupyter/jupyter_notebook_config.py 
c.NotebookApp.allow_root = True
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.password = u'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'  
EOF
jupyter-notebook
```
### Troubleshooting
#### docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]].
* [Ref](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt)
```
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker.service
```
#### Nvidia driver and cuda-toolkit compatibility 
* cuda-repo-ubuntu2204-12-0-local_<span style="color:red"><i>12.0.0</i></span>-<span style="color:green"><i>525.60.13</i></span>-1_amd64.deb
* cuda-repo-ubuntu2204-11-8-local_<span style="color:red"><i>11.8.0</i></span>-<span style="color:green"><i>520.61.05</i></span>-1_amd64.deb
* cuda-repo-ubuntu2204-11-7-local_<span style="color:red"><i>11.7.1</i></span>-<span style="color:green"><i>515.65.01</i></span>-1_amd64.deb
#### GPU kernel-client confict
* If a newer Nvidia driver was installed before, running nvidia-smi may land you in a kernel-client confict with the warning:
```
$ nvidia-smi 
Failed to initialize NVML: Driver/library version mismatch
NVML library version: 545.29
```
* Even if I uninstalled nvidia-driver-550 and installed nvidia-driver-545, the linux still load module belonging to 550 driver.
```
$ sudo  dmesg | grep NVRM
[    9.854868] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  550.54.14  Thu Feb 22 01:44:30 UTC 2024 
[ 5080.898738] NVRM: API mismatch: the client has the version 545.29.06, but
               NVRM: this kernel module has the version 550.54.14.  Please
               NVRM: make sure that this kernel module and all NVIDIA driver
               NVRM: components have the same version.
```
* Basically, it means our nvidia-smi is using API from Nvidia driver 545.29.06 but our Linux loaded the kernel from the Nvidia driver 550.54.14. 
* So we will reconfigure the Linux kernel and the a 545 driver/module will be loaded into Linux kernel instead.
```shell
sudo dpkg-reconfigure nvidia-dkms-515
```
#### Failed to install pycocotools
```
cc1: fatal error: pycocotools/_mask.c: No such file or directory
```
* Do not build from source code, pip it.
```
pip install pycocotools==2.0.7
```
#### Use python3.11 please
```python
python3.12 will got error "AttributeError: module 'pkgutil' has no attribute 'ImpImporter'. Did you mean: 'zipimporter'?" due to the removal of the long-deprecated pkgutil.ImpImporter class
```
#### libGL is missing 
* Error
```python
ImportError: libGL.so.1: cannot open shared object file: No such file or directory
```
* Install the missing lib
```shell
apt-get install libgl1
```