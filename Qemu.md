### Q_emulator?
Install Qemu
```
sudo apt-get update && sudo apt-get install -y qemu-system-arm  
```
### Emulate Raspberry Pi OS Lite (Release date: May 7th 2021)
```
wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-5.4.51-buster 
wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/versatile-pb-buster-5.4.51.dtb
``` 
```
qemu-system-arm \
  -name rpios  \
  -machine versatilepb \
  -cpu arm1176 \
  -m 256 \
  -device "virtio-blk-pci,drive=disk0,disable-modern=on,disable-legacy=off" \
  -netdev "user,hostfwd=tcp::5022-:22" \
  -append 'root=/dev/vda2 panic=1' \
  -no-reboot \
  -drive "file=2021-05-07-raspios-buster-armhf-lite.img,if=none,index=0,media=disk,format=raw,id=disk0" \
  -dtb versatile-pb-buster-5.4.51.dtb \
  -kernel kernel-qemu-5.4.51-buster
```
