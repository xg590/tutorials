# Partition table manipulator for Linux

## Try to backup a disk and clone it to a bigger disk

* Save partition table of the smaller disk and partition separately.

```sh
sudo sfdisk -d /dev/sdX > partition_table.sfdisk
sudo dd if=/dev/sdX1 of=sdX1.img bs=64K status=progress
```

* The partition table (.sfdisk file) is like

```sh
sfdisk -d /dev/sda
label: gpt
label-id: xxxx-xxxx-xxxx-xxxx-xxxx
device: /dev/sda
unit: sectors
first-lba: 2048
last-lba: 52428766
sector-size: 512

/dev/sda1 : start=        2048, size=        2048, type=21686148-6449-6E6F-744E-656564454649, uuid=1EA86FD4-5CF2-4634-9A6D-627E97244337
/dev/sda2 : start=        4096, size=    22462464, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=F068EA16-F507-49FF-8669-475C2BB59C32
```

* The new disk is bigger and it already has a disk so the new sfdisk is like

```sh
label: gpt
unit: sectors
first-lba: 2048
sector-size: 512

/dev/sda1 : start=        2048, size=        2048, type=21686148-6449-6E6F-744E-656564454649, uuid=1EA86FD4-5CF2-4634-9A6D-627E97244337
/dev/sda2 : start=        4096, size=    22462464, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=F068EA16-F507-49FF-8669-475C2BB59C32
/dev/sda3 : start=   133818368, size= 116264960  , type=L 
```

* **last-lba: 52428766** is gone and **/dev/sda3 : start=   133818368, size= 116264960  , type=L** is added because the new disk is bigger is 133_818_368 sectors and 133_818_368 is much bigger than 52_428_766. Without deleting **last-lba**, we will get the following error.

```sh
/dev/sda3: Sector 133818368 already used.
Failed to add #3 partition: Numerical result out of range
```

* New disk

```sh
sudo sfdisk /dev/sdY < partition_table.sfdisk
sudo dd if=sdX1.img of=/dev/sdY1 bs=64K status=progress
```

* Type in GPT

| 用途                 | GUID                                   | 简写        |
| -------------------- | -------------------------------------- | ---------- |
| EFI System Partition | `C12A7328-F81F-11D2-BA4B-00A0C93EC93B` | U          |
| Microsoft Basic Data | `EBD0A0A2-B9E5-4433-87C0-68B6B72699C7` | M          |
| Linux filesystem     | `0FC63DAF-8483-4772-8E79-3D69D8477DE4` | L          |
| Linux swap           | `0657FD6D-A4AB-43C4-84E5-0933C84B4F4F` | S          |
| BIOS Boot Partition  | `21686148-6449-6E6F-744E-656564454649` | B          |
