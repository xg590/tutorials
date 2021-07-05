## Manual Setup
* [OpenSSH-Win64.zip](https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win64.zip)
* [plink.exe](https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe)  
```
# Download OpenSSH-Win64 and plink then pack all things up
wget https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win64.zip 
unzip OpenSSH-Win64.zip 
wget https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe -O OpenSSH-Win64/plink.exe 
```
```
# Generate identity files: 
ssh-keygen -t rsa -b 4096 -N '' -C '' -f OpenSSH-Win64/id_rsa 
sudo apt install putty-tools  
puttygen OpenSSH-Win64/id_rsa -o OpenSSH-Win64/id_rsa.ppk
``` 
```
# Send Identity files to remote host
scp OpenSSH-Win64/id_rsa.pub com:/home/win7/.ssh/authorized_keys
scp OpenSSH-Win64/id_rsa com:/home/win7/.ssh/id_rsa
ssh com chown -R win7:win7 /home/win7/.ssh
ssh com chmod -R 500 /home/win7/.ssh
```
```
# Replace configuration files:
cat << EOF > OpenSSH-Win64/sshd_config_default
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
cat << EOF > OpenSSH-Win64/ssh.bat
cd "%USERPROFILE%\.ssh"$CR
echo yes | plink.exe -i id_rsa.ppk -N -R 22222:localhost:2222 win7@guoxiaokang.com 
EOF
```
```
cat << EOF > OpenSSH-Win64/ssh.vbs
Set WshShell = CreateObject("WScript.Shell")$CR
WshShell.Run chr(34) & "%USERPROFILE%\Desktop\ssh.bat" & Chr(34), 0$CR
Set WshShell = Nothing$CR
EOF
```
```
# Create installation file:
cat << EOF > install.bat
cd "%~dp0"$CR
mkdir "%USERPROFILE%\.ssh"$CR
move OpenSSH-Win64\plink.exe  "%USERPROFILE%"\.ssh$CR
move OpenSSH-Win64\id_rsa.ppk "%USERPROFILE%"\.ssh$CR
move OpenSSH-Win64\id_rsa.pub "%USERPROFILE%"\.ssh\authorized_keys$CR
move OpenSSH-Win64\ssh.bat    "%USERPROFILE%\Desktop"$CR
WSCript OpenSSH-Win64\ssh.vbs$CR
move OpenSSH-Win64\ssh.vbs "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"$CR
$CR
move OpenSSH-Win64 "%PROGRAMFILES%\"$CR
cd "%PROGRAMFILES%"$CR
icacls OpenSSH-Win64 /grant Users:(OI)(CI)(F)$CR
powershell -ExecutionPolicy Bypass -File OpenSSH-Win64\install-sshd.ps1$CR
powershell Start-Service -Name "sshd"$CR
powershell Start-Service -Name "ssh-agent"$CR
powershell Set-Service -Name "sshd" -StartupType Automatic$CR
powershell Set-Service -Name "ssh-agent" -StartupType Automatic$CR
del OpenSSH-Win64.exe install.bat$CR
EOF
```
```
echo yes | zip -r OpenSSH-Win64.zip OpenSSH-Win64 install.bat
scp OpenSSH-Win64.zip nuc:/var/www/html
```
### SFX
``` 
;The comment below contains SFX script commands

Setup=install.bat
Silent=1
Overwrite=1
```
