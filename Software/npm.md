## Local package vs Global package
* where I can find local package? ```./node_modules```
```sh 
$ npm install playwright
added 2 packages in 593ms
$ find . 
./package-lock.json
./node_modules
$ playwright -V
Version 1.61.1
```
* Where to find user-owned package? ```~/.nvm/versions/node/v24.18.0/lib/node_modules```
```sh
$ npm install -g playwright
```
* Which playwright takes precedency? ```local > user-owned```
* List the installed packages: local ```npm list``` vs user-owned ```npm list -g``` 