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
  ```

* Jupyter
  ```shell 
  mkdir torch2.3.0
  cd torch2.3.0

  cat << EOF > Dockerfile
  FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime
  WORKDIR /workspace
  RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  RUN pip install --upgrade pip
  RUN pip install notebook==7.2.2 wheel
  RUN pip cache purge
  ENV PIP_ROOT="/workspace" 
  ENV PIP_PREFIX=".abc123"
  ENV PYTHONPATH="/workspace/.abc123/lib/python3.10/site-packages"
  ENV JUPYTER_CONFIG_DIR="/workspace/.abc123/cfg" 
  ENV PATH="/workspace/.abc123/bin:\$PYTHONPATH/bin:\$PATH"
  EOF
  
  docker build -t torch2.3.0:notebook7.2.2 .
  ```
* New user
  ```shell
  mkdir -p .abc123/cfg
  mv Dockerfile .abc123/cfg

  cat << EOF >  .abc123/cfg/jupyter_notebook_config.py
  c.ServerApp.ip = '0.0.0.0'
  c.ServerApp.token = ''
  c.ServerApp.password = ''
  c.ServerApp.allow_root = True
  c.ServerApp.open_browser = False
  c.ServerApp.root_dir = '/workspace'
  EOF
  ```
* Run in an interactive style
  ```shell
  docker run    --gpus all          --rm -p 8890:8888 -v $PWD:/workspace torch2.3.0:notebook7.2.2 jupyter-notebook
  ```
* Run in the detached mode
  ```shell 
  cat << EOF > run.sh
  #!/bin/bash
  docker run -d --gpus '"device=0"' --rm -p 8890:8888 -v \$PWD:/workspace --name \${PWD##*/} torch2.3.0:notebook7.2.2 jupyter-notebook
  EOF
  chmod 755 run.sh
  ./run.sh
  ```
* More
  ```
  docker rm $(docker container ls -f 'status=exited' --quiet) # remove exited containers
  ```