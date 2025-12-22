* Backup 
```shell
# Backup Ubuntu in a file
dd if=/dev/sdb of=ubuntu.img bs=1M status=progress
```
* Restore script
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

chmod 700 clone.sh
for i in b c d e f g h; do ./clone.sh ubuntu.img sd$i ; done
```