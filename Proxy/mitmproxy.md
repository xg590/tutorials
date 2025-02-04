### Get Start
1. On the proxy server (OK to run in singularity env). [[Server option](https://docs.mitmproxy.org/stable/concepts-options/)]
```
pip install wheel mitmproxy
mitmproxy --listen-host 0.0.0.0 --listen-port 12345
```
2. Configure proxy settings on the client device to use x.x.x.x and 8080 as parameters of the <b>MANUAL</b> http proxy
3. Use broswer on the client device to visit http://mitm.it and download the root cert.
4. Import and trust the cert in Ubuntu so you can use wget or similar tools. (Carefully follow all instructions if you are using iOS) 
```
sudo mv mitmproxy-ca-cert.pem /usr/local/share/ca-certificates/mitmproxy.cert
sudo update-ca-certificates
``` 
5. If you need Chrome or Firefox, You have to trust the cert in these browsers. Trust Settings: Trust this certificate for identifying websites.
### Proxy Chain
* If we have to chain two mitmproxy (one for mitm attack and one for IP proxy), the downstream mitmproxy verify the upstream mitmproxy by default and throw out 502 Bad Gateway warning. Turn off the verification.
```
mitmproxy --listen-host 0.0.0.0 --listen-port 12345 --mode upstream:https://10.0.0.10:12345 --ssl-insecure --set console_mouse=false
```
### Handle request in mitmproxy
```shell
? help
z clear screen
f filter         # !(~t image/jpeg) & (~u /homepage)
w save flow      # /path/of/saved/flows
```
### Parse saved flows in Python
```
from mitmproxy import io, http
from mitmproxy.exceptions import FlowReadException 

with open("/path/of/saved/flows", "rb") as logfile:
    freader = io.FlowReader(logfile) 
    try:
        for f in freader.stream(): 
            if not isinstance(f, http.HTTPFlow): continue
            if f.response.headers.get(b'Content-Type') in ['image/png', 'image/jpeg']: continue 
            print(f.request.url)
            print(f.request.headers)
            print(f.response.headers.get(b'Content-Type')) 
            print(f.response.content.decode()) 
    except FlowReadException as e:
        print(f"Flow file corrupted: {e}")
```
### Write addon.py to modify response header
* The way to program mitmproxy is writing an [addon](https://docs.mitmproxy.org/stable/addons-overview/) script. 
```
class ModifyResponseHeader:  
    def response(self, flow): 
        flow.response.headers["foo"] = "bar" 

addons = [ ModifyResponseHeader() ] 
```
* Run it then check the result
```
mitmproxy -s addon.py
```
* More example @ https://docs.mitmproxy.org/stable/addons-examples/
