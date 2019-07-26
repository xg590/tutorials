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
@app.route('/'）
def frontpage():
    return render_template("frontend.html")
app.run('127.0.0.1', 5000)

