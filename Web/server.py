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


@app.route('/users/authenticate', methods = ['POST', 'GET'])
def authenticate():
	from user_utils import authenticate

	username = request.form['Username']
	password = hashlib.md5(request.form['Password']).hexdigest()
	return authenticate(username, password)


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
		return "ACCOUNT CREATED"
	else:
		print "FAILURE"
		return "ACCOUNT NOT CREATED"


@app.route('/users/money', methods = ['POST', 'GET'])
def get_money():
	# get paid
	print "GETTING USER'S MONEY"
	from money_utils import get_cur_money
	username = request.form['Username']
	cur_money = get_cur_money(username)
	return cur_money


@app.route('/codes/redeem', methods = ['POST', 'GET'])
def redeem_code():
	from rewards_util import redeem_reward_code
	username = request.form['Username']
	code = request.form['Code']

	status = redeem_reward_code(username, code)

	return str(status)


@app.route('/redeem/view_options', methods = ['POST', 'GET'])
def get_possible_rewards():
	username = request.form['Username']

	from rewards_util import get_possible_rewards

	possibles = get_possible_rewards(username)
	return str(possibles)+"\n"


@app.route('/map')
def map():
	from rewards_util import get_all_rewards

	rewards = get_all_rewards()

	codes = [str(x[2]) for x in rewards]

	return render_template("map.html", **{'codes': rewards})

@app.route('/map/collect', methods = ['POST', 'GET'])
def collect_rewards_near_user():
	print "HERE"
	username = request.form['Username']

	lat = request.form['lat']
	lon = request.form['lon']
	print lat, lon
	from rewards_util import collect_rewards_near_user as collect

	codes = collect(username, lat, lon)

	return str(codes)+"\n"


@app.route('/rewards/add_point', methods = ['POST', 'GET'])
def add_point():
	from rewards_util import drop_code_at_point
	lat = request.form['lat']
	lon = request.form['lon']
	points = request.form['points']
	return str(drop_code_at_point(lat, lon, points))


@app.route('/money/remove', methods = ['POST', 'GET'])
def remove_money():
	# get paid
	print "REMOVING USER'S MONEY"
	from money_utils import remove_money
	username = request.form['Username']
	ammount = request.form["Ammount"]
	cur_money = remove_money(username, ammount)

	return cur_money


@app.route('/twitter/sent', methods = ['POST', 'GET'])
def tweet_sent():
	from rewards_util import facebook_sent
	username = request.form['Username']

	points = facebook_sent(username)
	print points
	return points


@app.route('/facebook/sent', methods = ['POST', 'GET'])
def facebook_sent():
	from rewards_util import facebook_sent
	username = request.form['Username']

	points = facebook_sent(username)
	print points
	return points



@app.route('/money/add', methods = ['POST', 'GET'])
def add_money():
	# get paid
	print "ADDING TO USER'S MONEY"
	from money_utils import add_money
	username = request.form['Username']
	ammount = request.form["Ammount"]

	cur_money = add_money(username, ammount)

	return cur_money

@app.route('/make_points')
def make_points():
	from generate_points import make

	make()

	return "Dummy Points Sucessfully Added"


if __name__ == '__main__':

	app.run(host='0.0.0.0')
