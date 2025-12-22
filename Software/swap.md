* Rebuild swap.img
```sh
swapon --show
swapoff /swap.img
dd if=/dev/zero of=/swap.img bs=1M count=128 
chmod 600 /swap.img
mkswap /swap.img
swapon /swap.img
echo '/swap.img none swap sw 0 0' | sudo tee -a /etc/fstab
```