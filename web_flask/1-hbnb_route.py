#!/usr/bin/python3
""" 1-hbnb_route module """

from flask import Flask

app = Flask(__name__)
app.url_map.strict_slashes = False

@app.route('/')
def index():
    """index: a function that displays  "Hello HBNB!" """
    return "Hello HBNB!"

@app.route('/hbnb')
def display():
    """display: a function that displays  "HBNB" """
    return "HBNB"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
