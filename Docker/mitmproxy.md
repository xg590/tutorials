* Build Image
```
cd tmp
cat << EOF > Dockerfile
# syntax=docker/dockerfile:1
FROM python:3
RUN useradd -m newuser
USER newuser
WORKDIR /home/newuser
ENV PATH="/home/newuser/.local/bin:${PATH}"
RUN pip3 install --upgrade pip
RUN pip3 install --user mitmproxy requests
RUN pip3 cache purge
EOF

docker build --tag mitmproxy .
```
* Add-on
```
# Add-on
cat << EOF > addon.py
class ModifyResponseHeader:
    def response(self, flow):
        flow.response.headers["foo"] = "bar"

addons = [ ModifyResponseHeader() ]
EOF
```
* Test Run
```
docker run --interactive --tty --publish 54321:8080                      \
           --mount type=bind,src=${PWD}/addon.py,target=${HOME}/addon.py \
           mitmproxy mitmproxy --listen-host 0.0.0.0 -s ${HOME}/addon.py
curl --proxy "http://192.168.56.102:54321" http://192.168.1.22
```
* Save image
```  
docker image ls
docker save mitmproxy > mitmproxy.tar 
```
* Migrate
```
docker load < mitmproxy.tar
docker run --name bafen_proxy --interactive --tty --publish 8080:8080      \
           --mount type=bind,src=${PWD}/addons.py,target=${HOME}/addons.py \
           mitmproxy mitmproxy --listen-host 0.0.0.0 -s ${HOME}/addons.py
```
* Bafen
```
docker start --attach bafen_proxy
docker rm $(docker container ls -f 'status=exited' --quiet) # remove exited containers
```