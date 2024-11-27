#### docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]].
* [Lacking of nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt)
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
#### [Bug] Failed to initialize NVML: Driver/library version mismatch
* Error
  ```
  $ nvidia-smi 
  Failed to initialize NVML: Driver/library version mismatch
  NVML library version: 550.120
  ```
* Installed Kernel (550.120)
  ```
  $ apt list --installed | grep nvidia-kernel
  nvidia-kernel-common-550/jammy-updates,jammy-security,now 550.120-0ubuntu0.22.04.1
  ```
* Running Kernel (550.107.02) 
  ```
  $ cat /proc/driver/nvidia/version
  NVRM version: NVIDIA UNIX x86_64 Kernel Module  550.107.02  Wed Jul 24 23:53:00 UTC 2024
  ```
* Solution: Reboot the computer