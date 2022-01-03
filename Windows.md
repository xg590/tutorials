### Install Windows to External SSD
* I got a SanDisk Extreme PRO USB (SSD), and I want install Windows 10 on it.
1. Install a clean Win10 in VirtrualBox.
1.1. If the target PC use UEFI instead of Legacy BIOS, then Win10 VM should be installed with EFI. 
1.2. Turn on EFI support: VM Settings-> System -> Extended Features: Enable EFI (special OSes only)
2. Mount the win10-installed 50GB disk in a Ubuntu VM.
3. dd the disk to SanDisk USB.
```
dd if=/dev/sdb | pv | dd of=/dev/sdc bs=64K
```
* If Win10 disk is 50GB then USB may have 70GB unallocated free space left.
### Route 
I got two Network Interface Cards (NICs), and each has its place in routing table. Since only the second NIC is connect to the internet, I will delete the route involving the 1st NIC.<Br>
#### Show the routing table
```
> route print
```
Result
```
===========================================================================
Interface List 
 14...MAC of the 1st NIC ......Brand of the 1st NIC                           # IP binds to this NIC is 192.168.10.2
 17...MAC of the 2nd NIC ......Brand of the 2nd NIC                           # IP binds to this NIC is 192.168.0.75
===========================================================================

IPv4 Route Table
===========================================================================
Active Routes:
Network Destination        Netmask          Gateway       Interface  Metric
          0.0.0.0          0.0.0.0     192.168.10.1     192.168.10.2     55
          0.0.0.0          0.0.0.0     192.168.0.22     192.168.0.75     36
=========================================================================== 
```
With the help of command <i>ipconfig</i>, we should know the ip-interface binding relation.  
* Interface number of the 1st NIC is 14 and that of the 2nd NIC is 17.   
* Actually we don't need delete the 1st route since it has a higher metric value. Internet links go through the 2nd interface automatically. 
#### Delete a route
```
> route delete 0.0.0.0 if 17
```
```
sdelete.exe c: -z
VBoxManage.exe modifymedium disk "D:\win10.vdi" --compact
```
### Python and PIP
1. Download and install [Python3](https://www.python.org/) 
2. Download and run [get-pip.py](https://bootstrap.pypa.io/get-pip.py)
```cmd
python get-pip.py
```
### Firewall
```
netsh advfirewall firewall add rule name="sshd" dir=in action=allow protocol=TCP localport=22
```
### Service
```cmd
powershell Get-Service 
powershell Start-Service -Name "sshd" 
powershell Set-Service -Name "sshd" -StartupType Automatic    
```
### ACL
```
icacls administrators_authorized_keys /inheritance:r
icacls administrators_authorized_keys /grant SYSTEM:(F)
icacls administrators_authorized_keys /grant BUILTIN\Administrators:(F)
```
### Backup Driver
```
Export-WindowsDriver -Online -Destination “D:\Drivers Backup”
```
### NUC + Razer Core X
* [Troubleshooting: Nvidia graphical card not recognized](https://community.intel.com/t5/Intel-NUCs/RTX-3060Ti-not-working-with-NUC-and-eGPU-Razer-Core-X-Chroma/td-p/1253473)
* Turn on High Performance Power Mode in PowerShell
```
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
```
