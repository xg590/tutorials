## FTP Client <a name="ftp"></a>
```
ftp -inv ftp.ebi.ac.uk <<EOF
user anonymous {mypassword}
cd pub/databases/msd/sifts/xml
mget 5z*.xml.gz 
bye
EOF
```
Or
```
ftp -inv ftp.ebi.ac.uk <<EOF
user anonymous {mypassword}
cd pub/databases/msd/sifts/xml
get 5z8t.xml.gz
get 5z51.xml.gz
get 5zu3.xml.gz
bye
EOF
```
#### list local dir 
```
!ls 
```