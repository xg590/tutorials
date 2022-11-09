### Prerequisite
* Install Dependencies
```
sudo apt-get update && sudo apt-get install -y build-essential uuid-dev \
libgpgme-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup-bin
```
* Download Singularity 3.8.7
```
export VERSION=3.8.7
wget https://github.com/hpcng/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && tar -xzf singularity-${VERSION}.tar.gz 
```
* Choose 1 or 2
### 1. Vanila Build
* Install Go 1.14.12
```
export VERSION=1.14.12 OS=linux ARCH=amd64 && wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && rm go$VERSION.$OS-$ARCH.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
```
* Build Singularity
```
cd singularity && ./mconfig && make -C ./builddir && sudo make -C ./builddir install
```
Source bash completion file
```
. /usr/local/etc/bash_completion.d/singularity
```
### 2. [Create debian package](https://github.com/apptainer/singularity/blob/master/dist/debian/DEBIAN_PACKAGE.md) 
``` 
sudo apt install debhelper dh-autoreconf help2man libarchive-dev libssl-dev cryptsetup golang-go devscripts
cd singularity-3.8.7/
cp -r dist/debian .
debuild --build=binary --no-sign --lintian-opts --display-info --show-overrides 
dh clean
rm -rf debian
```
### Test the Build
```
singularity exec library://alpine cat /etc/alpine-release
```