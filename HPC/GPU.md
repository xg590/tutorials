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
#### GPU kernel-client confict
* If a Nvidia driver was installed before, running nvidia-smi may land you in a kernel-client confict with the warning:
```
$ nvidia-smi 
Failed to initialize NVML: Driver/library version mismatch
NVML library version: 545.29
```
* Because the nvidia-smi is using APIs belongs to 545 but the driver is not.
* Even if I uninstalled nvidia-driver-550 and installed nvidia-driver-545, the linux still load kernel module belonging to 550 driver.
```
$ sudo  dmesg | grep NVRM
[    9.854868] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  550.54.14  Thu Feb 22 01:44:30 UTC 2024 
[ 5080.898738] NVRM: API mismatch: the client has the version 545.29.06, but
               NVRM: this kernel module has the version 550.54.14.  Please
               NVRM: make sure that this kernel module and all NVIDIA driver
               NVRM: components have the same version.
```
* or if the driver is updated (so the software uses 550.107.02 APIs) but the linux kernel still load old module (550.90.07).
```
[ xxxxx.017504] NVRM: API mismatch: the client has the version 550.107.02, but
                NVRM: this kernel module has the version 550.90.07.  Please
                NVRM: make sure that this kernel module and all NVIDIA driver
                NVRM: components have the same version.
``` 
* So we will reconfigure the Linux kernel to load the right driver module. 
```shell
sudo dpkg-reconfigure nvidia-dkms-550
```