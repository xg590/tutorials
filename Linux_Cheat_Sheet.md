### Screen 
Start a screen session in the backgroup
```
screen -d -m -S autossh
```
Send a command into the session to run [Autossh](https://www.harding.motd.ca/autossh/autossh-1.4g.tgz) 
```
screen -S autossh -X stuff 'autossh -M 12345 hostname'$(echo -ne '\015')
```
* Split screen vertically  : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Shift</kbd>+<kbd>\ </kbd>
* Split screen horizentally: <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Shift</kbd>+<kbd>s</kbd> 
* Switch region            : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Tab</kbd>
* Close region             : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>Shift</kbd>+<kbd>x</kbd> 
* New window               : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>c</kbd>
* Next window              : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>n</kbd>
* List windows             : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>w</kbd> 
* Switch window            : <kbd>CTRL</kbd>+<kbd>a</kbd> Then window_number
* Kill window              : <kbd>CTRL</kbd>+<kbd>a</kbd> Then <kbd>k</kbd>  
### Parallelism
```
ls | head | xargs -n 1 -P 3 program_X
```
* -n num of arguments for each program
### [Move files](https://unix.stackexchange.com/a/230536)
```
rsync -rv --include '*/' --include '*.js' --exclude '*' --prune-empty-dirs --remove-source-files Source/ Target/ 
```
### Youtube-dl
```
wget https://yt-dl.org/downloads/latest/youtube-dl 
youtube-dl --sub-lang en --write-sub --skip-download https://www.youtube.com/watch?v=xxx 
youtube-dl --all-subs    --write-sub --cookies cookies.txt --user-agent "Safari/537.36" https://www.youtube.com/watch?v=xxx 
```
