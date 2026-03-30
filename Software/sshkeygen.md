mkdir .ssh
cd .ssh
ssh-keygen -t ed25519 -C liweiwei
type id_ed25519.pub
(echo) > config
notepad config
host gpu 
  hostname 192.168.1.106
  user liweiwei