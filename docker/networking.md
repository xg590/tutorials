```
version: '3'

services:
  container1:
    image: alpine   
    command: ash 
    networks:
      - proxy-tier
    stdin_open: true
    tty: true 

  container2:
    image: alpine
    command: ash 
    networks:
      - proxy-tier 
    stdin_open: true
    tty: true 

networks:
  proxy-tier:
```
