### Install mdadm for Ubuntu22.04 offline
* Download apt-offline on the online machine for the offline machine
  ```
  apt download apt-offline python3-magic 
  # get apt-offline_1.8.4-1_all.deb python3-magic_2:0.4.24-2_all.deb 
  ```
* On the offline machine 
  ```
  dpkg -i apt-offline_1.8.4-1_all.deb python3-magic_2%3a0.4.24-2_all.deb
  apt-offline   set --install-packages mdadm --update apt-offline.sig
  # apt-offline set                          --update apt-offline.sig # if you want to update the repo
  # apt-offline set --upgrade                --update apt-offline.sig
  ```
* Back to the online machine. 
  * The apt-offline_1.8.4-1_all.deb in the offical depo of Ubuntu 2204 since it has bugs.
  * Visit https://github.com/rickysarraf/apt-offline/releases to get the latest [apt-offline](https://github.com/rickysarraf/apt-offline/releases/download/v1.8.5/apt-offline-1.8.5.tar.gz). 
  ```
  tar zxvf apt-offline-1.8.5.tar.gz
  ./apt-offline/apt-offline get --bundle bundle.zip apt-offline.sig 
  ```
* Back to the offline machine.
  ```
  apt-offline install bundle.zip
  apt-get install mdadm
  ```