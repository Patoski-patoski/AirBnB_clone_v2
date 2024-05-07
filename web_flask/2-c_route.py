#!/usr/bin/python3
""" 2-c_route module """

from flask import Flask
from markupsafe import escape

app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/')
def index():
    """ index: a function that displays "Hello HBNB!" """
    return "Hello HBNB!"


@app.route('/hbnb')
def hbnb():
    """ hbnb: a function that displays "HBNB" """
    return "HBNB"


@app.route('/c/<text>')
def c_is_fun(text):
    """ c_is_fun: display "C" followed by the value of the text variable"""
    return "C {}".format(escape(text))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
