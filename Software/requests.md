### HTTP Basic Authentication
```
import base64, requests 
encoded = base64.b64encode(b'username:password') 
r = requests.get('https://host/dav_dir/', headers={'Authorization': f'Basic {encoded.decode()}'})
r.text
```