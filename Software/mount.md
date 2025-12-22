* Hide a disk icon on the left panel (Ubuntu Dock)
```sh
udisksctl mount -b /dev/sdXn --options noatime,x-gvfs-hide
```