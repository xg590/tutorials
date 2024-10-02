 (8GB VRAM is not enough for some diffusion model)
* I am [Apr 7, 2024] setting up <b>Grounded Segment Anything</b> test env on Google Cloud Platform VM with a Nvidia Tesla P4 GPU. 
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
### Run the Docker
```shell
EXT=/var/www/html/samba/Grounded-Segment-Anything/ext
screen -S gsam -d -m
screen -S gsam -X stuff "docker run --interactive --tty --rm -p 8889:8888 --gpus all \
--mount type=bind,source=$EXT/bashrc,target=/root/.bashrc \
-e PIP_TARGET=/root/.local/lib/python3.10/site-packages \
-v $EXT/huggingface:/root/.cache/huggingface \
-v $EXT/cfg:/root/.jupyter \
-v $EXT/site-packages:/root/.local/lib/python3.10/site-packages \
-v ${EXT%/*}:/home/appuser/Grounded-Segment-Anything \
--name=gsa gsa:v0 ^M"
screen -S gsam -X stuff "jupyter-notebook ^M"
```
### Troubleshooting
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