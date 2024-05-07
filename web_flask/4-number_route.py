#!/usr/bin/python3
""" 4-number_route """

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


def replace(strings):
    """ replace: replace strings containing underscore(_) with space (" ")
    Args:
         (str): Strings to be replaced
    Return:
         New and replaced string!
    """
    new_str = ""
    for s in strings:
        if s == '_':
            s = ' '
        new_str += (s)
    return new_str


@app.route('/c/<text>')
def c_is_fun(text):
    """ c_is_fun: display "C" followed by the value of the text variable """
    replaced_text = escape(text)
    return "C {}".format(replace(replaced_text))


@app.route('/python/', defaults={'text': 'is cool'})
@app.route('/python/<text>')
def run_python(text):
    """ python: display "Python", followed by the value of text variable """
    replaced_text = escape(text)
    return "Python {}".format(replace(replaced_text))


@app.route('/number/<int:n>')
def number(n):
    """  display "n is a number" only if n is an integer """
    return "{} is a number".format(escape(n))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
