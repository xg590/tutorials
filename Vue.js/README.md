### Vue.js and Nodejs

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
  * ccc
