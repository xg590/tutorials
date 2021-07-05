##### # Download OpenSSH-Win64 and plink then pack all things up
```
wget https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win64.zip 
unzip OpenSSH-Win64.zip 
mv OpenSSH-Win64 OpenSSH
wget https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe -O OpenSSH/plink.exe 
```
##### # Generate identity files: 
```
ssh-keygen -t rsa -b 4096 -N '' -C '' -f OpenSSH/id_rsa 
sudo apt install putty-tools  
puttygen OpenSSH/id_rsa -o OpenSSH/id_rsa.ppk
``` 
##### # Send Identity files to remote host
```
scp OpenSSH/id_rsa.pub com:/home/win7/.ssh/authorized_keys
scp OpenSSH/id_rsa com:/home/win7/.ssh/id_rsa
ssh com chown -R win7:win7 /home/win7/.ssh
ssh com chmod -R 500 /home/win7/.ssh
```
##### # Replace configuration files:
```
cat << EOF > OpenSSH/sshd_config_default
ListenAddress 127.0.0.1
ListenAddress ::1
Port 2222

PermitEmptyPasswords no
PasswordAuthentication no
PubkeyAuthentication yes
AllowTcpForwarding yes
Subsystem sftp sftp-server.exe
EOF
```
```
CR=$'\r'
cat << EOF > OpenSSH/ssh.bat
cd "%USERPROFILE%\.ssh"$CR
echo yes | plink.exe -i id_rsa.ppk -N -R 22222:localhost:2222 win7@guoxiaokang.com 
EOF
```
```
cat << EOF > OpenSSH/ssh.vbs
Set WshShell = CreateObject("WScript.Shell")$CR
WshShell.Run chr(34) & "%USERPROFILE%\Desktop\ssh.bat" & Chr(34), 0$CR
Set WshShell = Nothing$CR
EOF
```
##### # Create installation file:
```
cat << EOF > install.bat
cd "%~dp0"$CR
mkdir "%USERPROFILE%\.ssh"$CR
move OpenSSH\plink.exe  "%USERPROFILE%"\.ssh$CR
move OpenSSH\id_rsa.ppk "%USERPROFILE%"\.ssh$CR
move OpenSSH\id_rsa.pub "%USERPROFILE%"\.ssh\authorized_keys$CR
move OpenSSH\ssh.bat    "%USERPROFILE%\Desktop"$CR
WSCript OpenSSH\ssh.vbs$CR
move OpenSSH\ssh.vbs "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"$CR
$CR
move OpenSSH "%PROGRAMFILES%\"$CR
cd "%PROGRAMFILES%"$CR
icacls OpenSSH /grant Users:(OI)(CI)(F)$CR
powershell -ExecutionPolicy Bypass -File OpenSSH\install-sshd.ps1$CR
powershell Start-Service -Name "sshd"$CR
powershell Start-Service -Name "ssh-agent"$CR
powershell Set-Service -Name "sshd" -StartupType Automatic$CR
powershell Set-Service -Name "ssh-agent" -StartupType Automatic$CR
del OpenSSH.exe install.bat$CR
EOF
```
```
echo yes | zip -r OpenSSH.zip OpenSSH install.bat
scp OpenSSH.zip nuc:/var/www/html
```
##### # SFX
``` 
;The comment below contains SFX script commands

Setup=install.bat
Silent=1
Overwrite=1
```
