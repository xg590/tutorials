```shell
docker run -it --rm -v $PWD:/workspace --name test ubuntu:22.04 bash
# Install pytorch
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
export DST_DIR=/opt 
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $DST_DIR/miniconda3/
$DST_DIR/miniconda3/bin/conda env create -f envs.yaml
$DST_DIR/miniconda3/bin/conda activate egret_env
```

docker container commit --pause --author xg590@nyu.edu 92f40b19cd9f Egret:notebook

cat << EOF > .abc/cfg/jupyter_notebook_config.py
c.NotebookApp.ip = '*'
c.NotebookApp.token = ''
c.NotebookApp.password = ''
c.NotebookApp.allow_root = True
c.NotebookApp.open_browser = False
c.NotebookApp.notebook_dir = '/workspace'
EOF


cat << EOF > run.sh
screen -d -m -S egret
screen -S egret -X stuff 'docker run --gpus '"device=0"' --rm -p 8890:8888 -v $PWD:/workspace --name ${PWD##*/} -it egret:notebook bash ^M'
screen -S egret -X stuff 'source /opt/miniconda3/bin/activate egret_env ; jupyter-notebook --config /workspace/.abc123/cfg/jupyter_notebook_config.py ^M'
EOF