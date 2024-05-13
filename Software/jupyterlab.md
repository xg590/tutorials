docker run --interactive --tty --rm -p 8889:8889 \
        -v "${PWD}"/cfg:/root/.jupyter \
        -v "${PWD}"/site-packages:/root/.local/lib/python3.10/site-packages \
        -e             PIP_TARGET=/root/.local/lib/python3.10/site-packages \
        --name=gsa1 gsa:v0  

pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install jupyterlab
export PATH=/root/.local/lib/python3.10/site-packages/bin:$PATH

cat << EOF > /root/.jupyter/jupyter_lab_config.py
c = get_config()
c.LabApp.app_dir = '/root/.local/lib/python3.10/site-packages/share/jupyter/lab' 
c.ServerApp.allow_root = True
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.password = u'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55' 
c.ServerApp.notebook_dir = '/tmp/'
c.ServerApp.port = 8889
EOF
