# Nodejs

## Get and Configure Node Version Manager 

* CLI
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash # install nvm
```
* Goto Release Page and download the source code (which is a bunch of scripts)
```sh
wget https://github.com/nvm-sh/nvm/archive/refs/tags/v0.40.3.tar.gz
tar zxvf v0.40.3.tar.gz -C ~/.nvm --strip-components=1

cat << EOF >> ~/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF

source  ~/.bashrc
```

## Install latest Nodejs on Ubuntu22045

* The default version of Nodejs on ubuntu 22045 is 12.22.9 and it is too old to use.

```sh
# 设定环境变量
nvm current    # Should print v22.12.0
export NVM_NODEJS_ORG_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
nvm install 22 # install Node.js: 
node -v        # Should print v22.12.0
npm  -v        # Should print 10.9.0
```

### In China

```sh
# Create custom global install dir
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global

# Use npmmirror for speed
npm config set registry         https://registry.npmmirror.com/
npm config set disturl          https://npmmirror.com/mirrors/node/
npm config set sass_binary_site https://npmmirror.com/mirrors/node-sass/

# Update PATH
echo 'export PATH=$HOME/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```