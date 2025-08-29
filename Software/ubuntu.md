# Sth interesting

## Live CD + Fully-fledged Ubuntu

* 在一个高速外置硬盘上，放上Ubuntu安装光盘（相当于安装光盘的功能）以及完整的 Ubuntu 系统

1. 给硬盘分区：

   * EFI 分区 (512MB, FAT32, boot flag)
   * ext4 分区装 Ubuntu 系统
   * ext4/FAT32 分区放 ISO

2. 安装 Ubuntu 到 ext4 分区，Bootloader 安装到 EFI 分区。

3. 拷贝 ISO 到某个分区，比如 `/img/ubuntu.iso`。

4. 编辑 `/boot/grub/grub.cfg`，加入类似：

   ```grub
   cat << EOF >> /etc/grub.d/40_custom
   menuentry "Ubuntu22.04.5 Installer ISO" {
       set isofile="/img/ubuntu-22.04.5-desktop-amd64.iso"
       loopback loop (hd0,3)\$isofile
       linux  (loop)/casper/vmlinuz boot=casper iso-scan/filename=\$isofile quiet splash ---
       initrd (loop)/casper/initrd
   }
   menuentry "Ubuntu24.04.3 Installer ISO" {
       set isofile="/img/ubuntu-24.04.3-desktop-amd64.iso"
       loopback loop (hd0,3)\$isofile
       linux  (loop)/casper/vmlinuz boot=casper iso-scan/filename=\$isofile quiet splash ---
       initrd (loop)/casper/initrd
   }
   EOF

   sed -i -e 's/GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/' -e 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=30/' /etc/default/grub
   ```

   这样就能从 GRUB 启动 ISO。

5. update-grub

  ```sh
  sudo update-grub
  ```

---

## other

```
https://mirror.sjtu.edu.cn/ubuntu-releases/
https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/
https://mirrors.aliyun.com/ubuntu-releases/
```
```sh
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak_`date "+%y_%m_%d"`
sudo sed -i 's/http:\/\/.*.ubuntu.com/https:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list
```
```
sudo apt install zlib1g-dev libjpeg-dev python3-dev 
```
```
wpa_passphrase <SSID> <KEY>
```