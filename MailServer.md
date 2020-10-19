## Ubuntu 20.04
0. Add a MX record to DNS registrar
1. Install MTA (Message Transfer Agent)
```shell
apt update && apt install -y postfix
``` 
2. Install MUA (Mail User Agent)
```shell
apt install -y mailutils
```
3. Test MUA
```shell
echo "This is the body of email" | mail -s "This is the subject of email" "recipient@gmail.com"
```
4. A Long Letter<br>
```mail -s "This is the subject of email" "recipient@gmail.com"```<kbd>Enter</kbd><br>
```This is the body of email```<kbd>Enter</kbd><br>
```This is a new line```<kbd>Enter</kbd><br>
<kbd>CTRL</kbd>+<kbd>D</kbd>  

