# Software RAID [credit](https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu#creating-a-raid-5-array)
* List all partition tables
```
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
```
* Wipe out the partition table of disks
```
for i in b c d e f g h ; do echo sd$i ; wipefs -a -f /dev/sd$i ; done
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
# mdadm --create /dev/md0   --level=0   --raid-devices=7   --chunk=512K   --metadata=1.2   /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh
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
df -h -x devtmpfs -x tmpfs -x efivarfs -x overlay # 不看tmpfs，不看overlay等
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
# Hardware RAID (Broadcom / LSI MegaRAID SAS-3 3108)
## Show all Drives
```sh
# storcli64 /c0 /eall /sall show
CLI Version = 007.2705.0000.0000 August 24, 2023
Operating system = Linux 6.8.0-106-generic
Controller = 0
Status = Success
Description = Show Drive Information Succeeded.


Drive Information :
=================

------------------------------------------------------------------------------
EID:Slt DID State DG       Size Intf Med SED PI SeSz Model            Sp Type 
------------------------------------------------------------------------------
252:0    16 JBOD  -  465.761 GB SATA SSD N   N  512B CT500BX500SSD1   U  -    
252:1    20 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:2    18 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:3    19 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:4    21 JBOD  -  558.911 GB SAS  HDD N   N  512B ST600MM0006      U  -    
------------------------------------------------------------------------------

EID=Enclosure Device ID|Slt=Slot No|DID=Device ID|DG=DriveGroup
DHS=Dedicated Hot Spare|UGood=Unconfigured Good|GHS=Global Hotspare
UBad=Unconfigured Bad|Sntze=Sanitize|Onln=Online|Offln=Offline|Intf=Interface
Med=Media Type|SED=Self Encryptive Drive|PI=PI Eligible
SeSz=Sector Size|Sp=Spun|U=Up|D=Down|T=Transition|F=Foreign
UGUnsp=UGood Unsupported|UGShld=UGood shielded|HSPShld=Hotspare shielded
CFShld=Configured shielded|Cpybck=CopyBack|CBShld=Copyback Shielded
UBUnsp=UBad Unsupported|Rbld=Rebuild
```
## Convert JBOD to UG and create RAID0
* 三块SAS盘直通
```sh
# storcli64 /c0 /eall /sall show 
Drive Information :
---------------------------------------------------------------------------------
EID:Slt DID State DG       Size Intf Med SED PI SeSz Model               Sp Type
--------------------------------------------------------------------------------- 
252:1    36 JBOD  -  558.911 GB SAS  HDD N   N  512B ST600MM0006         U  -
252:2    34 JBOD  -  558.911 GB SAS  HDD N   N  512B ST600MM0006         U  -
252:3    35 JBOD  -  558.911 GB SAS  HDD N   N  512B ST600MM0006         U  - 
--------------------------------------------------------------------------------- 
```
* 转化成UG，Linux就看不到了。
```sh
# storcli64 /c0 /e252 /s1,2,3 set good force
# storcli64 /c0 /eall /sall show 
Drive Information :
================= 
---------------------------------------------------------------------------------
EID:Slt DID State DG       Size Intf Med SED PI SeSz Model               Sp Type 
--------------------------------------------------------------------------------- 
252:1    36 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006         U  -    
252:2    34 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006         U  -    
252:3    35 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006         U  -      
---------------------------------------------------------------------------------
```
* 组RAID0，Linux看到1.8T的新磁盘
```sh
# storcli64 /c0 add vd type=raid0 drives=252:1,252:2,252:3 
Description = Add VD Succeeded.
```
* 
storcli64 /c0 add vd type=raid0 drives=252:1,252:2,252:3
## Delete Foreign Driver Group Tag
* ```UGood F``` is ```Unconfigured Good : Foreign```
```sh
# storcli64 /c0 /eall /sall show 
---------------------------------------------------------------------------------
EID:Slt DID State DG       Size Intf Med SED PI SeSz Model               Sp Type 
--------------------------------------------------------------------------------- 
252:2    41 UGood F  446.625 GB SATA SSD N   N  512B INTEL SSDSC2KB480G7 U  -  
---------------------------------------------------------------------------------
``` 
* Delete Foreign
```sh
# storcli64 /c0 /fall delete 
Status = Success
Description = Operation on foreign configuration Succeeded
Total Foreign PDs = 0
```
## Convert UG to JBOD
* Succeeded
```sh
# storcli64 /c0 /e252 /s2 set good force 
Status = Success
Description = Set Drive Good Succeeded.
```
* Convert UG to JBOD
```sh
# storcli64 /c0 /e252 /s2 set jbod force
```
## 七块硬盘组RAID5
```sh
# storcli64 /c0 /eall /sall show 
Drive Information : 
------------------------------------------------------------------------------
EID:Slt DID State DG       Size Intf Med SED PI SeSz Model            Sp Type 
------------------------------------------------------------------------------
252:0    16 JBOD  -  465.761 GB SATA SSD N   N  512B CT500BX500SSD1   U  -    
252:1    20 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:2    18 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:3    19 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:4    21 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:5    22 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:6    23 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:7    24 UGood -  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
------------------------------------------------------------------------------
```
* 
```sh
# storcli64 /c0 add vd type=raid5 drives=252:1,252:2,252:3,252:4,252:5,252:6,252:7 strip=256 wb ra
CLI Version = 007.2705.0000.0000 August 24, 2023
Operating system = Linux 6.8.0-106-generic
Controller = 0
Status = Success
Description = Add VD Succeeded.
```
* 
```sh
# storcli64 /c0 /eall /sall show
CLI Version = 007.2705.0000.0000 August 24, 2023
Operating system = Linux 6.8.0-106-generic
Controller = 0
Status = Success
Description = Show Drive Information Succeeded.


