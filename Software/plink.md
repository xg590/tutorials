### Generate hash value of the private key of the target host
* shell
```
ssh-keygen -E sha256 -f /etc/ssh/ssh_host_ed25519_key -l
256 SHA256:dbB4fYlzYG+mA6gaT0/YhL2UlaMpFx01p2lDZk0V3kQ root@(none) (ED25519)
```
### Bat file on the guest machine (win10/11)
```bat
if exist plink.exe ( 
    rem file exists  
)  else (  
    powershell -Command "Invoke-WebRequest -URI 'https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe' -OutFile plink.exe"
) 

plink -D 1080 -l username123-pw password321 -batch -hostkey SHA256:dbB4fYlzYG+mA6gaT0/YhL2UlaMpFx01p2lDZk0V3kQ 1.2.3.4
```