* login-3 / 192.168.11.1
```
docker run --rm -it -v $PWD:/workspace --name pywfn ubuntu:22.04 bash

apt install python3-pip
pip install numpy tqdm rich
apt clean
pip cache purge

docker container commit --pause --author xg590@nyu.edu --change='ENV LD_LIBRARY_PATH=/opt/pywfn/libs' --change='WORKDIR /workspace' a4eab587da4c pywfn:latest

docker tag pywfn:latest localhost:5000/pywfn:latest
docker push localhost:5000/pywfn:latest
```
* node-17
```
docker pull 192.168.11.1:5000/pywfn:latest
docker run --rm -it -v $PWD:/workspace --name pywfn 192.168.11.1:5000/pywfn:latest python3 bondorder.py 
```