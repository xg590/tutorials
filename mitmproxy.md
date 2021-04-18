### Installation
* Download [mitmproxy](https://mitmproxy.org/) 
* Find root CA [certificate](https://docs.mitmproxy.org/stable/concepts-certificates/) in .mitmproxy directory
  * Install mitmproxy-ca-cert.p12 for Windows
### Write python script to modify response header
* The way to program mitmproxy is writing an [addon](https://docs.mitmproxy.org/stable/addons-overview/) script.
addon.py
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
