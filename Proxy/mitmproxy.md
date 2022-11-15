### Get Start
1. On the proxy server. [[Server option](https://docs.mitmproxy.org/stable/concepts-options/)]
```
pip install wheel mitmproxy
mitmproxy --listen-host 0.0.0.0
```
2. Configure proxy settings on the client device to use http://x.x.x.x:8080 as http proxy
3. Use broswer on the client device to visit http://mitm.it and download the root cert.
4. Import and trust the cert.
```
sudo mv mitmproxy-ca-cert.pem /usr/local/share/ca-certificates/mitmproxy.cert
sudo update-ca-certificates
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