Drive Information :
=================

------------------------------------------------------------------------------
EID:Slt DID State DG       Size Intf Med SED PI SeSz Model            Sp Type 
------------------------------------------------------------------------------
252:0    16 JBOD  -  465.761 GB SATA SSD N   N  512B CT500BX500SSD1   U  -    
252:1    20 Onln  0  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:2    18 Onln  0  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:3    19 Onln  0  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:4    21 Onln  0  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:5    22 Onln  0  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:6    23 Onln  0  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
252:7    24 Onln  0  558.406 GB SAS  HDD N   N  512B ST600MM0006      U  -    
------------------------------------------------------------------------------
```
* 
```sh
# storcli64 /c0 /vall show
CLI Version = 007.2705.0000.0000 August 24, 2023
Operating system = Linux 6.8.0-106-generic
Controller = 0
Status = Success
Description = None


Virtual Drives :
==============

-------------------------------------------------------------
DG/VD TYPE  State Access Consist Cache Cac sCC     Size Name 
-------------------------------------------------------------
0/0   RAID5 Optl  RW     No      RWTD  -   OFF 3.271 TB      
-------------------------------------------------------------
```
* Use it
```sh
# lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 465.8G  0 disk 
├─sda1   8:1    0     1M  0 part 
├─sda2   8:2    0   513M  0 part /boot/efi
└─sda3   8:3    0 465.3G  0 part /
sdb      8:16   0   3.3T  0 disk 

# mkfs.ext4 /dev/sdb  
Writing superblocks and filesystem accounting information: done

# blkid

# "UUID=8a6b3c1e-5d3c-4b45-b77e-1f33c9c3b77f  /data  ext4  defaults  0  2" >> /etc/fstab

```

## Foreign Config
* Situation
```sh
# storcli64 /c0 /eall /sall show 
Drive Information :
---------------------------------------------------------------------------------
EID:Slt DID State DG       Size Intf Med SED PI SeSz Model               Sp Type
---------------------------------------------------------------------------------
252:4    37 UGood F  446.625 GB SATA SSD N   N  512B INTEL SSDSC2KB480G7 U  -
---------------------------------------------------------------------------------
```
* 你的情况其实非常典型：**盘处于 `UGood F` (Unconfigured Good + Foreign)** 状态，所以 **StorCLI 不允许直接把它改成 JBOD**。必须先处理 **Foreign configuration**，否则控制器认为这块盘仍然属于某个旧阵列。 
* 先确认 Foreign 配置 
```bash
# storcli64 /c0 /fall show 
FOREIGN CONFIGURATION : 
-----------------------------------------
DG EID:Slot Type  State       Size NoVDs
-----------------------------------------
 0 -        RAID0 Frgn  446.625 GB     1
-----------------------------------------
```
* 清除 Foreign 配置（关键）
```bash
# storcli64 /c0 /fall delete
CLI Version = 007.2705.0000.0000 August 24, 2023
Operating system = Linux 6.8.0-40-generic
Controller = 0 
Status = Success
Description = Operation on foreign configuration Succeeded

Total Foreign PDs = 0
```
* Or
```sh
# storcli64 /c0 /e252 /s4 delete foreign
```
* 再转为 JBOD 
```bash
# storcli64 /c0 /e252 /s4 set jbod
```
## Turn on JBOD 
* Current Status
```sh
# storcli64 /c0 show jbod 
Controller Properties : 
----------------
Ctrl_Prop Value 
----------------
JBOD      OFF   
----------------
```
```sh
# storcli64 /c0 set jbod=on 
Controller Properties : 
----------------
Ctrl_Prop Value 
----------------
JBOD      ON    
----------------
```
# storcli64 /c0 /e252 /s0 set jbod force
```