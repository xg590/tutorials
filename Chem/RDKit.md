```shell 
sudo apt update && sudo apt install python3-pip python3-rdkit 
mkdir ~/.jupyter
cat << EOF >> ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
EOF
pip3 install jupyter jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
```

```shell
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $HOME/software/miniconda3/
$HOME/software/miniconda3/bin/conda create -y -c rdkit -n rdkit_2019 rdkit=2019  pandas=1.0 # -c channel; -n envName
source $HOME/software/miniconda3/bin/activate rdkit_2019
pip install jupyter jupyter_contrib_nbextensions 
jupyter contrib nbextension install --user
```
``` 
conda search libboost
conda remove -y -n rdkit pandas
conda install -y --name rdkit pandas=1.0.0 rdkit=2019.09.3.0 
```
### Solve the problem "ImportError: libboost_python3.so.1.65.1: cannot open shared object file: No such file or directory"
```shell
conda install --name rdkit libboost=1.65.1 
```
But better reinstall rdkit of 2019 version
### Test Molecule equivalency
```python
from rdkit import Chem
Chem.Mol.__eq__ = lambda self, other: True if Chem.MolToSmiles(self)==Chem.MolToSmiles(other) else False
mol1 == mol2
```
