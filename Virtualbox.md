* List virtual machines
```
VBoxManage list vms
```
* Show the current configuration
```
VBoxManage showvminfo <vmname>
```
* RDP configuration
```
VBoxManage modifyvm <vmname> --vrde on
VBoxManage modifyvm <vmname> --vrdeaddress 127.0.0.1 --vrdeport 12345
```
* Start a machine headlessly
```
VBoxManage startvm <vmname> --type headless
```
