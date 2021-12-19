* Flask request of header Sensitivity
```
flask.request.headers = {'foo': 'bar'}
flask.request.headers.get('FOO', None) = 'bar'
flask.request.headers.get('foo', None) = 'bar'
d = {}
d.update(flask.request.headers)
d.get('FOO', None) = None
d.get('foo', None) = 'bar' 
```
