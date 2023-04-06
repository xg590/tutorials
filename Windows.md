###
### PowerShell
```
$URL="http://yzlab3.chem.nyu.edu/software/LogTech_unifying250.exe"
Invoke-WebRequest -URI $URL -OutFile unifying250.exe
```
### Run GUI apps on WSL2 (GUI apps does not work with WSL 1)
* Start Powershell with Admin privilege and Check the current WSL version
```
PS C:\Windows\system32> wsl --list --verbose
  NAME            STATE           VERSION
* Ubuntu-22.04    Running         1
```
* I am running "Ubuntu-22.04" but it is version 1
* Check to enable "Virtual Machine Platform" and "Windows Hypervisor Platform" Feature of Windows 10 in "Turn Windows feature on or off" 
* Reboot then Convert WSL 1 to WSL 2
```
wsl --set-version Ubuntu-22.04 2
```
* Try Google Chrome 
```
sudo apt install x11-apps -y
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install google-chrome-stable_current_amd64.deb
google-chrome
```
* Ref: [Run Linux GUI apps on the Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)
### ImDisk 
```
imdisk -a -o rw,rem,awe -p "/Q /FS:NTFS /A:64K /V:ramdisk /Y" -m Z: -s 6G
# -a attach a new volume
# -o option: read/write, removable, and use physical memory.
# -p format the volume. see the help of command format
# -m deiver letter
# -s size
```
### Shutdown Log
* eventvwr.msc
* Event Viewer (local) -> Windows Logs -> System -> Actions -> Filter Current Log
* Filter Event IDs: 1074 - initiated by an app; 6006 - turned off correctly; 6008 - improper shutdown 
### Install Windows to a USB Stick. (Microsoft discourages the installation)
* I got a 128GB SanDisk Extreme PRO USB (SSD), and I want install Windows 10 on it. 
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
### Virtualbox
```
sdelete.exe c: -z
C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe modifymedium --compact D:\win10.vdi 
```
* Drag and compact [vbox_compact.bat]
```
REM drag a .vdi file on this batch file and it will be compacted
C:\Progra~1\Oracle\VirtualBox\VBoxManage modifyhd --compact "%~1"
pause
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
### Mount USB stick on WSL
```
mount -t drvfs f: /some/path
```
### RDP issue
```
RDP Message: You must change your password before logging on the first time. Please update your password or contact
```
* We need save the RDP connection as a .rdp file then add a new line to it
  * Adding “enablecredsspsupport:i:0” to *.rdp file is used to disable “Credential Security Support Provider”(CredSSP) in the RDP client.  