* Build
  ```shell 
  mkdir notebook && cd notebook

  cat << EOF > Dockerfile
  FROM python:3.12.6-slim-bookworm
  WORKDIR /workspace
  RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources 
  RUN apt update
  RUN apt install -y libgl1 libglib2.0-0 libxrender1
  RUN apt autoremove 
  RUN apt clean
  RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  RUN pip install --upgrade pip
  RUN pip install notebook==7.2.2 wheel
  RUN pip cache purge
  ENV PIP_ROOT="/workspace" 
  ENV PIP_PREFIX=".abc123"
  ENV PYTHONPATH="/workspace/.abc123/lib/python3.12/site-packages"
  ENV JUPYTER_CONFIG_DIR="/workspace/.abc123/cfg" 
  ENV PATH="/workspace/.abc123/bin:\$PYTHONPATH/bin:\$PATH"
  EOF

  docker build --no-cache -t notebook:7.2.2 .
  ```
* \# Configure Jupyter notebook
  ```shell
  mkdir -p .abc123/cfg
  mv Dockerfile .abc123/cfg

  cat << EOF >  .abc123/cfg/jupyter_notebook_config.py
  c.ServerApp.ip = '0.0.0.0'
  c.ServerApp.token = ''
  c.ServerApp.password = ''
  c.ServerApp.allow_root = True
  c.ServerApp.open_browser = False
  c.ServerApp.root_dir = '/workspace'
  EOF
  ```
* \# Run container (must rename the notebook directory)
  ```shell
  cd .. && mv notebook nb && cd nb
  cat << EOF > run.sh
  #!/bin/bash
  docker run -d --rm -p \$1:8888 -v \$PWD:/workspace --name \${PWD##*/} notebook:7.2.2 jupyter-notebook 
  EOF
  chmod 755 run.sh
  ./run.sh 8999
  ```
* Save and load 
  ```
  docker save notebook:7.2.2 | gzip > notebook7.2.2.tgz
  docker load < notebook7.2.2.tgz
  ```
* More
  ```
  docker rm $(docker container ls -f 'status=exited' --quiet) # remove exited containers
  docker builder prune -a -f 
  docker run -it --rm -p 8999:8888 -v $PWD:/workspace --name nb notebook:7.2.2 jupyter-notebook

  echo $PIP_ROOT $PIP_PREFIX $PATH $PYTHONPATH $JUPYTER_CONFIG_DIR 
  ```


  ```
  sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources 
  ```