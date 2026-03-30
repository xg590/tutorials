* Rebuild swap.img
```sh
swapon --show
swapoff   /swapfile
dd     of=/swapfile if=/dev/zero bs=1M count=4
chmod 600 /swapfile
mkswap    /swapfile
swapon    /swapfile
echo     '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```