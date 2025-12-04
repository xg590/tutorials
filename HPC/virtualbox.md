
#### Example
* Remote Installation
```sh
vboxmanage hostonlyif create
vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1
vboxmanage dhcpserver add --ifname vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0 --lowerip 192.168.56.100 --upperip 192.168.56.200
vboxmanage dhcpserver modify --ifname vboxnet0 --enable

free -h

VM_NAME=ubuntu2204ser1

vboxmanage createmedium disk --format VDI --size  5000 --filename ~/VMs/$VM_NAME/${VM_NAME}.vdi
vboxmanage createmedium disk --format VDI --size  6000 --filename ~/VMs/$VM_NAME/${VM_NAME}_bak.vdi
vboxmanage createmedium disk --format VDI --size 12000 --filename ~/VMs/$VM_NAME/${VM_NAME}_new.vdi


vboxmanage createvm --name $VM_NAME --ostype Ubuntu_64 --register --basefolder ~/VMs
vboxmanage modifyvm        $VM_NAME --memory 8000 
vboxmanage modifyvm        $VM_NAME --vrdeaddress 127.0.0.1 --vrdeport 12345
vboxmanage modifyvm        $VM_NAME --vram 256 --audio-driver alsa --audiocontroller ac97 --vrde on
vboxmanage modifyvm        $VM_NAME --nic2 hostonly --hostonlyadapter2 vboxnet0
vboxmanage storagectl      $VM_NAME --name SATA --add sata --controller IntelAhci --bootable on
vboxmanage storagectl      $VM_NAME --name IDE  --add ide  --controller PIIX4     --bootable on
vboxmanage storageattach   $VM_NAME --storagectl SATA --port 1 --device 0 --type hdd --medium ~/VMs/$VM_NAME/${VM_NAME}.vdi

cat << EOF_1 > /tmp/postInst.sh
apt update y 
apt install -y openssh-server screen vim
ssh-keygen -t ed25519 -N '' -C 'hpcInVm.251104' -f /root/.ssh/id_ed25519
cp /root/.ssh/id_ed25519.pub /root/.ssh/authorized_keys
echo "`cat ~/.ssh/id_ed25519.pub`" >> /root/.ssh/authorized_keys
echo "a ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopw
cat << EOF_2 > /etc/ssh/sshd_config.d/allow_root.conf
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin prohibit-password
EOF_2
init 0
EOF_1

VBoxManage unattended install $VM_NAME   \
  --user=a                               \
  --password=a                           \
  --locale=en_US                         \
  --hostname=node.localhost              \
  --no-install-txs                       \
  --full-user-name=a                     \
  --no-install-additions                 \
  --package-selection-adjustment=minimal \
  --post-install-template=/tmp/postInst.sh \
  --auxiliary-base-path=/tmp/installation.log \
  --iso=/var/www/html/samba/ubuntu-22.04.5-live-server-amd64.iso

vboxmanage startvm $VM_NAME --type headless
```
* Clone
```
sgdisk -e /dev/sdb
parted -s /dev/sdb mklabel gpt mkpart primary 0% 100%
mkfs.ext4 /dev/sdb1 
mkdir /tmp/sdb1
mount /dev/sdb1 /tmp/sdb1/

parted -s /dev/sdc mklabel gpt mkpart primary 0% 100%
mkfs.ext4 /dev/sdc1 


VBoxManage internalcommands sethduuid ubuntu2204ser_clone.vdi
vboxmanage storageattach $VM_NAME --storagectl SATA --device 0 --type hdd --port 2 --medium xxx.vdi

vboxmanage storageattach $VM_NAME --storagectl SATA --port 3 --device 0 --type hdd --medium ~/VMs/ubuntu2204ser/ubuntu2204ser_bak.vdi

vboxmanage storageattach $VM_NAME --storagectl SATA --port 4 --device 0 --type hdd --medium ~/VMs/ubuntu2204ser/ubuntu2204ser_new.vdi
```
* A
```sh

rm /etc/cloud/cloud.cfg.d/90-installer-network.cfg /etc/netplan/50-cloud-init.yam

vboxmanage startvm $VM_NAME --type headless
VBoxManage dhcpserver findlease --interface=vboxnet0 --mac-address=0800270C7B16

sudo apt install p7zip-full
```