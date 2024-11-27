
### Software RAID [credit](https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu#creating-a-raid-5-array)
* List all partition tables
```
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
```
* Wipe out the partition table of disks
```
for i in b c d f g h ; do echo sd$i ; wipefs -a -f /dev/sd$i ; done
# dd if=/dev/zero of=/dev/sd$i bs=512 count=1 ; 
# dd if=/dev/zero of=/dev/sd$i bs=512 count=2048 seek=$((`blockdev --getsz /dev/sd$i` - 2048)) ;
```
* Create the RAID5 array
```
mdadm --verbose \
      --create /dev/md0 --level=5 \
      --raid-devices=5  /dev/sdb  \
                        /dev/sdc  \
                        /dev/sdd  \
                        /dev/sdg  \
                        /dev/sdh
```
* Monitor the progress of mdadm
```
# cat /proc/mdstat
##  Result  ##########################################################################
#   Personalities : [raid6] [raid5] [raid4]                                          #    
#   md0 : active raid5 sdg[4] sdf[2] sdd[1] sdb[0]                                   #    
#         1757787648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]  #
#         bitmap: 0/5 pages [0KB], 65536KB chunk                                     #  
#                                                                                    #      
#   unused devices: <none>                                                           # 
######################################################################################      
```
* Mount and test 
```
mkfs.ext4 -F /dev/md0
mkdir -p       /home/share/storage
mount /dev/md0 /home/share/storage
df -h -x devtmpfs -x tmpfs -x efivarfs -x overlay
```
* Persistence
```
mdadm --detail --scan >> /etc/mdadm/mdadm.conf 
update-initramfs -u 
echo '/dev/md0 /home/share/storage/ ext4 defaults,nofail,discard 0 0' >> /etc/fstab
```
* List drives are part of a RAID array
```
mdadm -v --detail --scan /dev/md0
```