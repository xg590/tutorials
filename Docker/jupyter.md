* Build the docker image of jupyter
```
mkdir /tmp/jupyter
cd /tmp/jupyter
export NEWUSER="newuser" 
cat << EOF > Dockerfile
# syntax=docker/dockerfile:1
FROM python:3
RUN useradd -m $NEWUSER
USER $NEWUSER
WORKDIR /home/$NEWUSER
ENV PATH="/home/$NEWUSER/.local/bin:\$PATH"
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install --upgrade pip
RUN pip3 install jupyter notebook==6.4.11 traitlets==5.9.0 jupyter_contrib_nbextensions wheel
RUN            mkdir -p /home/$NEWUSER/dev/cfg
ENV JUPYTER_CONFIG_DIR="/home/$NEWUSER/dev/cfg"
RUN /home/$NEWUSER/.local/bin/jupyter contrib nbextension install --user
RUN pip3 cache purge
RUN       mkdir /home/$NEWUSER/new_site_packages 
ENV       PATH="/home/$NEWUSER/new_site_packages/bin:\$PATH"
ENV PIP_TARGET="/home/$NEWUSER/new_site_packages"
ENV PYTHONPATH="/home/$NEWUSER/new_site_packages" 
EOF

docker build -t jupyter .
```
* Config the jupyter server
```
mkdir jupyter
cd    jupyter
export NEWUSER="newuser" 
mkdir dev new_site_packages 
docker run -it --name cool123 jupyter bash &
sleep 10; docker cp cool123:/home/$NEWUSER/dev/cfg dev
cat << EOF > dev/cfg/jupyter_notebook_config.py
c.NotebookApp.ip = '*'
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
c.NotebookApp.open_browser = False
c.NotebookApp.notebook_dir = '/home/$NEWUSER/dev'
EOF
```
* Run in an interactive style
```
export NEWUSER="newuser" 
docker run --name jupyter123 -itp 8888:8888 -p 8080:8080                \
           -v $PWD/dev:/home/$NEWUSER/dev                             \
           -v $PWD/new_site_packages:/home/$NEWUSER/new_site_packages \
           jupyter bash
```
* Save and load 
```
docker save jupyter > jupyter.tar
docker load < jupyter.tar
```
* More
```
docker rm $(docker container ls -f 'status=exited' --quiet) # remove exited containers
```