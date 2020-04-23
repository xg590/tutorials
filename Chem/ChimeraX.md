command: remotecontrol rest start/stop
```python
def chimera(*argv, port=34659):
    cmd = [('command', c) for c in argv] 
    req = urllib.request.Request(url=f"http://127.0.0.1:{port}/run", data = urllib.parse.urlencode(cmd).encode('utf8'))
    return urllib.request.urlopen(req).read().decode() 
def chimera_adduct(name, port=64348):
    row = df.loc[name] 
    cr = row['covalent_record'] 
    print(cr)
    cr = cr.split(',') 
    print( 'close all;', f'open {cr[0]};', 'focus;', f'select :{cr[6]}.{cr[2]} || :{cr[17]}.{cr[13]} ;', 'del :HOH;', 'display sel;', '~ribbon sel;', f'color cyan :{cr[6]}.{cr[2]} ;')  # f'select :.{cr[13]} ', f'write format pdb selected #0 chimera.pdb',  

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
