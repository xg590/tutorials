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