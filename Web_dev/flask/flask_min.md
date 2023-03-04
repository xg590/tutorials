* One
```
export PIP_TARGET=$HOME/flaskLib
pip install flask
```
* Another
```
export PYTHONPATH=$HOME/flaskLib
from flask import Flask
app = Flask(__name__)
@app.route('/', methods=['GET'])
def index():
    return "Hello"

app.run("0.0.0.0")
```