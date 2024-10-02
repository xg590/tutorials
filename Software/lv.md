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