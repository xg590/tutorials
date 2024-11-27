* Lookahead
```shell
ss -npt | grep 222.xxx.xxx.xxx | grep -Po "(?<=,pid=)[0-9]*" | xargs -I % kill -9 %
```