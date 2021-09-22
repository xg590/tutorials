* Install 
```shell
set CYGWIN_ROOT=C:\cygwin
# Download installer (x86)
httpget.exe http://yzlab3.chem.nyu.edu/software/cygwin-x86.exe 
httpget.exe http://yzlab3.chem.nyu.edu/software/apt-cyg %CYGWIN_ROOT%\bin\apt-cyg
cygwin-x86.exe --quiet-mode --root %CYGWIN_ROOT% --site http://cygwin.mirror.constant.com --packages "wget" 
```
* Start
```shell
set CYGWIN_ROOT=C:\cygwin
%CYGWIN_ROOT%\Cygwin.bat
```
* Play
  * No need to umount before dd
  * Commands like fdisk are under /sbin/, we have to use abs path 
```
df -h
/sbin/fdisk.exe -l /dev/sdb
dd if=2021-05-07-raspios-buster-armhf-lite.img of=/dev/sdb bs=1M
```
