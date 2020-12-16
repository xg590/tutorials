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
vboxmanage showvminfo <vmname>
```
* RDP configuration
```
vboxmanage modifyvm <vmname> --vrde on
vboxmanage modifyvm <vmname> --vrdeaddress 127.0.0.1 --vrdeport 12345
```
* Start a machine headlessly
```
vboxmanage startvm <vmname> --type headless
```
* List running machines
```
vboxmanage list runningvms
```
* Delete a virtual machine
```
vboxmanage unregistervm dst --delete
```
* Delete a medium
``` 
vboxmanage closemedium  disk  7dcc971c-6266-46d5-8668-0c7a4d1f6132 --delete
```
### Install a Ubuntu20.04.1 Guest OS
1. Create a profile (yyy is virtual machine name, xxx is sub-folder)
```
vboxmanage createvm --name yyy --basefolder ~/xxx --ostype Ubuntu_64 --register 
```
2. RAM
```
vboxmanage modifyvm yyy --memory 8000 
```
3. Set video card ram 256MB, turn on remote desktop env.
```
vboxmanage modifyvm yyy --accelerate3d on --vram 256 --audio alsa --audiocontroller ac97 --vrde on
```
4. Set up two controllers (IDE and SATA)
```
vboxmanage storagectl yyy --name SATA --add sata --controller IntelAhci --bootable on
vboxmanage storagectl yyy --name IDE  --add ide  --controller PIIX4     --bootable on
```
5. Create a virtual disk 
```
vboxmanage createmedium disk --filename ~/xxx/yyy/yyy.vdi --format VDI --size 10240
```
6. Attache virtual disk and Ubuntu Installation CD
```
vboxmanage storageattach yyy --storagectl SATA --port 0 --device 0 --type hdd      --medium ~/xxx/yyy/yyy.vdi 
vboxmanage storageattach yyy --storagectl IDE  --port 0 --device 0 --type dvddrive --medium ~/ubuntu-20.04.1-desktop-amd64.iso 
```
7. Configure Networking
```
vboxmanage modifyvm yyy --nic1 nat --nictype1 82540EM --cableconnected1 on
```
