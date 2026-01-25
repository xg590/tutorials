* Compile on Ubuntu 24.04.3 LTS
```
obabel -L formats 
```
```sh 
pip install openbabel-wheel
```
```py
from openbabel import pybel
mol = pybel.readstring("smi", "CC(=O)Br")
mol.make3D()
print(mol.write("sdf"))
```

 