dd if=/dev/zero of=/var/www/html/jupyter123.ext3 bs=1M status=progress count=1000
mkfs.ext3 /var/www/html/jupyter123.ext3
mkdir -p /tmp/jupyter123
sudo mount -o loop /var/www/html/jupyter123.ext3 /tmp/jupyter123
sudo chown $USER /tmp/jupyter123 

python3 -m venv /tmp/jupyter123
source /tmp/jupyter123/bin/activate

 
export PIP_ROOT="/tmp"
export PIP_PREFIX="jupyter123"
export PYTHONPATH="/tmp/jupyter123/lib/python3.10/site-packages"
export JUPYTER_CONFIG_DIR="/tmp/jupyter123/cfg" 
export PATH="/tmp/jupyter123/bin:\$PYTHONPATH/bin:\$PATH"

pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install --upgrade pip
pip install notebook==7.2.2 wheel
pip cache purge

mkdir -p /tmp/jupyter123/cfg
cat << EOF >  /tmp/jupyter123/cfg/jupyter_notebook_config.py
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.allow_root = True
c.ServerApp.open_browser = False
#c.ServerApp.root_dir = '/tmp/jupyter123'
EOF
  docker build --no-cache -t notebook:7.2.2 .
  ```
* \# Configure Jupyter notebook
  ```shell
  
  mv Dockerfile .abc123/cfg

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