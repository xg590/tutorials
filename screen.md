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
