* Install PlatformIO
```sh
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p ~/software/miniconda3
rm ~/software/miniconda3/.condarc
export PATH=$PATH:~/software/miniconda3/bin
conda config --show-sources
conda config --remove channels defaults # it would fail if defaults is not in ${HOME}/.condarc
conda config --add channels               https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
conda config --set channel_priority strict # This ensures conda only pulls packages from conda-forge.
conda config --show-sources
conda create -y -n pio
source activate pio
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install -U platformio
pip cache purge
```
* Start the service
```sh
mkdir test
cd test
cat << EOF > .bashrc
umask 0000
export PLATFORMIO_CORE_DIR=${HOME}/software/platformio
export PATH=$PATH:${HOME}/software/miniconda3/bin
source activate pio
cd ${PWD}
EOF

docker container commit --pause --author xg590@nyu.edu --change='CMD ["/usr/sbin/sshd", "-D"]'  be0fabca2152 claude:sshd

docker run --rm -d --name claude -p 127.0.0.1:2222:22 \
    -v ${HOME}/software/platformio:${HOME}/software/platformio \
    -v ${HOME}/software/miniconda3:${HOME}/software/miniconda3 \
    -v $PWD/.bashrc:/root/.bashrc \
    -v $PWD:$PWD \
    --device=/dev/ttyUSB0 \
    claude:sshd
```

* Login
```sh
ssh -i ~/.ssh/claude_container -p 2222 localhost -l root
```

* Project Initialization
```sh
pio boards espressif32
mkdir blink
cd blink/
pio project init --board esp32dev
```

* Coding
```sh
我在用esp32控制两颗ws2812B灯珠，GPIO是23，以来的平台是platformio。现在创建main.cpp文件，实现对两颗WS2812B的。
```

* Build 
```sh
pio run 
```

* Upload 
```sh
pio run --target upload 
```

* List
```sh
$ pio run --list-targets
Environment    Group     Name         Title                        Description
-------------  --------  -----------  ---------------------------  ----------------------
esp32dev       Platform  buildfs      Build Filesystem Image
esp32dev       Platform  erase        Erase Flash
esp32dev       Platform  size         Program Size                 Calculate program size
esp32dev       Platform  upload       Upload
esp32dev       Platform  uploadfs     Upload Filesystem Image
esp32dev       Platform  uploadfsota  Upload Filesystem Image OTA
```