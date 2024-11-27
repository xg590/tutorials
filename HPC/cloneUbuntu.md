* Clone 
```shell
# Backup Ubuntu in a zipped file
dd if=/dev/sdb bs=1M status=progress | gzip > ubuntu.img.gz
# Restore the image to a larger disk
gzip -dc ubuntu.img.gz | dd of=/dev/sdb bs=1M status=progress
# Repair the GPT table
sgdisk --move-second-header /dev/sdb
# Resize the last partition and filesystem
parted /dev/sdb print free
parted /dev/sdb --script resizepart 3 100%
e2fsck -f /dev/sdb3
resize2fs /dev/sdb3
```
* Script
```
cat << EOF > clone.sh
IMG=\$1
SDX=\$2
dd if=$IMG of=/dev/\${SDX} bs=1M status=progress
sgdisk --move-second-header /dev/\${SDX} 
parted /dev/\${SDX} print free
parted /dev/\${SDX} --script resizepart 3 100%
sleep 3
e2fsck -f /dev/\${SDX}3
resize2fs /dev/\${SDX}3
EOF
chmod 700 clone.sh

for i in b c d e f ; do ./clone.sh ubuntu.img sd$i ; done
```