* port 6379
* Cheat Sheet
```
SET myKey "Hello"
GET myKey
SET myCounter123 123
INCR myCounter123
MGET myKey myCounter123
```
* More
```
KEYS my*
EXISTS myKey
EXPIRE myKey 120
TTL myKey
PERSIST myKey
DEL myKey
```