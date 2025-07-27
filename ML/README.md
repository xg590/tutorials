### Install on Ubuntu 22.04 or Windows
* Outline
  * Nvidia GPU Driver
  * Conda / Torch
  * There are compatibility issues so we need to be careful to choose each software.
* How do we know which GPU Driver version supports our Pytorch Compute Platform (Assume CUDA 12.4)?
  * Go to Nvidia [CUDA Toolkit Archive](https://developer.nvidia.com/cuda-toolkit-archive)
  * Try to download the CUDA Toolkit installer (Linux or Windows)
  * We get cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb or cuda_12.4.1_551.78_windows.exe
  * Now we know GPU driver 550.54.15 supports cuda 12.4.1 on Ubuntu.
* Install GPU Driver.
  * Using apt is highly recommended.
    ```
    apt-cache search nvidia-driver
    sudo apt install -y nvidia-driver-550
    ```
  * Go to [Nvidia website](https://www.nvidia.com/en-us/drivers/details/223430/) to download 551.86-desktop-win10-win11-64bit-international-nsd-dch-whql.exe
* Install pytorch
  ```
  pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
  ```
  
* Accelerate: If <b>training.py</b> run on GPU by calling model.to(device) then [modify it accordingly](https://huggingface.co/course/en/chapter3/4?fw=pt#supercharge-your-training-loop-with-accelerate) and accelerate it. 
```
accelerate launch ~/training.py
```