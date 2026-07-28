```sh
sudo apt install curl
curl -fsSL https://download.aicodemirror.com/env_deploy/env-install.sh | bash
```
* Reboot the machine
```sh
sudo reboot 
npm install -g @anthropic-ai/claude-code
```
* Config
```sh
ANTHROPIC_AUTH_TOKEN=

cat << EOF >> .bashrc
export ANTHROPIC_BASE_URL="https://api.aicodemirror.com/api/claudecode"
export ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_AUTH_TOKEN"
umask 0000
cd ${PWD}
EOF
```