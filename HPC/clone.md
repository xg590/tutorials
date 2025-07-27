* Backup 
```shell
# Backup Ubuntu in a file
dd if=/dev/sdb of=ubuntu.img bs=1M status=progress
```
* Restore script
```
cat << EOF > clone.sh
IMG=\$1
SDX=\$2
dd if=$IMG of=/dev/\${SDX} bs=1M status=progress
# Repair the GPT table
sgdisk --move-second-header /dev/\${SDX} 
# Resize the last partition and filesystem
parted /dev/\${SDX} print free
parted /dev/\${SDX} --script resizepart 3 100%
sleep 3
e2fsck -f /dev/\${SDX}3
resize2fs /dev/\${SDX}3
EOF

chmod 700 clone.sh
for i in b c d e f g h; do ./clone.sh ubuntu.img sd$i ; done
```