# all the imports
import sqlite3, hashlib, os
from flask import Flask, request, session, g, redirect, url_for, \
     abort, render_template, flash


from contextlib import closing

# configuration
DATABASE = os.getcwd()+'/tmp/flaskr.db'
DEBUG = True
SECRET_KEY = 'development key'
USERNAME = 'admin'
PASSWORD = 'default'

app = Flask(__name__)
app.config.from_object(__name__)

app.config.from_envvar('FLASKR_SETTINGS', silent=True)


def connect_db():
    return sqlite3.connect(app.config['DATABASE'])


def init_db():
    with closing(connect_db()) as db:
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()

@app.before_request
def before_request():
    g.db = connect_db()

@app.teardown_request
def teardown_request(exception):
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()

"""REAL CODE STARTS BELOW THIS"""

@app.route('/')
def show_entries():
   return "TEST"

@app.route('/users/new', methods = ['POST', 'GET'])
def add_user():
	print "ADDING USER"
	print request
	print request.form
	username = request.form['Username']
	password = hashlib.md5(request.form['Password']).hexdigest()

	from user_utils import new_account

	success = new_account(username, password)
	if success:
		print "SUCCESS"
		return "SUCCESS"
	else:
		print "FAILURE"
		return "FAILURE"

@app.route('/users/money', methods = ['POST', 'GET'])
def get_money():
	# get paid
	print "GETTING USER'S MONEY"
	from money_utils import get_cur_money
	username = request.form['Username']
	print username
	cur_money = get_cur_money(username)
	return cur_money


@app.route('/money/remove', methods = ['POST', 'GET'])
def remove_money():
	# get paid
	print "REMOVING USER'S MONEY"
	from money_utils import remove_money
	username = request.form['Username']
	ammount = request.form["Ammount"]
	cur_money = remove_money(username, ammount)

	return cur_money

@app.route('/money/add', methods = ['POST', 'GET'])
def add_money():
	# get paid
	print "ADDING TO USER'S MONEY"
	from money_utils import add_money
	username = request.form['Username']
	ammount = request.form["Ammount"]

	cur_money = add_money(username, ammount)

	return cur_money


if __name__ == '__main__':
    app.run(host='0.0.0.0')