* Installation
```shell
set CYGWIN_ROOT=C:\cygwin
httpget.exe http://yzlab3.chem.nyu.edu/software/cygwin-x86.exe # Download installer (x86)
#httpget.exe http://yzlab3.chem.nyu.edu/software/apt-cyg %CYGWIN_ROOT%\bin\apt-cyg
cygwin-x86.exe --quiet-mode --root %CYGWIN_ROOT% --site http://cygwin.mirror.constant.com --packages "wget"
```
* Start
```shell
set CYGWIN_ROOT=C:\cygwin
%CYGWIN_ROOT%\Cygwin.bat
```
