* Shortcut
  * Split screen vertically  : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Shift</kbd>+<kbd>\ </kbd>
  * Split screen horizentally: <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Shift</kbd>+<kbd>s</kbd> 
  * Switch region            : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Tab</kbd>
  * Close region             : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Shift</kbd>+<kbd>x</kbd> 
  * New window               : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>c</kbd>
  * Next window              : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>n</kbd>
  * List windows             : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>w</kbd> 
  * Switch window            : <kbd>CTRL</kbd>+<kbd>a</kbd> Then window_number
  * Kill window              : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>k</kbd>  
* Start a screen session in the backgroup
  ```
  screen -d -m -S autossh
  ```
* Send a command into the session to run [Autossh](https://www.harding.motd.ca/autossh/autossh-1.4g.tgz) 
  ```
  screen -S autossh -X stuff 'autossh -M 12345 -fN hostname ^M'
  ```
* Environmental Variables
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