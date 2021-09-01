### Q_Emulator?
Install Qemu
```
sudo apt-get update && sudo apt-get install qemu-system-arm qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager
sudo virsh --connect=qemu:///system net-start default
```
### Emulate Raspberry Pi OS Lite (Release date: May 7th 2021)
```
wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-5.4.51-buster 
wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/versatile-pb-buster-5.4.51.dtb
``` 
```
sudo virt-install \
  --name rpios  \
  --machine versatilepb \
  --arch armv6l \
  --cpu arm1176 \
  --vcpus 1 \
  --memory 256 \
  --network bridge,source=virbr0,model=virtio  \
  --video vga  \
  --graphics spice \
  --events on_reboot=destroy \
  --import  \
  --boot 'dtb=versatile-pb-buster-5.4.51.dtb,kernel=kernel-qemu-5.4.51-buster,kernel_args=root=/dev/vda2 panic=1' \
  --disk 2021-05-07-raspios-buster-armhf-lite.img,format=raw,bus=virtio 
```
