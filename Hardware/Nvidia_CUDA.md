
### Pytorch + Ubuntu 22.04 desktop
1. Install the RTX2060 driver
    ```
    sudo su
    apt install -y nvidia-driver-535
    reboot
    ```
    * Configuring Secure Boot -> Enter any password -> Enroll Key 
2. We are going to create a single file and mount it as a new filesystem so everything is in one place
    ```
    dd if=/dev/zero of=/var/www/html/pytorch.ext3 bs=1M count=20000 status=progress
    mkfs.ext3 /var/www/html/pytorch.ext3
    mkdir -p /tmp/_pytorch
    sudo mount -o loop /var/www/html/pytorch.ext3 /tmp/_pytorch
    ```
3. Install Pytorch
    ```
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -f -p /tmp/_pytorch
    /tmp/_pytorch/bin/conda create -y -c nvidia -c pytorch -n torch pytorch torchvision torchaudio pytorch-cuda=11.8
    source /tmp/_pytorch/bin/activate torch
    ```
4. Test Pytorch
    ```
    python -c "import torch; print(torch.cuda.is_available())" 
    python -m torch.utils.collect_env
    wget https://raw.githubusercontent.com/xg590/tutorials/master/ML/pytorch_gpu_test_cnn.py -O pytorch_gpu_test_cnn.py
    python pytorch_gpu_test_cnn.py
    ```
5. Launch
    ```
    mkdir -p /tmp/_pytorch
    sudo mount -o loop /var/www/html/software/ext3/tmp__pytorch.ext3 /tmp/_pytorch
    screen -S pytorch -d -m
    screen -S pytorch -X stuff "source /tmp/_pytorch/bin/activate torch ^M"
    screen -S pytorch -X stuff "python -c 'import torch; print(torch.cuda.is_available())' ^M"
    ```




### Pytorch + CentOS 7 
1. or 
    ```
    apt install pkg-config libglvnd-dev build-essentials
    systemctl set-default multi-user.target && reboot
    bash NVIDIA-Linux-x86_64-535.113.01.run
    ```
1. d    
    ```
    yum install vulkan
    yum install libglvnd*
    ```