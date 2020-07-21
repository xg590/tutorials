### Run screen in script
Start a screen session in the backgroup
```
screen -d -m -S test
```
Send a command into the session
```
screen -S test -X stuff 'echo HELLO WORLD'$(echo -ne '\015')
```
* Split screen vertically  : Ctrl+a Then | (Shift+\)
* Split screen horizentally: Ctrl+a Then S (Shift+s)
* Switch region            : Ctrl+a Then Tab
* Close region             : Ctrl+a Then X (Shift+x)
* New window               : Ctrl+a Then c
* Next window              : Ctrl+a Then n
* List windows             : Ctrl+a Then w
* Specified window         : Ctrl+a Then window_number
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
youtube-dl --sub-lang en --write-sub --skip-download https://www.youtube.com/watch?v=d4EgbgTm0Bg
```
### Autossh
[src](https://www.harding.motd.ca/autossh/autossh-1.4g.tgz) tar && configure && make
```
screen -d -m -S autossh
screen -S autossh -X stuff 'autossh -M 12345 hostname'$(echo -ne '\015')
```
