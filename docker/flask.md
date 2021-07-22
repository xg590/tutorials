### Deploy a flask project
[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
```
cd /tmp
python3 -m venv cleanPython
source cleanPython/bin/activate
pip3 install flask
mkdir test && cd test
pip freeze > requirements.txt
# /tmp/cleanPython can be removed after we have requirements.txt
cat << EOF > app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Docker!'
EOF 

cat << EOF > Dockerfile
# syntax=docker/dockerfile:1  
FROM python:3.8-slim-buster
# /app would be the working directory created in filesystem of container.
WORKDIR /app                         
# copy requirement.txt and app.py from host machine into /app dirctory of container 
COPY . . 
# CWD is /app for pip3 installation
RUN pip3 install -r requirements.txt 
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"] 
EOF

docker build -t newimage .
docker run -dp 192.168.x.xxx:5000:5000 newimage
```
* Access the shell
```
$ docker ps
CONTAINER ID   IMAGE      COMMAND                  CREATED         STATUS         PORTS                           NAMES
02e786c5c7b5   newimage   "python3 -m flask ru…"   2 minutes ago   Up 2 minutes   192.168.x.xxx:5000->5000/tcp   ecstatic_perlman
docker exec -it 02e786c5c7b5 bash
``` 
