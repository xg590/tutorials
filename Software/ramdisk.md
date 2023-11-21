### Put file in Cache in Linux
* 2.8G data in cache before we do anything
```shell
sudo mkdir /ramdisk
sudo mount ramfs -t ramfs /ramdisk/
sudo chmod 777 /ramdisk
$ free -h
               total        used        free      shared  buff/cache   available
Mem:            32Gi       3.5Gi        26Gi       413Mi       2.8Gi        27Gi
Swap:           31Gi          0B        31Gi
```
* 12G data in cache and the writing speed is 6.2 GB/s (vs 2.1 GB/s to my NVMe SSD)
```
$ dd if=/dev/zero of=/ramdisk/10G bs=1M count=10230 status=progress conv=fdatasync
6242172928 bytes (6.2 GB, 5.8 GiB) copied, 1 s, 6.2 GB/s
10230+0 records in
10230+0 records out
10726932480 bytes (11 GB, 10 GiB) copied, 1.71934 s, 6.2 GB/s
$ free -h
               total        used        free      shared  buff/cache   available
Mem:            32Gi       3.6Gi        26Gi       413Mi        12Gi        27Gi
Swap:           31Gi          0B        31Gi
$ dd if=/dev/zero of=/tmp/10G bs=1M count=10230 status=progress conv=fdatasync
9013559296 bytes (9.0 GB, 8.4 GiB) copied, 3 s, 3.0 GB/s
10230+0 records in
10230+0 records out
10726932480 bytes (11 GB, 10 GiB) copied, 5.2046 s, 2.1 GB/s
```
