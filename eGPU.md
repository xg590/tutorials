### Windows 10
* Material List
  * Razor Core X 
  * RTX 3060 Ti
  * Intel NUC
* Connection
  * Thunderbolt 3 PCIe x4 connection (rear connector only) is supported according to Intel NUC [datasheet](https://www.intel.com/content/dam/support/us/en/documents/intel-nuc/NUC10i357FN_TechProdSpec.pdf). 
  * Use rear end USB Type-C port.  
* Windows 10 High Performance Mode: Powershell in Admin Privilege 
```
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
```
* Install Nvidia Driver  
