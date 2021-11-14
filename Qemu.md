## Q_emulator?
### Emu X86/AMD64
* Install
```
sudo apt-get update && \
sudo apt-get install -y qemu-kvm
```
* Create a 20GB qcow2-format virtual disk
```
qemu-img create -f qcow2 ubuntu.qcow 20G
```
* Boot from cdrom, in which a iso file is loaded. The VM uses ubuntu.qcow as harddisk and has 4096MB RAM. 
```
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow     -boot d -cdrom ubuntu-20.04.3-desktop-amd64.iso
```
* Restart after installation
``` 
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow
```
* Now we have a Ubuntu OS as Guest OS with a NAT network.
