* Umount before remove
```
umount /ext
```
* Remove the second logical volume
```
lvremove --force /dev/mapper/vg1-lv2
```
* Extend the first logical volume
```
lvextend --resizefs --extents +100%FREE /dev/mapper/vg1-lv1
```

### Merge two disk
1. Create physical volume for each disk.
2. Create a new volume group and assign all disks for it.
3. Create a new logical volume in the volume group.
4. Create a new filesystem for the logical volume.
```
pvcreate <volume from prev list>
lvmdiskscan
vgcreate <name> /dev/vdb
mkfs.ext4 /dev/mapper/Vol_group

Change fstab if you want to map this vg to some filesystem
/dev/mapper/vg /var/lib/folder ext4 rw,user 
Mount the volume using mount -a
```