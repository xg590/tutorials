### Ubuntu 20.04.2
* Material List
  * Razor Core X 
  * RTX 3060 Ti
  * Intel NUC
* Connection
  * Thunderbolt 3 PCIe x4 connection (rear connector only) is supported according to Intel NUC [datasheet](https://www.intel.com/content/dam/support/us/en/documents/intel-nuc/NUC10i357FN_TechProdSpec.pdf). 
  * Use rear end USB Type-C port. 
  * A new entry in lspci
  ```
  06:00.0 VGA compatible controller: NVIDIA Corporation Device xxxx (rev a1)
  ```
* Config
  * Install Nvidia Driver 
  ```
  bash NVIDIA-Linux-x86_64-xxx.xx.run
  Note if you later wish to re-enable Nouveau, you will need to delete these files: /usr/lib/modprobe.d/nvidia-installer-disable-nouveau.conf, /etc/modprobe.d/nvidia-installer-disable-nouveau.conf
  ```
