#### Disable IPV6
sed -i 's,GRUB_CMDLINE_LINUX_DEFAULT=",GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 ,g' /etc/default/grub
sudo update-grub