* Make sure GPU Driver was installed on the physical machine
* CUDA Toolkit -- Add new repo src and install nvidia-container-toolkit
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
* Install runtime version or devel version of [Pytorch_CUDA](https://hub.docker.com/r/pytorch/pytorch/tags)
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
