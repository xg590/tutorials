### Remote and Local Port Forwarding
Application: Run a jupyter notebook on remote Linux/Mac_OS machine and visualize the result on Microsoft Windows using UCSF Chimera locally.
1. Log in the remote machine and forward a pre-chosen local port (<b><i>9999</i></b>) to the default remote port (<b><i>8888</i></b>) of the notebook server
```
I recommend the Windows Subsystem for Linux (WSL) and Putty is simpler GUI implement of ssh client
$ ssh -L 9999:127.0.0.1:8888 username@ip_of_remote_machine
```
2. Setup a jupyter notebook server on the remote machine. Use a fixed login password (<b><i>123456</i></b>) instead of token for the notebook server
```
$ cat << EOF >> .jupyter/jupyter_notebook_config.py
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
EOF
$ jupyter-notebook
```
3. We have started a jupyter notebook server and now we can login the jupyter notebook server at <a href="http://localhost:9999">http://localhost:9999</a>
4. Setup a UCSF Chimera Restful server locally (so that http request can drive the Chimera)
```
Menu bar --> Tools --> Utilities --> RESTServer (Equivalent on Linux $chimera --start RESTServer)
```
5. You can see a notice <b>REST server on host 127.0.0.1 port 50256</b>
6. Forward a pre-chosen remote port (<b><i>54321</i></b>) to the random local port (<b><i>50256</i></b>) of REST server
```
$ ssh -R 54321:127.0.0.1:50256 username@ip_of_remote_machine
```
7. Now we can drive the Chimera on remote jupyter notebook
```python
import urllib    
def chimera(*argv, port=54321):
    cmd = [('command', c) for c in argv] 
    req = urllib.request.Request(url=f"http://127.0.0.1:{port}/run", data = urllib.parse.urlencode(cmd).encode('utf8'))
    return urllib.request.urlopen(req).read().decode()
chimera('open 1pwc', port=54321)
```
