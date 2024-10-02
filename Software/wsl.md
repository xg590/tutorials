### Windows Subsystem For Linux 
* In China, you may need to add hosts entry to combat the DNS poison

* Install Ubuntu with administrator previlidge
```cmd
wsl --install
```
#### Set up Openssh Server [Credit](https://medium.com/@wuzhenquan/windows-and-wsl-2-setup-for-ssh-remote-access-013955b2f421)
* In CMD/Powershell with administrator previlidge, set up the port forwarding and a firewall rule.
```shell
# Port Forwarding
netsh interface portproxy add v4tov4 `
  connectaddress=127.0.0.1           `
  connectport=22                     `
  listenaddress=0.0.0.0              `
  listenport=2222

# Enabling Inbound Rule on Windows Firewall
netsh advfirewall firewall add rule `
  name='Allow sshd'                 `
  dir=in                            `
  protocol=TCP                      `
  action=allow                      `
  localport=2222
```
* In WSL, set up the sshd service
```shell
sudo apt update -y && sudo apt install -y openssh-server
```