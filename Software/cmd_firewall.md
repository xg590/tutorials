@echo off
set "DIR=C:\Program Files\Logi"

for /r "%DIR%" %%F in (*.exe) do (
    echo Blocking %%F
    netsh advfirewall firewall add rule name="BlockLogiOut_%%~nF" program="%%F" dir=out action=block
    netsh advfirewall firewall add rule name="BlockLogiIn_%%~nF" program="%%F" dir=in  action=block
)

set "DIR=C:\Program Files\LogiOptionsPlus"

for /r "%DIR%" %%F in (*.exe) do (
    echo Blocking %%F
    netsh advfirewall firewall add rule name="BlockLogiOut_%%~nF" program="%%F" dir=out action=block
    netsh advfirewall firewall add rule name="BlockLogiIn_%%~nF" program="%%F" dir=in  action=block
)

PAUSE