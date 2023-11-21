
### Pytorch + Ubuntu 22.04 desktop
1. Install the RTX2060 driver
    ```
    sudo su
    apt install -y nvidia-driver-535
    reboot
    ```
    * Configuring Secure Boot -> Enter any password -> Enroll Key
    ```
    or 
    ```
    apt install pkg-config libglvnd-dev build-essentials
    systemctl set-default multi-user.target && reboot
    bash NVIDIA-Linux-x86_64-535.113.01.run
    ```
2. We are going to create a single file and mount it as a new filesystem so everything is in one place
    ```
    dd if=/dev/zero of=/var/www/html/pytorch.ext3 bs=1M count=20000 status=progress
    mkfs.ext3 /var/www/html/pytorch.ext3
    mkdir -p ~/software/miniconda3
    sudo mount -o loop /var/www/html/pytorch.ext3 ~/software/miniconda3
    ```
3. Install Pytorch
    ```
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $HOME/software/miniconda3/
    $HOME/software/miniconda3/bin/conda create -y -c nvidia -c pytorch -n torch pytorch torchvision torchaudio pytorch-cuda=11.8
    source $HOME/software/miniconda3/bin/activate torch
    ```
4. Test Pytorch
    ```
    python -c "import torch; print(torch.cuda.is_available())" 
    python -m torch.utils.collect_env
    wget https://raw.githubusercontent.com/xg590/tutorials/master/ML/pytorch_gpu_test_cnn.py -O pytorch_gpu_test_cnn.py
    python pytorch_gpu_test_cnn.py
    ```
5. External Test



```
yum install vulkan
yum install libglvnd*
```