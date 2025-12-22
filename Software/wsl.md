### Offline Install Windows Subsystem For Linux  
* Download WSL Kernel wsl.2.6.2.0.x64.msi from [https://github.com/microsoft/wsl/releases]
* Double Click msi to install it
* Enable requried Windows Features then reboot Windows
```sh
wsl --install
```
* Download Ubuntu distro ubuntu-24.04.3-wsl-amd64.wsl from [Here@Tsinghua](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/24.04.3/)
* Double Click wsl to install it
#### Set up Openssh Server [Credit](https://medium.com/@wuzhenquan/windows-and-wsl-2-setup-for-ssh-remote-access-013955b2f421)
* In CMD/Powershell with administrator previlidge, set up the port forwarding and a firewall rule.
```shell
sudo apt update -y && sudo apt install -y openssh-server
# Port Forwarding
netsh interface portproxy add v4tov4 connectaddress=127.0.0.1 connectport=22 listenaddress=0.0.0.0 listenport=22

# Enabling Inbound Rule on Windows Firewall
netsh advfirewall firewall add rule name="Allow sshd" dir=in protocol=TCP action=allow localport=22
```
* In WSL, set up the sshd service
```shell
sudo apt update -y && sudo apt install -y openssh-server
```

#### Set up Apache Server
```sh
FOR /F "tokens=1" %I IN ('wsl hostname -I') DO (
    netsh interface portproxy add v4tov4 ^
        listenaddress=0.0.0.0 listenport=80 ^
        connectaddress=%I    connectport=80
)
netsh advfirewall firewall add rule name="Allow apache2" dir=in protocol=TCP action=allow localport=80
```
#### Jump to cmd or PS from WSL

```sh
alias powershell="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
alias cmd="/mnt/c/Windows/System32/cmd.exe"
alias Activate='/mnt/c/Windows/System32/cmd.exe /K "C:\Users\$USER\anaconda3\Scripts\activate.bat"'
```
### Download WSL manually
* Goto [WSL offline release](https://github.com/microsoft/wsl/releases)
```sh
wget https://github.com/microsoft/WSL/releases/download/2.6.2/wsl.2.6.2.0.x64.msi
```
### Autostart
* Put a bat in startup folder
```sh
( 
    echo wsl -d Ubuntu-24.04
) > "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\start_wsl.bat"
```
### Softlink
```sh
mklink c:\Windows\vboxmanage "c:\Program Files\Oracle\VirtualBox\VBoxManage.exe" 
```
### Reset
* Reset WSL network 
```sh
netsh winsock reset
netsh int ip reset all
netsh winhttp reset proxy
ipconfig /flushdns

wsl --shutdown
```