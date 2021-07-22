```shell
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $HOME/software/miniconda3/
$HOME/software/miniconda3/bin/conda create -y -c rdkit -n rdkit rdkit=2020.09  pandas==1.2 # -c channel; -n envName
source $HOME/software/miniconda3/bin/activate rdkit
pip install jupyter jupyter_contrib_nbextensions 
jupyter contrib nbextension install --user
mkdir ~/.jupyter
cat << EOF >> ~/.jupyter/jupyter_notebook_config.py 
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
EOF
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
### Move rdkit [ref](https://www.anaconda.com/blog/moving-conda-environments)
* Specs vs. Env: Env included pip installations
* Specs on source machine
```
conda list --explicit > spec-list.txt  
```
* Recreate on destination machine
```
conda create --name python-course --file spec-list.txt 
```
* Env on source machine
```
conda env export > environment.yml
```
* Env on desitination machine
```
conda env create -f environment.yml
``` 
