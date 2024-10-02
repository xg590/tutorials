## Content
* [VirtualBox](#VirtualBox)
### Trubleshooting
* There were xxxx failed login attempts since the last successful login. 
  * Modify config file
```
  IdentitiesOnly=yes (ssh-agent offers too many wrong identities, suppress it)
```
### [croc](https://github.com/schollz/croc)
* Install
```
wget https://getcroc.schollz.com -O - | sudo bash -
```
* Send file via a public relay and a ReceiveCode123 is created.
```
croc send [filename]
```
* Receive file using the ReceiveCode123 via a public relay
```
croc ReceiveCode123
```
* Run a private relay server (Which MAY forward data)
```
# Two ports at least. The first port is always comm port.
croc --debug relay --ports 5001,5002,5003,5004,5005
```
* Send file via a private relay
```
# MUST use the comm port!
croc --relay guoxiaokang.com:5001 send [filename]
```
### [qft](https://github.com/TudbuT/qft)
* Static compilation
```
apt-get install -y pkg-config

wget https://github.com/TudbuT/qft/archive/refs/heads/nogui.zip
unzip nogui.zip
cd qft-nogui/
RUSTFLAGS='-C target-feature=+crt-static' cargo build --release --target x86_64-unknown-linux-gnu
ldd target/x86_64-unknown-linux-gnu/release/qft
```
* Arguments
```
qft helper   <bind-port>
qft sender   <helper-address>:<helper-port> <phrase> <filename> [bitrate] [skip]
qft receiver <helper-address>:<helper-port> <phrase> <filename> [bitrate] [skip]
```
### Scapy
* Network packet manipulator
### Terminal QR Code
```
qrencode -t ASCII 'Hello World!'
echo "Hello World" | qrencode -t ASCII
```
### curl
```
curl -x "socks5://user:pwd@127.0.0.1:1234" "http://ipinfo.io/ip"
curl --interface ppp0 http://www.google.com/
```
### Q_emulator?
#### Emu X86/AMD64
* Install
```
sudo apt-get update && \
sudo apt-get install -y qemu-kvm
```
* Create a 20GB qcow2-format virtual disk
```
qemu-img create -f qcow2 ubuntu.qcow 20G
```
* Boot from cdrom, in which a iso file is loaded. The VM uses ubuntu.qcow as harddisk and has 4096MB RAM. 
```
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow     -boot d -cdrom ubuntu-20.04.3-desktop-amd64.iso
```
* Restart after installation
``` 
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow
```
* Now we have a Ubuntu OS as Guest OS with a NAT network (10.0.2.0/24).
* By default, the NAT is a "user" type networking. 
* Let's change network range
```
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow \
                   -device e1000,netdev=net123456 \
                   -netdev user,id=net123456,net=192.168.123.0/24,dhcpstart=192.168.123.9
```
* Let's forward guest OS's port 22 to host OS's 4321 (so we can ssh into virtual machine)
```
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow \
                   -device e1000,netdev=net123456 \
                   -netdev user,id=net123456,hostfwd=tcp:127.0.0.1:4321-:22
```
### Cygwin
* Install on Windows
```shell
set CYGWIN_ROOT=C:\cygwin
# Download installer (x86)
httpget.exe http://yzlab3.chem.nyu.edu/software/cygwin-x86.exe 
httpget.exe http://yzlab3.chem.nyu.edu/software/apt-cyg %CYGWIN_ROOT%\bin\apt-cyg
cygwin-x86.exe --quiet-mode --root %CYGWIN_ROOT% --site http://cygwin.mirror.constant.com --packages "wget" 
setup-x86_64.exe --quiet-mode --root %CYGWIN_ROOT% --site https://mirrors.tuna.tsinghua.edu.cn/cygwin/ --packages "wget" 
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
apt-cyg install pv
dd if=2021-05-07-raspios-buster-armhf-lite.img | pv | dd of=/dev/sdb
```
### Useful Chrome Extension:
1. [Anything to QRcode](https://chrome.google.com/webstore/detail/anything-to-qrcode/calkaljlpglgogjfcidhlmmlgjnpmnmf)
2. [HTTP Trace](https://chrome.google.com/webstore/detail/http-trace/idladlllljmbcnfninpljlkaoklggknp)
3. [Google Input](https://chrome.google.com/webstore/detail/google-input-tools/mclkkofklkfljcocdinagocijmpgbhab)
### Win32-OpenSSH
##### # Download OpenSSH-Win32 and plink (Win7_x86)
```shell
wget https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win32.zip 
unzip OpenSSH-Win32.zip 
mv OpenSSH-Win32 OpenSSH
wget https://the.earth.li/~sgtatham/putty/latest/w32/plink.exe -O OpenSSH/plink.exe 
``` 
##### #  Download OpenSSH-Win32 and plink (Win7_x64)
```shell
wget https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win64.zip 
unzip OpenSSH-Win64.zip 
mv OpenSSH-Win64 OpenSSH
wget https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe -O OpenSSH/plink.exe 
```
##### # HttpGet
```
wget https://github.com/xg590/miscellaneous/raw/master/httpget.exe -O OpenSSH/httpget.exe  
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
### ssh-keygen
```
ssh-keygen -f /etc/ssh/ssh_host_ed25519_key.pub -l # get fingerprint of host 
ssh-keyscan -t ed25519 xxx.nyu.edu
cat << EOF > ~/.ssh/known_hosts
xxx.nyu.edu ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeEkL/sU86PJHQnqCb7tLjfzqBo0eqT2L6bGVs8givZ
xxx.nyu.edu ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVsHesY6wT8mgxyJ3B6e7OD/8v92Mc3p76EnNtX0SsU
xxx.nyu.edu ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOO1r0g8AZ9CKvBpfmZDrIvU6vr4shg60UCG90dCRD0y
EOF
ssh-keygen -Hf ~/.ssh/known_hosts
```