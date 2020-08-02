### ChimeraX Installation
* libffi.so.6 problem with ChimeraX: The standalone python might be too old so that it require a old version of libffi
* The latest libffi would not solve the problem since it gives the libffi.so.8
* I found [libffi-3.2](ftp://sourceware.org/pub/libffi/libffi-3.2.tar.gz) is the right version.
```shell
sudo apt install build-essential autoconf automake libtool texinfo 
wget ftp://sourceware.org/pub/libffi/libffi-3.2.tar.gz
tar zxvf libffi-3.2.tar.gz
cd libffi-3.2/
./configure --prefix=/path_somewhere
make && make install
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path_somewhere/libffi/lib
```
### Using Chimera RESTFul
For ChimeraX, command: remotecontrol rest start/stop
```python
# /home/gxk/software/UCSF-Chimera64-1.14/bin/chimera --nogui --start RESTServer
import requests
requests.get(f'http://127.0.0.1:{44897}/run', params={'command': [
    f'close all;', 
    f'open 1pwc;',  
    f'select :62.A@OG | :400.A@.A;',   
    f'write format pdb selected #0 /tmp/chimera.pdb',  
]})  

def chimera_x(*argv, port=64602):
    cmd = [('command', c) for c in argv]  
    params = urllib.parse.urlencode(cmd) 
    req = urllib.request.Request(url=f"http://127.0.0.1:64602/run?{params}") 
    return urllib.request.urlopen(req).read().decode() 

def chimeraX_adduct(name, port=64348):
    row = df.loc[name] 
    cr = row['covalent_record'] 
    print(cr)
    cr = cr.split(',')
    chimera_x('close all;', f'open {cr[0]};', f'select /{cr[2]}:{cr[6]} /{cr[13]}:{cr[17]} ;', 
              'del :HOH;', 'display sel;', '~ribbon sel;', f'color /{cr[2]}:{cr[6]} cyan;') 
```
