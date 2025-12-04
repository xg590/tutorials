## Live CD + Fully-fledged Ubuntu

* 在一个高速外置硬盘上，放上Ubuntu安装光盘（相当于安装光盘的功能）以及完整的 Ubuntu 系统

1. 给硬盘分区：

   * 第0分区：EFI 分区 (512MB, FAT32, boot flag)
   * 第1分区：ext4 分区装 Ubuntu 系统
   * 第3分区：ext4/FAT32 分区放 ISO

2. 安装 Ubuntu 到 ext4 第1

分区，Bootloader 安装到 EFI 分区。

3. 拷贝 ISO 到第3分区，比如 `/img/ubuntu.iso`。

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