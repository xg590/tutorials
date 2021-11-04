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
