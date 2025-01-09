### Autoinstallation-enabled ISO of Ubuntu 2204
* Ubuntu 2204 [Desktop](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/releases/22.04.4/ubuntu-22.04.4-desktop-amd64.iso) / [Live Server](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/releases/22.04/ubuntu-22.04.4-live-server-amd64.iso)
* \# Install
  ```shell
  apt install -y xorriso whois 
  ```
* \# ENV
  ```shell
  DATE=`date | sed 's/ /_/g'`
  ssh-keygen -q -t ed25519 -C "ubuntu_install@$DATE" -N '' -f ~/.ssh/installation
  cp ~/.ssh/installation.pub ~/.ssh/authorized_keys

  DEFAULT_USERNAME=a
  USER_SSH_KEY=`cat ~/.ssh/installation.pub`
  USER_PASSWD=`mkpasswd --method=sha-512 a`
  SOURCE_ISO=/var/www/html/ubuntu-22.04.4-live-server-amd64.iso
  TARGET_ISO=/var/www/html/ubuntu-22.04.4-live-server-amd64-mod.iso
  TMPDIR=/var/www/html/ubuntu-22.04.4-live-server-amd64-iso
  mkdir $TMPDIR
  # TMPDIR=$(mktemp -d)
  ```
* \# Find out the options for xorriso to rebuild the ISO after patching it.
  ```shell
  xorriso -indev $SOURCE_ISO -report_el_torito as_mkisofs
  ```
* \# user-data(autoinstall_uefi.yaml)
  ```shell
  mkdir -p $TMPDIR/nocloud/
  touch $TMPDIR/nocloud/meta-data
  cat << EOF > $TMPDIR/nocloud/user-data 
  #cloud-config
  autoinstall:
    version: 1
    locale: en_US.UTF-8
    keyboard:
      layout: us
    refresh-install:
      update: false
    network:
      version: 2
      ethernets:
        # list all possible network interface names here so they can get IP via DHCP service. 
        enp0s3:
          dhcp4: true
        enp0s8:
          dhcp4: true
    storage:
      config:
      - { type: disk         , path    : /dev/sda  , id: sda_123    , ptable: gpt   , preserve: false, wipe: superblock, grub_device: false }
      - { type: partition    , device  : sda_123   , id: part1_efi  , number: 1     , size: 512MB    , flag: boot      , grub_device: true  } # EFI partition
      - { type: partition    , device  : sda_123   , id: part2_boot , number: 2     , size:   1GB                                           } # /boot partition 
      - { type: partition    , device  : sda_123   , id: part3_pv   , number: 3     , size:    -1                                           } # physical volume
      - { type: lvm_volgroup , devices : [part3_pv], id: vg1        , name: vg1                                                             } # volume group
      - { type: lvm_partition, volgroup: vg1       , id: lv1        , name: lv1     , size: 100GB                                           } # logical volume (partition)
      - { type: lvm_partition, volgroup: vg1       , id: lv2        , name: lv2     , size:    -1                                           } # logical volume (partition)
      - { type: format       , volume  : part1_efi , id: fs_efi     , fstype: fat32                                                         }
      - { type: format       , volume  : part2_boot, id: fs_boot    , fstype: ext4                                                          }
      - { type: format       , volume  : lv1       , id: fs_root    , fstype: ext4                                                          }
      - { type: format       , volume  : lv2       , id: fs_ext     , fstype: ext4                                                          }
      - { type: mount        , device  : fs_efi    , path: /boot/efi, id: mount_efi                                                         }
      - { type: mount        , device  : fs_boot   , path: /boot    , id: mount_boot                                                        }
      - { type: mount        , device  : fs_root   , path: /        , id: mount_root                                                        }
      - { type: mount        , device  : fs_ext    , path: /ext     , id: mount_ext                                                         } 
    user-data:
      # enable_root so that authorized_keys works 
      disable_root: false
      package_upgrade: false
      timezone: America/New_York
      users:
        - name: $DEFAULT_USERNAME
          groups: [adm, sudo]
          lock-passwd: false
          shell: /bin/bash
          passwd: $USER_PASSWD
    ssh:
      allow-pw: true
      install-server: true
      # These public keys will be included in /root/.ssh/authorized_keys
      authorized-keys: [ $USER_SSH_KEY ]
    shutdown: poweroff
    late-commands:
      - 'echo "$DEFAULT_USERNAME ALL=(ALL) NOPASSWD:ALL" > /target/etc/sudoers.d/nopw'
      - chmod 440 /target/etc/sudoers.d/nopw


    systemctl stop unattended-upgrades
    apt purge -y unattended-upgrades
  EOF

  ```
* \# Extract files from source iso
  ```shell 
  xorriso -osirrox on -indev $SOURCE_ISO -extract / $TMPDIR &>/dev/null
  chmod -R u+w $TMPDIR 
  ```
* \# Modify grub.cfg and md5sum.txt
  ```shell
  cat << EOF > $TMPDIR/boot/grub/grub.cfg 
  set timeout=3
  menuentry "Autoinstall Ubuntu Server 22.04" {
          set gfxpayload=keep
          linux   /casper/vmlinuz autoinstall ds=nocloud\\;s=/cdrom/nocloud/ ---
          initrd  /casper/initrd
  }
  EOF
  echo > $TMPDIR/md5sum.txt # Disable MD5 checksum on boot 
  ```
* \# Rebuild the bootable image
  ```shell
  cd $TMPDIR
  XORRISO_OPTIONS=`xorriso -indev $SOURCE_ISO -report_el_torito as_mkisofs 2>/dev/null  | tr "\n" " "`
  bash -c "xorriso -as mkisofs -r -o $TARGET_ISO $XORRISO_OPTIONS ." 
  ```