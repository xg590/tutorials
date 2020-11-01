### Installation
```
mkdir ~/.jupyter
cat << EOF >> ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
EOF
sudo apt update -y && sudo apt install -y python3-pip
pip3 install jupyter jupyter_contrib_nbextensions
.local/bin/jupyter contrib nbextension install --user
```
