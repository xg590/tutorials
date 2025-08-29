### On Ubuntu24.04.2
* Install nodejs
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash # install nvm
nvm install 22
```
* Install python env
```sh
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh
bash Miniconda3-latest-Linux-aarch64.sh -b -f -p ~/software/miniconda3/
~/software/miniconda3/bin/conda create -n cursor python=3
source ~/software/miniconda3/bin/activate cursor
```
* Copy MCP json and Rule json
### Configure Python interpreter in Cursor (Windows or Linux):
* Include Python interpreter in PATH
* Install Python Extension
* Open Command Palette (Cmd/Ctrl + Shift + P)
* Search for “Python: Select Interpreter”
* Choose your Python interpreter (or virtual environment if you’re using one)​
#### Misc
```
sudo apt install libxcb-cursor0
pip install -r requirements.txt 
pip install pyinstaller
```