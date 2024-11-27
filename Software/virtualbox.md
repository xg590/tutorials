### Install Guest OS on Ubuntu <a name="VirtualBox"></a>
0. Install extpack 
```
sudo vboxmanage extpack install xxx.vbox-extpack
```
1. Create a profile (vmname is virtual machine name, xxx is sub-folder)
```
vmname=ubuntu22.04.3
vboxmanage createvm --name $vmname --ostype Ubuntu_64 --register --basefolder ~/xxx 
```
2. RAM
```
vboxmanage modifyvm $vmname --memory 8000 
```
3. Set video card ram 256MB, turn on remote desktop env.
```
vboxmanage modifyvm $vmname --accelerate3d on --vram 256 --audio-driver alsa --audiocontroller ac97 --vrde on
vboxmanage modifyvm $vmname --vrdeaddress 127.0.0.1 --vrdeport 12345
```
4. Set up two controllers (IDE and SATA)
```
vboxmanage storagectl $vmname --name SATA --add sata --controller IntelAhci --bootable on
vboxmanage storagectl $vmname --name IDE  --add ide  --controller PIIX4     --bootable on
```
5. Create a virtual disk 
```
vboxmanage createmedium disk --format VDI --size 20000 --filename ~/xxx/vmname/vmname.vdi 
```
6. Attache virtual disk and Ubuntu Installation CD
```
vboxmanage storageattach $vmname --storagectl SATA --port 0 --device 0 --type hdd      --medium ~/xxx/vmname/vmname.vdi 
vboxmanage storageattach $vmname --storagectl IDE  --port 0 --device 0 --type dvddrive --medium ~/ubuntu-20.04.1-desktop-amd64.iso 
```
If you need eject dvd 
```
vboxmanage storageattach $vmname --storagectl IDE  --port 0 --device 0 --type dvddrive --medium emptydrive
```
7. Add a NAT adapter
```
vboxmanage modifyvm $vmname --nic1 nat --nictype1 82540EM --cableconnected1 on
``` 
8. Create hostonly adapter [vboxnet0]
```
vboxmanage hostonlyif create 
vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1
vboxmanage dhcpserver add --ifname vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0 --lowerip 192.168.56.100 --upperip 192.168.56.200
vboxmanage dhcpserver modify --ifname vboxnet0 --enable
```
9. Use hostonly adapter
```
vboxmanage modifyvm $vmname --nic2 hostonly --hostonlyadapter2 vboxnet0
``` 
10. Start a machine headlessly
```
vboxmanage startvm $vmname --type headless
```
### Snapshot
* Take
```
vboxmanage snapshot $vmname take    fresh --description="upgraded,openssh,2Kres"
```
* Restore
```
vboxmanage list vms
vboxmanage snapshot $vmname list
vboxmanage snapshot $vmname restore fresh
```
### Tricks
* [Manual](https://www.virtualbox.org/manual/ch08.html)
* List virtual machines
```
vboxmanage list vms
``` 
* List medium 
```
vboxmanage list hdds
```
* Show the current configuration
```
vboxmanage showvminfo $vmname
```
* RDP configuration
```
vboxmanage modifyvm $vmname --vrde on
vboxmanage modifyvm $vmname --vrdeaddress 127.0.0.1 --vrdeport 12345
```
* List running machines
```
vboxmanage list runningvms
```
* Delete a virtual machine
```
vboxmanage unregistervm <vmname> --delete
```
* Delete a medium
``` 
vboxmanage closemedium disk 7dcc971c-6266-46d5-8668-0c7a4d1f6132 --delete
```
* Copy a file to Guest
```
vboxmanage guestcontrol <vmname> copyto --username ??? --password=??? --target-directory "c:\\Users\\???\\Desktop\\"  ???
```
* Add more cpu cores
```
vboxmanage modifyvm <vmname> --cpuhotplug on # 
vboxmanage modifyvm <vmname> --cpus 3        # 3 cpu cores at most
vboxmanage modifyvm <vmname> --plugcpu 1     # Add core 1. Core 0 is the default one.
vboxmanage modifyvm <vmname> --plugcpu 2     # Add core 2
```
* Add VBoxGuestAdditions.iso
```
vboxmanage storageattach <vmname> --storagectl SATA --port 1 --device 0 --type dvddrive --medium /usr/share/virtualbox/VBoxGuestAdditions.iso
vboxmanage storageattach <vmname> --storagectl SATA --port 1 --device 0 --type dvddrive --medium emptydrive
```
* Register an old VM
```
vboxmanager registervm xxx.vbox
```
* Compress a disk
```
dd if=/dev/zero of=/somewhere bs=4M
vboxmanage modifymedium --compact /path/to/the/disk.vdi
```
#### Warp Drive
* Disabling the Guest Additions Time Synchronization
```
cd C:\Progra~1\Oracle\VirtualBox
VBoxManage setextradata <VM-name> "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled" 1
```
* Accelerate the virtual guest clock 200%. 
```
VBoxManage setextradata <VM-name> "VBoxInternal/TM/WarpDrivePercentage" 200
```
#### Troubleshooting
* In case of "No USB devices available" on linux host, set proper group id for current user (credit to [csorig](https://superuser.com/a/957636))
```
sudo usermod -aG vboxusers $USER
```
* "Failed to attach the USB device xxx to the virtual machine xxxx"
  * It may because VBox extenstion package is not installed or the USB device need a higher version of controller. 
  * Enable USB controller in Virtual Machine Settings 
  * Choose 3.0 Controller 
