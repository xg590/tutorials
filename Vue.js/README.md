### Vue Introduction line by line
```html
 1 <!DOCTYPE html>
 2 <html>   
 3   <body>
 4     <div id="app" v-cloak>
 5       {{ msg }}
 6       <input @focusout="log" v-model="msg" />
 7       <hr />
 8       <svg><circle id="c" v-bind:cx="x" :cy="y" r="50" v-bind:fill="'pi'+z" v-on:click="goDown"/></svg>
 9       <hr />
10       <table>
11         <thead> 
12           <tr> <th> 1 </th> <th> | </th> <th> 2 </th> <th> | </th> <th> 3 </th> </tr> 
13         </thead>
14         <tbody>
15           <tr v-is="'mytr'" v-for="(item, idx) in itemList" :left123="item.left" :right456="item.right"></tr> 
16         </tbody>
17       </table>  
18     </div>
19     <script src="https://unpkg.com/vue@next"></script>
20     <script> 
21       const app = Vue.createApp({
22         data: function () {
23           return {
24             msg : "Hello World",
25             x : 50,
26             y : 50,
27             z: 'nk',
28             itemList: [{"left": 3, "right": 4},
29                 {"left": 5, "right": 6}], 
30           }
31         },
32         methods: {
33           goDown: function () {
34             var c = document.getElementById('c'); 
35             this.y += 5;
36           },
37           log: function () {
38             console.log(this.msg);
39           }
40         }
41       })
42       app.component('mytr', {
43         template: `
44         <tr> 
45           <td v-is="'mytd'" v-bind:left123nested="left123"> </td>
46           <td> {{middle}} </td>
47           <td> {{right456}} </td>
48           <td> {{middle}} </td>
49           <input v-is="'myinput'" v-model="inputValue789"/>
50         </tr>
51         ` ,
52         props:['left123', 'right456'],
53         data () {
54           return {
55             middle: "|" ,
56             inputValue789: 'preloaded content'
57           }
58         }
59       })
60       app.component('mytd', {
61         template: `
62           <td> {{left123nested}} </td> 
63         ` ,
64         props:['left123nested'],
65       })
66       app.component('myinput', {
67         template: `
68           <input v-model="inputValue012" />
69         ` ,
70         props: ['modelValue'],
71         computed: {
72           inputValue012: {
73             get () {
74               return this.modelValue;
75             },
76             set (value) {
77               console.log('Catch preloaded content: ', this.modelValue, value);
78               this.$emit('update:modelValue', value);
79             }
80           }
81         }
82       })
83       app.mount('#app') 
84     </script>
85   </body>
86 </html>
```

### Vue/cli Introduction
* Install
```
sudo su
apt update
apt install nodejs npm
npm install -g @vue/cli 
nodejs -v   
vue --version
```
* Create a project in current directory
```
vue create test_project
```
* Serve the test project @ localhost:8080
``` 
cd test_project
npm run serve
```
* Tune serve's option: Change package.json.
```
js["scripts"]["serve"] = "vue-cli-service serve --port 5000"
```
* Basics of Vue.js
   * .vue file: there are three elements, including \<template\> \<script\>, and \<style\>.
   * Template, decorated with styles, is exported in script element.
   * In script element, there is a default exported JS object. This object is where you locally register components (see an example in App.vue), define component inputs (props, see an example in HelloWorld.vue), handle local state, define methods, and more.
### Build
* if run build 
```
npm run build
```
a new subdirectory <i>dist</i>, which contains the new website, will emerge under <i>test_project</i> dir. Now it can be served via apache or <i> npm run serve </i>
### Single Page Application (SPA)
* Let's look into test_project's directory structure
```
$ tree -a public/ src/ node_modules/
public/
├── favicon.ico
└── index.html
src/
├── App.vue
├── assets
│   └── logo.png
├── components
│   └── HelloWorld.vue
└── main.js 
```
* SPA is a coordination between public/index.html, src/App.vue, src/main.js, and src/components/HelloWorld.vue.
* Begin with template file public/index.html. New element (App from src/App.vue) would be injected after \<div id="app"\>\</div\> 
```
<!DOCTYPE html>
<html lang=""> 
  <body> 
    <div id="app"></div> 
  </body>
</html> 
```
* main.js controls the injection of App to #app.
```
import { createApp } from 'vue'  // we are using vue cli so we import a class "createApp" from the module "vue"
import App from './App.vue'      // App.vue in src folder works like a javascript.
createApp(App).mount('#app')     // A new createApp instance. It mounted to a element, whose id is app, in a webpage public/index.html.
```
* New element App in src/App.vue is exported and injected. 
```
<template> 
  <img alt="Vue logo" src="./assets/logo.png"> 
  <HelloWorld msg="Welcome to Your Vue.js App"/> 
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'   

export default { 
  name: 'App',
  components: {
    HelloWorld
  }
}
</script>
```
* HelloWorld in src/components/HelloWorld.vue is exported and imported by App.vue
```
<template>
  <div class="hello">
    <h1>{{ msg }}</h1> 
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  }
}
</script> 
``` 
* So, HelloWorld.vue exports HelloWorld, App.vue imports HelloWorld and exports App, main.js inject App into template index.html
### SPA with many components
* New element App in src/App.vue is exported and injected. 
```
<template>
  <img alt="Vue logo" src="@/assets/logo.png">
  <node123 msg="Section 1"/>
  <node456 msg="Section 2"/>
</template>

<script>
import node123 from '@/components/node1.vue'
import node456 from '@/components/node2.vue'

export default {
  name: 'App',
  components: {
    node123, node456
  }
}
</script>
```
### Multi-Page Application
* Away from single page application (SPA), MPA use a different folder structure, which is specified in vue.config.js 
* Let's create folders
```
vue create vue_mpa
cd vue_mpa 
cat << EOF > src/App.vue
<template>
  <img alt="Vue logo" src="@/assets/logo.png">
  <HelloWorld msg="Welcome to Your Vue.js App"/>
</template>

<script>
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'App',
  components: {
    HelloWorld
  }
}
</script>
EOF

mkdir -p src/pages123/page1 
mv src/App.vue src/main.js src/pages123/page1
cp -r src/pages123/page1 src/pages123/page2
```
* Configure ([doc](https://cli.vuejs.org/config/#pages))
``` 
cat << EOF > vue.config.js 
module.exports = {
  pages: {
    'index123': {  
      entry: 'src/pages123/page1/main.js', 
      template: 'public/index.html',
      filename: 'index.html', // Create dist/index.html 
      title: 'p1', 
    }, 
    'about456': { 
      entry: 'src/pages123/page2/main.js', 
      filename: 'about.html',  
    } 
  }
}
EOF
```
* vue.config.js controls the project
* Folder structure
```
package.json
vue.config.js  
src/
├── assets
│   └── logo.png
├── components
│   └── HelloWorld.vue
└── pages123
    ├── page1
    │   ├── App.vue
    │   └── main.js
    └── page2
        ├── App.vue
        └── main.js
```
### Tips
* Enable debug in production build
```
npm run build -- --mode development
```
