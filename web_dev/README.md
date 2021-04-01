### Frontend (Vue.js)
```html
<html>  
<body> 
  <script src="https://unpkg.com/vue/dist/vue.min.js"> </script>
  <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
  <div id="aaa">  
    <p>Random number: <% randomNumber %></p>
    <button @click="getRandomFromBackend()">New random number</button>
  </div>
  <script>
    new Vue({       
      el: '#aaa',    
      delimiters: ["<%","%>"],
      data: {         
        randomNumber: 'Please Press The Button~'
      },
      methods: {
        getRandomFromBackend () {
          const path = `http://127.0.0.1:5000/api/random`
          axios.get(path)
            .then(response => {
              this.randomNumber = response.data.randomNumber
            })
            .catch(error => {
              console.log(error)
            })
        }
      }
    });
  </script>
</body>
</html>
```
### Backend (Flask)
```python
#!/usr/bin/env python 
from flask import Flask, render_template, jsonify 
from random import *
app = Flask(__name__, template_folder = "./") # if you would like place frontend.html in another folder,
                                              # change the template_folder 
@app.route('/api/random')
def random_number():
    response = {
        'randomNumber': randint(1, 100)
    }
    return jsonify(response)
@app.route('/')
def frontpage():
    return render_template("frontend.html")
app.run('127.0.0.1', 5000)
```
### What did the web server do behind the scenes.
There is an amazing [speech](https://youtu.be/WqrCnVAkLIo) and here is a [PDF](https://github.com/xg590/tutorials/blob/master/web_dev/Web_API_Crash_Course.pdf) documented the experiment inspired by it.
### CORS (Cross-Origin Resource Sharing)
CORS: The server tells the client in the response that what kind of origin it CAN come from. 
* For example, server A tell a user's browser to access a resource on server B. 
* If the resource on server B is configured properly, the browser will be noticed by server B that it is OK to access.  
* Here is a proper response example from server B.
```
HTTP/1.1 200 OK 
Content-Length: 20
Access-Control-Allow-Origin: http://serverA
Content-type: application/json; charset=UTF-8

{"randomNumber":123}
```
* If server B gives other guidance, the user's browser will refuse to access the resource due to browser's CORS policy. 
* Here is a problem-causing response. Access fails because user's browser learned from server B that it can only access the resource if server C tells it to do so.
```
HTTP/1.1 200 OK 
Content-Length: 20
Access-Control-Allow-Origin: http://serverC
Content-type: application/json; charset=UTF-8

{"randomNumber":123}
```
