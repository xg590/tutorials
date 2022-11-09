### Quick Start <a name="Singularity"></a>
* Download pre-built images (SIF)
```
singularity search ubuntu
singularity pull                    library://ubuntu # Download ubuntu in SIF format 
```
* Download buildable images
```
singularity build --sandbox ubuntu_123 library://ubuntu # ubuntu_123 is the folder name
```
* Need root previlige in Singularity Container (need to use apt?)
```
singularity build --sandbox       ubuntu_123 library://ubuntu
sudo singularity shell --writable ubuntu_123
Singularity> apt update
Singularity> apt install unix2dos
Singularity> exit   
```
* Build SIF
``` 
singularity build --fakeroot ubuntu.sif ubuntu_123 # Convert the folder to SIF    
singularity shell ubuntu.sif                       # test 
``` 