### What is a Webpage
* When a user opens a link in a <i><b>browser</i></b>, the browser (in the backgroud) sends a <i><b>GET request</i></b> for data to a <i><b>web server</i></b> and then receives codes of <i><b>response</i></b> from the web server.
* Some codes are in HTML (HyperText Markup Language, learn it [here](https://www.w3schools.com/html/default.asp)) format, which dictates the rendering of the requested webpage in the browser.
  * User's browser renders following code (Code I) to be a webpage displaying the "Hello World" message and a dog's picture.  
  ```html
  <!DOCTYPE html>
  <html>
      <head>
          <style>  </style>
      <body>
          <p>Hello World</p>
          <img src="http://pet.pic/dog.jpg" /> 
          <script> </script>
      </body>
  </html>
  ``` 
  * \<html\>, \<head\>, \<body\>, \<p\>, \<img\>, and \<script\> are common tags in HTML. 
  * Codes within \<style\> tag are written in CSS (Cascading Style Sheets, learn it [here](https://www.w3schools.com/css/default.asp)) format, which customizes the appearance of other tags in \<body\> tag. For example, define the size of picture.
  * Codes within \<script\> tag are <i>Javascript</i> (Learn it [here](https://www.w3schools.com/js/default.asp)), which would make other tags reactive/dynamic. For example, remove picure when it is clicked,  
* Other codes are external content, which would be consumed in tags.
  * A rendered dog picture, code of which is fetched from <b>http://pet.pic/dog.jpg</b>, would appear at tag \<img\>'s position.  
* <i><b>Take-away: User's browser asks and gets codes from a server and renders them to be a webpage.</i></b>
### What is a Website
* From user's prespective, a website is <i><b>a collection of webpages</i></b>.
* From developer's prespective, a website is a collection of codes that will run in <i><b>user's browser</i></b> and on <i><b>a web server</i></b>. 
* Codes running in user's browser, ended up being webpages, are written by a <i><b>frontend</i></b> developer while those running on the web server are written by a <i><b>backend</i></b> developer. 
* For example, when a user comments a video on youtube's website, the frontend code in user's browser is responsible for sending the comment in a <i><b>POST request</i></b> to the web server and backend code will handle the POST request on youtube's web server and <i><b>responds</i></b> to user's browser with result of handeling. 
* <i><b>Take-away: Running frontend code requests and running backend code responds.</i></b>
### Document Object Model
* User browser construct a <i><b>DOM</i></b> (Document Object Model) based on webpage's HTML code in a branchy arrangement, so that tags within a tag become <i><b>child elements</i></b> of the <i><b>parent element</i></b>. For example, both \<head\> and \<body\> tags are rendered to become child elements of parent element came from \<html\> tag.
* DOM is an interface for element manipulation via javascript programming. For example, frontend javascript code can request new video recommendation video list and update a bunch of elements every minite so that user's browser refreshes the video list automatically. In this way, the HTML becomes dynamic (In fact, HTML is static but DOM becomes dynamic).
* <i><b>Take-away: DOM is manipulated by javascript dynamically according to backend's response.</i></b>
* Caution: Dynamic HTML is different to dynamic webpage. Browser can get a static HTML without any javascript code, generated dynamically on the web server.
### Modern Web Development
* Frontend developer can code HTML solely with a text editor from scratch, but s/he has to write DOM manipulator him- or herself. While backend developer can create web service from scratch, but s/he has to do archaic and burdensome socket programming. 
* Developers usually resort to frameworks, which provides DOM manipulator and request handler, to speed up the web development.
  * Popular frontend framework: Angular, React, <i><b>Vue</i></b>.
  * Popular backend framework: Django, ExpressJS, <i><b>Flask</i></b>.
* Frontend frameworks are almost all javascript libraries because javascript is the only programming language supported by any modern browser.
* Backend frameworks belong to various programming language. For example, Flask and Django are Python libraries while ExpressJS is a Javascript library.
## Learning Pathway
* [F] Begin with static HTML where DOM is invariant. 
  * Learn HTML [here](https://www.w3schools.com/html/default.asp). In the end, one can open a coded HTML-format local file with web browser, which displays text and picture.
  * Learn CSS [here](https://www.w3schools.com/css/default.asp). In the end, one can change the appearance of text and picture. For example, color the text with red.  
* [F] Learn to manipulate DOM.
  * Learn Javascript [here](https://www.w3schools.com/js/default.asp). In the end, one can make text and picture responsive. For example, hide the text after click or add another picture
* [B] Learn to serve HTML upon a request.
  * Learn Flask [here](https://flask.palletsprojects.com/en/2.0.x/quickstart/). In the end, the static HTML can be GETed from a web server. 
  * Use more Python code then static HTML can be dynamically generated (Optional). For example, respond to a one-time request with server's date and time during webpage fetching.
* [F] Learn javascript libraries.
  * Learn Axios.js [here](https://axios-http.com/docs/intro). It is a request composer, which enables programmatic request. For example, request server's new time every second.
  * Learn D3.js [here](https://observablehq.com/@d3/gallery). It is a data visualization library, which can create charts, maps, networks, etc.
  * Learn Vue.js [here](https://www.youtube.com/watch?v=FXpIoQ_rT_c). It is a DOM manipulator, which create dynamic webpage in the frontend.
### Role of libraries in the Full Stack Development.
* Flask serves data via API (Application Programming Interface) in the backend.
* Axios fetchs data via API in the frontend.
* D3 visulize data by manipulating DOM too.
* Vue manipulates DOM according to data. 
### Real Example: 
* We will see a new random number each time we click the button because DOM is changed (but HTML is the same).
* Run following python code and browser the webpage at http://127.0.0.1:5000
  * Browser sends a GET request to the web server at the <i><b>endpoint</i></b> http://127.0.0.1:5000.
  * Python code on server would respond the GET request with <i>HTML_code</i>.
  * Browser then renders the webpage according to HTML_code. 
  * The DOM has two visible elements \<paragraph\> and \<button\>.
  * At the point, javascript has manipulated DOM that "<% randomNumber %>" has been replace with "Please Press The Button~"
  * If user clicks the button, function getRandomFromBackend would be triggered.
  * Axios.js in the function would send a new request at http://127.0.0.1:5000/api/random and fetch a random integer.
  * If server's response is successful, varible randomNumber's value is changed.
  * Value change will automatically trigger Vue.js to manipulate \<p\> and replace "Please Press The Button~" with the newly fetched integer.
```python
HTML_code = '''
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
''' 
import flask, random  
app = Flask(__name__)  

@app.route('/')
def frontpage():
    return render_template_string(HTML_code)

@app.route('/api/random')
def random_number():
    response = {
        'randomNumber': random.randint(1, 100)
    }
    return jsonify(response) 

app.run('127.0.0.1', 5000)  
```
## @vue/cli
* @vue/cli is for website (more than webpage) development.
  * Website has multiple webpages and some elements like navigation bar and footer are shared across the site.
  * Create a page component so it can be shared and maintained individually, which makes teamwork possible.  
  * Used javascript library will be bundled together so the website becomes independent. (The site can work in a restricted network where internet is cutted off.) 
### What did the web server do behind the scenes (socket programming).
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
