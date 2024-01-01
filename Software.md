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
### Wireshark
* Drirver of BCM4345/6 (Raspberry Pi's on-board WiFI chip) does not support "Monitor Mode". 
* A third-party WiFi Dangle RT5370 is needed. 
* Put the network interface in "Monitor Mode"
```
# On Raspberry Pi
sudo apt-get update && sudo apt-get install iw tcpdump
iw dev 
nic=wlan1 # RT5370
sudo ip link set $nic down
sudo iw $nic set type monitor
sudo ip link set $nic up 
iw dev
```
* Run [tcpdump](https://www.tcpdump.org/manpages/tcpdump.1.html) to capture wireless packets and forward it via [netcat](https://linuxcommandlibrary.com/man/netcat) on Raspberry Pi 
```shell
# tcpdump 
#   -n     Don’t convert host addresses to names.  This can be used to avoid DNS lookups. 
#   -nn    Don’t convert protocol and port numbers etc. to names either.  
#   -U     No buffer mode for the real-time analysis. Output message immediately.  
#   -w     Set the default capture file name, or '-' for standard output. 
#   port   A filter
sudo tcpdump -i $nic -nn -U -w - | nc -l 0.0.0.0 45454
```
* On a Linux PC  
```
sudo apt install wireshark ### Allow non-root user to capture packet.
sudo usermod -a -G wireshark $USER 
newgrp wireshark
wireshark -k -i TCP@192.168.x.x:45454
```
* On a Windows PC 
```
CMD F:\>            Programs\WiresharkPortable64\WiresharkPortable64.exe -k -i TCP@192.168.x.x:45454
ShortCut Target: F:\Programs\WiresharkPortable64\WiresharkPortable64.exe -k -i TCP@192.168.x.x:45454
```
* Wireshark filter
```
ip.dst_host == 192.168.x.123 && tcp.port == 8266 && websocket
wlan.fc.type_subtype == 0x0008 # beacon frame
```
* Restore
```
nic=wlan1 # RT5370
sudo ip link set $nic down 
sudo iw $nic set type managed
sudo ip link set $nic up 
```
### curl
```
curl -x "socks5://user:pwd@127.0.0.1:1234" "http://ipinfo.io/ip"
curl --interface ppp0 http://www.google.com/
```
### GitHub
#### Basics
* Push a new local repo to GitHub
```
echo "# test" >> README.md
git init
git add README.md
git commit -m "first commit"                         # record changes 
git branch -M main                                   # name current branch called main
git remote add origin git@github.com:xg590/test.git  # give the remote depo git@github.com:xg590/test.git a shorter REMOTENAME "origin"
git push -u origin main                              # push current branch to origin
```
* Other 
```
git branch -l                                        # what is current branch name
git remote -v                                        # what is remote (what does origin stand for)
```
* [Remove sensitive file](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
```
git clone git@github.com:xg590/IoT.git
cd IoT/
git filter-repo --invert-paths --path xxx/xxx/xxx.ipynb 
git remote add origin git@github.com:xg590/IoT.git
git push origin --force --all
```
* Undo `git add *`
```
git status && git reset && git status
``` 
#### Create a Depository
0. Prepare a pair of key on local machine
```shell
ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/github
``` 
1. Sign up an account on github.com
2. In the setting of your GitHub account, paste the public key.
3. In terminal, Add new entry in local ~/.ssh/config.
```shell
cat << EOF >> ~/.ssh/config 
host github.com
    user git 
    port 22
    identityfile ~/.ssh/github
EOF
``` 
4. In terminal, test a password-free connection to the github.com
```shell
ssh -T github.com
```
you will get the response "Hi xxx! You've successfully authenticated, but GitHub does not provide shell access."

5. Install git in terminal
```shell
sudo apt-get/apt-cyg/yum install git
```
6. Configure your local git
```shell
git config --global user.name  "your_name"   # This info is nothing to do with GitHub
git config --global user.email "your_email"  # This info is nothing to do with GitHub
```
7. Initialize the directory containing to-be-uploaded files
```shell
git init
```
8. Make a test file
```shell
echo "success" > test.txt
```
9. Add the test file to index 
```shell
git add test.txt
```
10. Add the indexed file to HEAD 
```shell
git commit -m "comment to this time of action"
```
11. Create a new repository on Github 
```shell
curl -u 'AccountName' https://api.github.com/user/repos -d '{"name":"NewRepoName"}'
```
* Enter you password
12. Specify the upload destination
```shell
git remote add just_a_placeholder git@github.com:yourName/NewRepoName.git
```
13. Upload
```shell
git push just_a_placeholder master
```
~Done

#### Rename a remote directory
* Only if you can ssh github.com without password, this shall work.
```shell
git clone git@github.com:AccountName/RepoName.git
cd RepoName
git mv path_name new_path_name
git commit -m "Problematic Name in Windows"
git push origin master
```
#### Manual Change
```
git add -u . 
git add *
git status 
git commit -m 'LoRa'
git push  
```
#### Revert vs. Reset
```
git log --oneline
git revert specified_HEAD # Only undo one specified commit
git reset  specified_HEAD # All commit after one specified commit
```
#### Host a Git server
* Set up a remote depo on a remote server
```
sudo su
apt install -y git
useradd -m -s /bin/bash git
su - git
mkdir ~/.ssh
ssh-keygen -t ed25519 -C '' -N '' -f "${HOME}/.ssh/id_ed25519"
cp ~/.ssh/id_ed25519.pub ~/.ssh/authorized_keys
mkdir abc.git && cd abc.git
git init --bare
```
* Local Machine
```
mkdir abc && cd abc
git init 
git add * 
git commit -m "testMyGitServer"
git remote add origin git@remote_ip:abc.git
git push origin master
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

### Conda 
#### Problem
* Sometime we may works with multiple conda installations. For example, I manage three different conda, on NYU HPC, my Windows laptop, and a online Linux webserver.
* When the development period is long, the new installation on webserver would be set up with the latest version of everything and it created a compatible problem.
* How to ensure the same conda environment across multiple installations? 
#### Solution: Create a conda environment recipe
1. Choose one conda installation as the source installation
2. Fire up the environment that is needed to be transferred on destination conda installation.
```
me@hpc:~$ source software/miniconda3/bin/activate rdkit_on_hpc
(rdkit_on_hpc) me@hpc:~$
```
3. Export an environment recipe
```
(rdkit_on_hpc) me@hpc:~$ ./software/miniconda3/bin/conda-env export > environment.yml
```
4. On another machine, for the destination conda, create the same environment with recipe.
```
me@webserver:~$ ./software/miniconda3/bin/conda-env create -f environment.yml
```
5. Now we have the same conda environment with the same name
```
me@webserver:~$ source software/miniconda3/bin/activate rdkit_on_hpc
(rdkit_on_hpc) me@webserver:~$
```
### SLURM
* Job detail
  ```
  [x@log-1 dir]$ scontrol show jobid 21919507
  JobId=21919507 JobName=log-1.hpc.nyu.edu-data
     UserId=x(x) GroupId=x(x) MCS_label=N/A
     Priority=14817 Nice=0 Account=users QOS=interact 
     RunTime=00:13:57 TimeLimit=00:30:00 TimeMin=N/A 
     TresPerNode=gres:gpu:rtx8000:1
  ```
* Task: For the following two jobs, [Credit](https://stackoverflow.com/a/53759961) 
  ```
  sbatch << EOF
  #!/bin/bash
  
  #SBATCH --ntasks=1
  
  srun --ntasks=1 sleep 11 & 
  srun --ntasks=1 sleep 12 &
  wait
  EOF
  
  sbatch << EOF
  #!/bin/bash
  
  #SBATCH --ntasks=2
  
  srun --ntasks=1 sleep 11 & 
  srun --ntasks=1 sleep 12 &
  wait
  EOF
  ```
  one job will be finish in 23 second because only one task could be run at the same time while another job finish in 12 second because two tasks could be run at the same time.
  ```
  [xg590@log-3 ~]$ sacct --format=JobID,Start,End,Elapsed,NCPUS -j 31502997 && \
                   sacct --format=JobID,Start,End,Elapsed,NCPUS -j 31502998
  JobID                      Start                 End    Elapsed      NCPUS
  ------------ ------------------- ------------------- ---------- ----------
  31502997     2023-03-31T16:15:11 2023-03-31T16:15:35   00:00:24          1
  31502997.ba+ 2023-03-31T16:15:11 2023-03-31T16:15:35   00:00:24          1
  31502997.ex+ 2023-03-31T16:15:11 2023-03-31T16:15:35   00:00:24          1
  31502997.0   2023-03-31T16:15:12 2023-03-31T16:15:23   00:00:11          1
  31502997.1   2023-03-31T16:15:23 2023-03-31T16:15:35   00:00:12          1
  JobID                      Start                 End    Elapsed      NCPUS
  ------------ ------------------- ------------------- ---------- ----------
  31502998     2023-03-31T16:15:11 2023-03-31T16:15:24   00:00:13          2
  31502998.ba+ 2023-03-31T16:15:11 2023-03-31T16:15:24   00:00:13          1
  31502998.ex+ 2023-03-31T16:15:11 2023-03-31T16:15:24   00:00:13          2
  31502998.0   2023-03-31T16:15:12 2023-03-31T16:15:23   00:00:11          1 # 
  31502998.1   2023-03-31T16:15:12 2023-03-31T16:15:24   00:00:12          1 #
  ``` 
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