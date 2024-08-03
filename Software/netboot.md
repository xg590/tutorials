## Background Knowledge
* [Ref 1 : PXE](https://ubuntu.com/server/docs/how-to-netboot-the-server-installer-on-amd64) 
* [Ref 2: autoinstall.yaml](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)
* [Ref 3: Storage secton of autoinstall.yaml](https://curtin.readthedocs.io/en/latest/topics/storage.html)
* Preboot Execution Environment (PXE) enables computers to boot through the network and load an operating system in RAM. 
* For a loaded Ubuntu, autoinstall.yaml enables the unattended installtion.
* DHCP tells PXE where the bootloader file can be found (IP of TFPT server)  ß
* TFTP is used for transferring firmware updates, configuration files, or boot files.
* HTTP serves the installation image and autoinstall.yaml 
* You should know that the motherboard firmware could be BIOS or UEFI
## PXE + autoinstall.yaml 
* Prepare DHCP / TFTP / HTTP servers
  ```shell
  apt install -y dnsmasq apache2 tftp-hpa whois # whios is for mkpasswd
  systemctl disable dnsmasq apache2
  systemctl stop NetworkManager
  ip addr add 192.168.123.1/24 dev enp0s3 # Give the NIC an ephemeral IP so dhcpd can listen on it. Otherwise dhcpd will exit abnormally.
  
  # We better provide the installing machine internet otherwise autoinstallation can crash.
  echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward >/dev/null 
  iptables -P FORWARD ACCEPT
  iptables -t nat -A POSTROUTING -s 192.168.123.0/24 -o enp0s8 -j MASQUERADE  

  DATE=`date|sed 's/ /_/g'`
  ssh-keygen -q -t ed25519 -C "ubuntu_install@$DATE" -N '' -f ~/.ssh/installation
  cp ~/.ssh/installation.pub ~/.ssh/authorized_keys
  USER_SSH_KEY=`cat ~/.ssh/installation.pub`
  USER_PASSWD=`mkpasswd --method=sha-512 123456`
  TFTP_ROOT=/srv/tftp
  
  cat << EOF > /etc/dnsmasq.conf
  interface=enp0s3
  bind-interfaces
  dhcp-range=192.168.123.2,192.168.123.254
  dhcp-match=set:x86-legacy,option:client-arch,0
  dhcp-match=set:x86_64-uefi,option:client-arch,7
  dhcp-match=set:x86_64-uefi,option:client-arch,9
  # dhcp-boot=[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
  dhcp-boot=tag:x86-legacy,pxelinux.0,,192.168.123.1
  # bootx64.efi and grubx64.efi do not work 
  dhcp-boot=tag:x86_64-uefi,grubnetx64.efi.signed,,192.168.123.1
  enable-tftp
  tftp-root=$TFTP_ROOT
  EOF
  mkdir -p $TFTP_ROOT/casper
  systemctl restart dnsmasq apache2
  sleep 5
  systemctl status  dnsmasq apache2
  ```
  ```shell
  mount /var/www/html/ubuntu-24.04-live-server-amd64.iso /mnt
  cp /mnt/casper/initrd  $TFTP_ROOT/casper/ # initial_ramdisk
  cp /mnt/casper/vmlinuz $TFTP_ROOT/casper/ # kernel
  ```
* #BIOS (Legacy)
  ``` shell
  apt download pxelinux syslinux-common     # Legacy bootloader
  
  dpkg-deb --fsys-tarfile pxelinux*.deb        | tar x ./usr/lib/PXELINUX/pxelinux.0               -O > /srv/tftp/pxelinux.0
  dpkg-deb --fsys-tarfile syslinux-common*.deb | tar x ./usr/lib/syslinux/modules/bios/ldlinux.c32 -O > /srv/tftp/ldlinux.c32

  mkdir $TFTP_ROOT/pxelinux.cfg 
  tee /srv/tftp/pxelinux.cfg/default << EOF >/dev/null 
   DEFAULT install
   LABEL install
     KERNEL /casper/vmlinuz
     INITRD /casper/initrd
     APPEND root=/dev/ram0 ramdisk_size=1500000 ip=dhcp url=http://192.168.123.1/ubuntu-24.04-live-server-amd64.iso autoinstall cloud-config-url=http://192.168.123.1/autoinstall_legacy.yaml 
  EOF
  ``` 
  ``` shell
  cat << EOF > /var/www/html/autoinstall_legacy.yaml
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
        enp0s3:
          dhcp4: true
        enp0s8:
          dhcp4: true
    storage:
      config:
      - { type: disk     , path: /dev/sda    , id: sda_123               , ptable: gpt   , preserve: false, wipe: superblock, grub_device: true }
      - { type: partition, device: sda_123   , id: part1_bios_grub_spacer, number: 1     , size: 1MB      , flag: bios_grub                     } # required by GRUB on first disk 
      - { type: partition, device: sda_123   , id: part2_boot            , number: 2     , size: 1GB                                            } # /boot partition 
      - { type: partition, device: sda_123   , id: part3_root            , number: 3     , size: 9GB                                            } # /root partition
      - { type: partition, device: sda_123   , id: part3_ext             , number: 4     , size:  -1                                            } # /ext  partition
      - { type: format   , volume: part2_boot, id: fs_boot               , fstype: ext4                                                         }
      - { type: format   , volume: part3_root, id: fs_root               , fstype: ext4                                                         }
      - { type: format   , volume: part3_ext , id: fs_ext                , fstype: ext4                                                         }
      - { type: mount    , device: fs_boot   , path: /boot               , id: mount_boot                                                       }
      - { type: mount    , device: fs_root   , path: /                   , id: mount_root                                                       }
      - { type: mount    , device: fs_ext    , path: /ext                , id: mount_ext                                                        } 
    user-data:
      disable_root: false
      package_upgrade: false
      timezone: America/New_York
      users:
        - name: ubuntu
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
      - 'echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /target/etc/sudoers.d/nopw'
      - chmod 440 /target/etc/sudoers.d/nopw
  EOF
  ```
* #UEFI (Logical Volume)
  ```shell
  wget http://archive.ubuntu.com/ubuntu/dists/jammy/main/uefi/grub2-amd64/current/grubnetx64.efi.signed -O $TFTP_ROOT/grubnetx64.efi.signed    # UEFI bootloader

  mkdir $TFTP_ROOT/grub  
  cat << EOF > $TFTP_ROOT/grub/grub.cfg
  set timeout=3
  menuentry "[ PXE + autoinstall ] Ubuntu Server 24.04" {
          set gfxpayload=keep
          linux   /casper/vmlinuz root=/dev/ram0 ramdisk_size=1500000 ip=dhcp url=http://192.168.123.1/ubuntu-24.04-live-server-amd64.iso autoinstall cloud-config-url=http://192.168.123.1/autoinstall_uefi.yaml 
          initrd  /casper/initrd
  }
  EOF
  ```  
  ```shell
  cat << EOF > /var/www/html/autoinstall_uefi.yaml 
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
        enp0s3:
          dhcp4: true
        enp0s8:
          dhcp4: true
    storage:
      config:
      - { type: disk         , path    : /dev/sda  , id: sda_123    , ptable: gpt   , preserve: false, wipe: superblock, grub_device: false }
      - { type: partition    , device  : sda_123   , id: part1_efi  , number: 1     , size: 512MB    , flag: boot      , grub_device: true  } # EFI
      - { type: partition    , device  : sda_123   , id: part2_boot , number: 2     , size:   1GB                                           } # /boot partition 
      - { type: partition    , device  : sda_123   , id: part3_pv   , number: 3     , size:    -1                                           } # physical volume
      - { type: lvm_volgroup , devices : [part3_pv], id: vg1        , name: vg1                                                             } # volume group
      - { type: lvm_partition, volgroup: vg1       , id: lv1        , name: lv1     , size:   8GB                                           } # logical volume
      - { type: lvm_partition, volgroup: vg1       , id: lv2        , name: lv2     , size:    -1                                           } # logical volume
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
        - name: ubuntu
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
      - 'echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /target/etc/sudoers.d/nopw'
      - chmod 440 /target/etc/sudoers.d/nopw
  EOF
  ```
### Misc
* Alt storage section: Let ubuntu decide
  ```
    storage:
      layout:
        name: direct
  ```
* Use isc-dhcp-server and tftpd-hpa
  ```
  cat << EOF > /etc/dhcp/dhcpd.conf 
  default-lease-time 600;
  max-lease-time 7200;
  option arch code 93 = unsigned integer 16; # RFC4578 
  subnet 192.168.123.0 netmask 255.255.255.0 {
    range 192.168.123.2 192.168.123.254;
    option routers 192.168.123.1;
    option domain-name-servers 8.8.8.8, 8.8.4.4; 
    next-server 192.168.123.1;           # tftp server ip
    if option arch = 00:07 or option arch = 00:09 {
      filename "grubnetx64.efi.signed";  # UEFI bootloader 
    }
    else if option arch = 00:0b {
      filename "bootaa64.efi";
    }
    else  {
      filename "pxelinux.0";             # Legacy bootloader  
    } 
  }
  EOF
  tee /etc/default/isc-dhcp-server << EOF > /dev/null # specify the interfaces dhcpd should listen to.
  INTERFACESv4="enp0s3"
  EOF
  ```
* sth else
  ```
  #- sed -i 's|^root:.:|root:$USER_PASSWD:|' /target/etc/shadow
  ```
* check
  ```
  systemctl restart dnsmasq
  journalctl -u dnsmasq -f
  ```