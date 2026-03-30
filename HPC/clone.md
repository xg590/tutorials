## Resize Ubuntu2404
* Remake swap.img
```sh
dd if=/dev/zero of=swap.img bs=1M count=4
mkswap swap.img
```
* 如何知道分区最小可以压缩到的块数 Resize to 8GB (= 1969387 / 1024 / 1024 * 4KB)
```sh
# resize2fs -P /dev/sdb2 
resize2fs 1.47.0 (5-Feb-2023)
Estimated minimum size of the filesystem: 1969387
```
* Get 9182 MB (18806783 / 2 / 1024 MB)
```sh
# fdisk -l /dev/sda
Disk /dev/sda: 1.82 TiB, 2000398934016 bytes, 3907029168 sectors 
Units: sectors of 1 * 512 = 512 bytes 
Device       Start      End  Sectors  Size Type
/dev/sda1     2048  2203647  2201600    1G EFI System
/dev/sda2  2203648 18806783 16603136  7.9G Linux filesystem
```
* dd 
```sh
dd if=/dev/sda of=ubuntu2404.disk bs=1M count=9300 status=progress
```
* Repair lost backup GPT header
```sh
sgdisk --move-second-header ubuntu2404.disk
```
## Restore
* Restore script for Ubuntu2404
```
cat << EOF > clone.sh
IMG=\$1
DISK=/dev/\$2
dd if=\$IMG of=\${DISK} bs=1M status=progress
# Repair the GPT table
sgdisk --move-second-header \${DISK}
# Resize the last partition and filesystem
strt_sec=\$(sgdisk --info=2 \${DISK} | awk '/First sector:/ { print \$3 }')
sgdisk --delete=2 \${DISK}
sgdisk --new=2:\${strt_sec}:0 \${DISK}
partprobe \${DISK}
sleep 3
e2fsck -f \${DISK}2
resize2fs \${DISK}2
EOF
```
* Restore script for Ubuntu2204
```
cat << EOF > clone.sh
IMG=\$1
DISK=/dev/\$2
dd if=\$IMG of=\${DISK} bs=1M status=progress
# Repair the GPT table
sgdisk --move-second-header \${DISK}
# Resize the last partition and filesystem
strt_sec=\$(sgdisk --info=3 \${DISK} | awk '/First sector:/ { print \$3 }')
sgdisk --delete=3 \${DISK}
sgdisk --new=3:\${strt_sec}:0 \${DISK}
partprobe \${DISK}
sleep 3
e2fsck -f \${DISK}3
resize2fs \${DISK}3
EOF
```
```sh
chmod 700 clone.sh
for i in b c d e f g h; do ./clone.sh ubuntu.img sd$i ; done
```