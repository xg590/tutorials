### Run screen in script
Start a screen session in the backgroup
```
screen -d -m -S test
```
Send a command into the session
```
screen -S test -X stuff 'echo HELLO WORLD'$(echo -ne '\015')
```
### Multi-screen
### Parallelism
```
ls | head | xargs -n 1 -P 3 program_X
```
* -n num of arguments for each program
### [Move files](https://unix.stackexchange.com/a/230536)
```
rsync -rv --include '*/' --include '*.js' --exclude '*' --prune-empty-dirs --remove-source-files Source/ Target/ 
```
