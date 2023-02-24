* Build Image
```
mkdir mitm
cd mitm
cat << EOF > Dockerfile
# syntax=docker/dockerfile:1
FROM python:3
RUN useradd -m newuser
USER newuser
WORKDIR /home/newuser
ENV PATH="/home/newuser/.local/bin:${PATH}"
RUN pip3 install --upgrade pip
RUN pip3 install --user mitmproxy
RUN pip3 cache purge
CMD [ "bash" ]
EOF

docker build -t mitm .
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
           mitm mitmproxy --listen-host 0.0.0.0 -s ${HOME}/addon.py
curl --proxy "http://192.168.56.102:54321" http://192.168.1.22
```
* Save image
```  
docker image ls
docker save mitm > mitm.tar 
```
* Migrate
```
docker load < mitm.tar 
docker run mitm env
alias mitm="cd /path/to/mitm ; docker run --interactive --tty --publish 8080:8080 --mount type=bind,src=${PWD}/addon.py,target=${HOME}/addon.py mitm mitmproxy --listen-host 0.0.0.0 -s ${HOME}/addon.py"
```