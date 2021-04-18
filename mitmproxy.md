### Install mitmproxy on Linux
```
pip install wheel mitmproxy
```
### Install root CA certificate 
* Windows: Install mitmproxy-ca-cert.p12 
  * Find root CA [certificate](https://docs.mitmproxy.org/stable/concepts-certificates/) in .mitmproxy directory
* iOS: Visit mitm.it 
### Capture webpage
```shell
mitmproxy --set block_global=false
? help
z clear screen
f filter # !(~t image/jpeg) & (~u /homepage)
w save flow
```
### Write Python script to modify response header
* The way to program mitmproxy is writing an [addon](https://docs.mitmproxy.org/stable/addons-overview/) script. 
```
class ModifyResponseHeader:  
    def response(self, flow): 
        flow.response.headers["foo"] = "bar" 

addons = [ AddHeader() ] 
```
* Run it then check the result
```
mitmproxy --set block_global=false -s addon.py
```
* More example @ https://docs.mitmproxy.org/stable/addons-examples/
### Read response in Python
```
# 
from mitmproxy import io, http
from mitmproxy.exceptions import FlowReadException 

with open("homepage", "rb") as logfile:
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
