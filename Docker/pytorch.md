* Make sure GPU Driver was installed on the physical machine
* Add deb repo that has nvidia-container-toolkit
  ```shell
  apt-cache search nvidia-container-toolkit # Current repo has No candidate
  DISTRO=$(. /etc/os-release;echo $ID$VERSION_ID)  
  wget https://nvidia.github.io/nvidia-docker/gpgkey -O - | apt-key add -
  wget https://nvidia.github.io/nvidia-docker/$DISTRO/nvidia-docker.list -O /etc/apt/sources.list.d/nvidia-docker.list
  apt update
  apt-cache search nvidia-container-toolkit
  > nvidia-container-toolkit-base - NVIDIA Container Toolkit Base
  > nvidia-container-toolkit - NVIDIA Container toolkit
  apt install -y nvidia-container-toolkit
  nvidia-ctk runtime configure --runtime=docker
  systemctl restart docker
  ```
* [Docker](https://hub.docker.com/r/pytorch/pytorch/tags)  
  * runtime: extends the base image by adding all the shared libraries from the CUDA toolkit. Use this image if you have a pre-built application using multiple CUDA libraries.
  * devel: extends the runtime image by adding the compiler toolchain, the debugging tools, the headers and the static libraries. Use this image to compile a CUDA application from sources.
  ```
  docker pull pytorch/pytorch:2.4.0-cuda12.4-cudnn9-runtime 
  docker save pytorch/pytorch:2.4.0-cuda12.4-cudnn9-runtime | gzip > torch.tgz
  ```
  * Test Run
    * --rm remove container after exit
    * --gpus all pass "all" GPUs to the container 
  ```
  docker load -i torch.tgz
  docker run --rm --gpus all pytorch/pytorch:2.4.0-cuda12.4-cudnn9-runtime python3 -c "import torch; print(torch.cuda.get_device_name(0))"
  docker run -it --rm --gpus all pytorch/pytorch:2.4.0-cuda12.4-cudnn9-runtime 
  ```

* Jupyter
  ```shell 
  mkdir torch2.3.0
  cd torch2.3.0

  cat << EOF > Dockerfile
  FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime
  WORKDIR /workspace
  ENV PATH="/workspace/.local/bin:\$PATH"
  RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  RUN pip3 install --upgrade pip
  RUN pip3 install jupyter notebook==6.4.11 traitlets==5.9.0 jupyter_contrib_nbextensions wheel
  RUN            mkdir -p /workspace/.cfg
  ENV JUPYTER_CONFIG_DIR="/workspace/.cfg"
  RUN jupyter contrib nbextension install
  RUN pip3 cache purge
  RUN       mkdir /workspace/.new_site_packages 
  ENV       PATH="/workspace/.new_site_packages/bin:\$PATH"
  ENV PIP_TARGET="/workspace/.new_site_packages"
  ENV PYTHONPATH="/workspace/.new_site_packages" 
  EOF
  
  docker build -t torch2.3.0:notebook .
  ```
* New user
  ```shell
  mkdir torch2.3.0
  cd torch2.3.0
  mkdir -p .cfg .new_site_packages
  cat << EOF > .cfg/jupyter_notebook_config.py
  c.NotebookApp.ip = '*'
  c.NotebookApp.token = ''
  c.NotebookApp.password = ''
  c.NotebookApp.allow_root = True
  c.NotebookApp.open_browser = False
  c.NotebookApp.notebook_dir = '/workspace'
  EOF
  ```
* Run in an interactive style
  ```shell
  docker run    --gpus all            --rm -p 8890:8888 -v $PWD:/workspace torch2.3.0:notebook jupyter-notebook
  ```
* Run in the detached mode
  ```shell 
  docker run -d --gpus '"device=2,3"' --rm -p 8890:8888 -v $PWD:/workspace torch2.3.0:notebook jupyter-notebook
  ```
* More
  ```
  docker rm $(docker container ls -f 'status=exited' --quiet) # remove exited containers
  ```
* Torchtext.yaml
```yaml
FROM python:3.10.14-slim-bookworm
WORKDIR /workspace
ENV PATH="/workspace/.local/bin:$PATH"
RUN apt update
RUN apt install -y build-essential
RUN apt install -y python3-pip
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install --upgrade pip
RUN pip3 install jupyter notebook==6.4.11 traitlets==5.9.0 jupyter_contrib_nbextensions wheel numpy==1.26.4 spacy==3.7.6 thinc==8.2.5 torch==2.1.2 torchtext==0.16.2 

RUN    mkdir -p /workspace/.cfg
ENV JUPYTER_CONFIG_DIR="/workspace/.cfg"
RUN jupyter contrib nbextension install
RUN pip3 cache purge
RUN       mkdir /workspace/.new_site_packages 
ENV       PATH="/workspace/.new_site_packages/bin:$PATH"
ENV PIP_TARGET="/workspace/.new_site_packages"
ENV PYTHONPATH="/workspace/.new_site_packages" 
```