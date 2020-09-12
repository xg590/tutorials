```shell
sudo dpkg --add-architecture i386 && dpkg --print-foreign-architectures
sudo apt-get update && sudo apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 
cat << EOF > dst_in_screen.sh
screen -s /bin/bash -d -m -S dst
screen -S dst -X stuff 'bash ${PWD}/run_dedicated_servers.sh'\$(echo -ne '\015')
EOF
(crontab -l 2>/dev/null; echo "@reboot bash ${PWD}/dst_in_screen.sh") | crontab - 
screen -S dst -X stuff ^C # Stop running
```
