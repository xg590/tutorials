### Install openssh-server for Ubuntu24.04 offline
```
sudo su
PATHFORDEPS=/tmp/openssh_server
apt-get download openssh-server 
mkdir $PATHFORDEPS/archives
apt-get -o dir::cache=$PATHFORDEPS build-dep --download-only openssh-server
apt-get download openssh-sftp-server openssh-client
```
