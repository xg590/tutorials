### Install on Ubuntu 20.04.1
* Install Dependencies
```
sudo apt-get update && sudo apt-get install -y build-essential uuid-dev libgpgme-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup-bin
```
* Install Go 1.14.12
```
export VERSION=1.14.12 OS=linux ARCH=amd64 && wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && rm go$VERSION.$OS-$ARCH.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
```
* Download Singularity 3.7.0
```
export VERSION=3.7.0 && wget https://github.com/hpcng/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && tar -xzf singularity-${VERSION}.tar.gz 
```
* Build Singularity
```
cd singularity && ./mconfig && make -C ./builddir && sudo make -C ./builddir install
```
Source bash completion file
```
. /usr/local/etc/bash_completion.d/singularity
```
Testing & Checking the Build Configuration
```
singularity exec library://alpine cat /etc/alpine-release
```
