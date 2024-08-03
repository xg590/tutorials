### Environmental Variables
```shell
EXT=/var/www/html/samba/Grounded-Segment-Anything/ext
screen -S gsam -d -m
screen -S gsam -X stuff "docker run --interactive --tty --rm -p 8889:8888 --gpus all \
--mount type=bind,source=$EXT/bashrc,target=/root/.bashrc \
-e PIP_TARGET=/root/.local/lib/python3.10/site-packages \
-v $EXT/huggingface:/root/.cache/huggingface \
-v $EXT/cfg:/root/.jupyter \
-v $EXT/site-packages:/root/.local/lib/python3.10/site-packages \
-v ${EXT%/*}:/home/appuser/Grounded-Segment-Anything \
--name=gsa gsa:v0 ^M"
screen -S gsam -X stuff "jupyter-notebook ^M"
```