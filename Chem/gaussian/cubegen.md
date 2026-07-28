```sh
export    GAUSS_MEMDEF=20GB
export OMP_NUM_THREADS=23
```
* cubegen option

|option|default|comment|
|-|-|-|
|nprocs|0|only one thread|
|npts|80|-|
```
cubegen  nprocs  kind           fchkfile  cubefile      npts format cubefile2
cubegen  0       density=SCF    mol.fchk  density.cub
cubegen  0       potential=SCF  mol.fchk  esp.cub
cubegen 12       mo=423         mol.fchk  mo.cub         -2    h
```
```
for i in `seq 1040 1056`; do cubegen 22 mo=$i         Z3Pd.fchk        Z3Pd_$i.cub -2 h ;done 
```