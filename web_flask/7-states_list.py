#!/usr/bin/python3
""" 7-states_list.py """

from flask import Flask, render_template
from models import storage
from models.state import State


app = Flask(__name__)


@app.teardown_appcontext
def teardown(exception):
    """ teardown: to remove current sqlalchemy Session """
    storage.close()



@app.route("/states_list", strict_slashes=False)
def states_list():
    """A method to render an HTML page with a list of all State objects
    """
    # test start
    storage.reload()
    # ends
    states = storage.all(State).values()
    states = sorted(states, key=lambda state: state.name)
    return render_template("7-states_list.html", states=states)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
