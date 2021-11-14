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
* Now we have a Ubuntu OS as Guest OS with a NAT network (10.0.2.0/24).
* By default, the NAT is a "user" type networking. 
* Let's change network range
```
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow \
                   -device e1000,netdev=net123456 \
                   -netdev user,id=net123456,net=192.168.123.0/24,dhcpstart=192.168.123.9
```
* Let's forward guest OS's port 22 to host OS's 4321 (so we can ssh into virtual machine)
```
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow \
                   -device e1000,netdev=net123456 \
                   -netdev user,id=net123456,hostfwd=tcp:127.0.0.1:4321-:22
```
