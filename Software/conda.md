### Conda
* Download [repo](https://repo.anaconda.com/miniconda/)
#### Migration
* Sometime we may works with multiple conda installations. For example, I manage three different conda, on NYU HPC, my Windows laptop, and a online Linux webserver.
* When the development period is long, the new installation on webserver would be set up with the latest version of everything and it created a compatible problem.
* How to ensure the same conda environment across multiple installations? 
##### Solution: Create a conda environment recipe
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
#### Moving 
* Src
``` 
export PATH=$PATH:
conda install -c conda-forge conda-pack
conda pack -n my_env -o out_name.tar.gz 
```
#### Activate Conda by default in all PowerShell
* Conda env is unavailable (in VSCode terminal for example) by default outside Anaconda PowerShell Prompt
```ps
PS C:\Users\abc123>
```
* Enable it in Anaconda PowerShell Prompt
```
(base) PS C:\Users\abc123> conda init
no change     C:\Users\abc123\anaconda3\Scripts\activate.bat
modified      C:\Users\abc123\anaconda3\Scripts\activate
modified      C:\Users\abc123\Documents\WindowsPowerShell\profile.ps1
==> For changes to take effect, close and re-open your current shell. <==
```
* Not working at first in VSCode terminal
```ps
. : 无法加载文件 C:\Users\abc123\Documents\WindowsPowerShell\profile.ps1，因为在此系统上禁止运行脚本。有关详细信息，请参阅 https:/go.microsoft.com/fwlink/?LinkID=135170 中的 
about_Execution_Policies。
```
* Solve it in VSCode terminal
```
PS > Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
PS > exit
```
* Restart Powershell
```
加载个人及系统配置文件用了 3373 毫秒。
(base) PS Microsoft.PowerShell.Core\FileSystem::\\wsl.localhost\Ubuntu-24.04\home\abc123> 
```
#### New Shenanigan
* In China
```sh
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p ~/software/miniconda3
export PATH=$PATH:~/software/miniconda3/bin
rm ~/software/miniconda3/.condarc
conda config --show-sources
conda config --remove channels defaults # it would fail if defaults is not in ${HOME}/.condarc
conda config --add channels               https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
conda config --set custom_channels.Paddle https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/
conda config --set channel_priority strict # This ensures conda only pulls packages from conda-forge.
conda config --show-sources
conda create -y -n pio
source activate pio
```
* Free World
```sh
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p ~/software/miniconda3
export PATH=$PATH:~/software/miniconda3/bin
rm ~/software/miniconda3/.condarc
conda config --show-sources 
conda config --add channels               https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main 
conda config --show-sources
conda create -y -n pio
source activate pio
```