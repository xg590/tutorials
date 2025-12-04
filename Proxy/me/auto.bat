@echo off
set "SSH_DIR=%USERPROFILE%\.ssh"

if not exist "%SSH_DIR%" (
    mkdir "%SSH_DIR%"
    echo Created directory: "%SSH_DIR%"
    ssh-keygen -t ed25519 -N "" -C "give_xg590" -f "%SSH_DIR%\id_ed25519"
    echo Created ssh key pair: "%SSH_DIR%"
)

(
    echo Host proxy
    echo     HostName 0.0.0.0
    echo     User bro
    echo     IdentityFile ~/.ssh/id_ed25519
    echo     Port 22
    echo     DynamicForward 127.0.0.1:8080
) > "%SSH_DIR%\config"

(
    echo 0.0.0.0 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuw1cwwhAsDg+0+0
) > "%SSH_DIR%\known_hosts"

for /f "tokens=2,*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop ^| find "Desktop"') do (
    set ABC=%%B
)

call set DESKTOP_DIR=%ABC%

(
    echo ssh proxy
) > "%DESKTOP_DIR%\kr.bat"

notepad.exe "%SSH_DIR%\config"

type "%SSH_DIR%\id_ed25519.pub"
PAUSE

REM rmdir /Q /S "%SSH_DIR%" 