### Start man-in-the-middle Proxy [[option list](https://docs.mitmproxy.org/stable/concepts-options/)]
```
pip install wheel mitmproxy            # Installation
mitmproxy --listen-host 192.168.x.x
```

### Configure clients
* Configure MS Windows web browser, or iOS/Android WiFi settings
* Visit mitm.it to download root CA certificate 
  * Windows: Install mitmproxy-ca-cert.p12 
  * iOS/Android: Follow instructions
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
