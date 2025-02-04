* Install a WSGI server
```
pip install gunicorn
```
* Create wsgi.py in the folder that has app.py
```
cat << EOF > wsgi123.py
from app import app

if __name__ == "__main__":
    app.run()
EOF

flask-hello-world/
├── app.py
├── wsgi.py
```
* Run
```
gunicorn -w 4 -b 0.0.0.0:8000 wsgi123:app
```