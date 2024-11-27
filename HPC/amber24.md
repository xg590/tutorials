### Installation
```shell
mkdir buildAmber && cd buildAmber
tar jxvf ../Amber24.tar.bz2      -C .
tar jxvf ../AmberTools24.tar.bz2 -C .
sed -i 's;-DCMAKE_INSTALL_PREFIX=$AMBER_PREFIX;-DCMAKE_INSTALL_PREFIX=/opt;g' amber24_src/build/run_cmake
```
* CPU ver
```shell
docker run --rm -v $PWD:/workspace --name amber -it ubuntu:22.04 bash

apt -y update
apt -y install cmake tcsh make \
               gcc g++ gfortran \
               flex bison patch bc wget \
               xorg-dev libz-dev libbz2-dev

cd amber24_src/build 
./run_cmake
make install
```
* GPU ver https://ambermd.org/GPUHowTo.php
```shell
sed -i 's;-DCUDA=FALSE;-DCUDA=TRUE;g'                                         amber24_src/build/run_cmake

docker run --gpus '"device=3"' -it -v $PWD:/workspace nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 bash
cd /workspace/amber24_src/build
apt -y update
apt -y install cmake tcsh make   \
    gcc g++ gfortran             \
    flex bison patch bc wget     \
    xorg-dev libz-dev libbz2-dev
apt clean
./run_cmake
make install
```
```shell
docker run --gpus '"device=3"' -it -v $PWD:/workspace nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04 bash
apt -y update
apt -y install cmake tcsh make   \
    gcc g++ gfortran             \
    flex bison patch bc wget     \
    xorg-dev libz-dev libbz2-dev
apt clean
rm -rf /var/lib/apt/lists/* 
tar xvf amber24.tar -C /

docker container commit --pause --author xg590@nyu.edu --change='ENTRYPOINT ["bash", "-c"]' --change='WORKDIR /workspace' --change='ENV PATH=/opt/amber24/bin:$PATH' [container_id] amber24:cuda
# ENTRYPOINT ["exec_entry", "p1_entry"]
# CMD        ["exec_cmd"  , "p1_cmd"  ] 
# exec_entry p1_entry exec_cmd p1_cmd
```
* Test (Minimise)
```shell 
docker run --gpus '"device=2"' -v $PWD:/workspace amber24:cuda "pmemd.cuda -O -i 01_Min.in -p m2_IXO.prmtop -c m2_IXO.inpcrd -o 01_Min.out -r 01_Min.rst"  # -O Overwrite / -p parameter and topology file -c coordinate file
```
* Script
```shell
cat << EOF > /usr/local/bin/pmemd.cuda 
args='pmemd.cuda'
for i in \$@;
do 
    args+=' ' ;
    args+=\$i ;
done

echo \$args
docker run --rm --gpus '"device=0"' -v \$PWD:/workspace amber24:cuda "\$args"
EOF
chmod 755 /usr/local/bin/pmemd.cuda 

pmemd.cuda0 -O -i 01_Min.in -p m2_IXO.prmtop -c m2_IXO.inpcrd -o 01_Min.out -r 01_Min.rst
```