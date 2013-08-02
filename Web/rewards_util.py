import server
import sqlite3
import re
import qrcode
import random
import math
import time
g = server.g

def redeem_reward_code(username, code):
	if not is_valid_code(code):
		print "REDEEMING CODE FOR NO POINTS"

		return 0
	value = get_point_value(code)
	code = str(code)
	print "REDEEMING CODE FOR "+str(value)+" POINTS"

	from money_utils import add_money, get_user_id
	from dateutil import parser
	import datetime

	user_id = get_user_id(str(username))

	print user_id
	if user_id == "FAILURE":
		return "FAILURE"
	query = "SELECT * FROM redeemed WHERE user_id = '"+str(user_id)+"' AND code = '"+str(code)+"'"

	print query

	cur = g.db.execute(query)
	row = cur.fetchone()

	if row == None:
		values = (user_id, code, str(datetime.datetime.now()))
		print values
		query = "INSERT INTO redeemed(user_id, code, redeem_date) VALUES"\
		 		 + str(values)

		print query

		g.db.execute(query)
		g.db.commit()

		return add_money(username, value)
	else:
		date = parser.parse(row[3])
		cur_time = datetime.datetime.now()

		delta = cur_time - date
		print delta
		if delta < datetime.timedelta(days = 7):
			return "FAILURE"
		else:
			query = "UPDATE redeemed SET  redeem_date = '"+str(cur_time)+"'\
					 WHERE user_id = '"+str(user_id)+"' AND code = '"+str(code)+"'"
			g.db.execute(query)
			g.db.commit()
			return add_money(username, value)

def closest(lat, lon):
	import collections
	rewards = get_all_rewards()
	lat, lon = float(lat), float(lon)
	disances = {}
	for r in rewards:
		disances[haversine_distance((lat, lon), (float(r[0]), float(r[1])))] = r
	od = collections.OrderedDict(sorted(disances.items()))
	c = 0
	z = []
	for x in od:
		if c == 5:
			return z
		else:
			z.append(od[x])
			c+=1
	return z

def get_possible_rewards(username):
	from money_utils import get_cur_money

	money = get_cur_money(username)

	print money

	query = "SELECT * FROM rewards WHERE points_required <= '"+str(money)+"'"
	print query

	cur = g.db.execute(query)
	total = [x[1] for x in cur.fetchall()]

	return total

def collect_rewards_near_user(username, lat, lon):
	from money_utils import get_user_id
	user_id = get_user_id(username)
	print "UID IS: "+str(user_id)
	if user_id is None:
		return "FAILURE"

	#get points 
	query = "SELECT * FROM mapped_rewards"

	cur = g.db.execute(query)
	codes = []

	all_rewards = cur.fetchall()
	loc = (float(lon), float(lat))
	for reward in all_rewards:
		new_loc = (float(reward[1]), float(reward[2]))
		dist = haversine_distance(loc, new_loc)
		print dist
		if dist < .1:
			print "GOT ONE"
			codes.append(reward[3])

	total = 0
	print codes
	print [get_point_value(x) for x in codes]
	for code in codes:
		redeem_reward_code(username, code)
		total += get_point_value(code)

		query = "DELETE FROM mapped_rewards where code = '"+str(code)+"'"
		g.db.execute(query)
		g.db.commit()
	return total


def get_point_value(code):
	if not is_valid_code(code):
		return 0
	else:
		values = [10, 25, 50, 100]
		one = [76, 64, 62, 86, 92, 99, 72, 112, 113, 80, 82, 79, 111, 85, 101, 87, 121]
		two = [103, 98, 68, 49, 122, 95, 119, 120, 46, 78, 70, 108, 118, 67, 73, 55, 48]
		three = [116, 54, 88, 69, 84, 66, 83, 104, 53, 59, 100, 117, 61, 81, 74, 52, 56]
		four = [45, 47, 50, 51, 57, 58, 60, 63, 65, 71, 75, 77, 89, 90, 91, 93, 94, 96, 97, 102, 105, 106, 107, 109, 110, 114, 115]
		lists = [one, two, three, four]
		identifier = code[4]
		for index, x in enumerate(lists):
			if ord(identifier) in x:
				return values[index]


def generate_code(value):
	denominations = [10, 25, 50, 100]
	
	one = [76, 64, 62, 86, 92, 99, 72, 112, 113, 80, 82, 79, 111, 85, 101, 87, 121]
	two = [103, 98, 68, 49, 122, 95, 119, 120, 46, 78, 70, 108, 118, 67, 73, 55, 48]
	three = [116, 54, 88, 69, 84, 66, 83, 104, 53, 59, 100, 117, 61, 81, 74, 52, 56]
	four = [45, 47, 50, 51, 57, 58, 60, 63, 65, 71, 75, 77, 89, 90, 91, 93, 94, 96, 97, 102, 105, 106, 107, 109, 110, 114, 115]

	lists = [one, two, three, four]
	primes = [x for x in range(45,123) if prime(x)]
	threes = [x for x in range(45,123) if x % 3 == 0]
	fours = [x for x in range(45,123) if x % 4 == 0 and x != 90]

	if value not in denominations:
		return "False"
	else:
		code = []
		# insert first val char here
		for x in range(2):
			code.append(random.sample(primes,1)[0])
		for x in range(2):
			code.append(random.sample(threes,1)[0])
		code.append(random.sample(lists[denominations.index(value)], 1)[0])
		for x in range(2):
			code.append(random.sample(fours,1)[0])

	for x in code:
		if x == 92:
			x = 90
	codeStr = ""
	for x in code:
		codeStr += chr(x)

	return codeStr

def tweet_sent(username):
	from money_utils import add_money, get_user_id
	import datetime, re
	global g
	from dateutil import parser
	u_id = get_user_id(str(username))

	print u_id
	if u_id == "FAILURE":
		return "FAILURE"
	query = "SELECT * FROM tweets WHERE user_id = '"+str(u_id)+"'"
	print query

	cur = g.db.execute(query)
	row = cur.fetchone()
	if row == None:
		add_money(username, 25)
		t = datetime.datetime.now()
		values = (u_id, str(t), 1)

		print values
		query = "INSERT INTO tweets(user_id, tweet_date, tweets) VALUES"\
		 + str(values)

		g.db.execute(query)
		g.db.commit()

		return "25"
	else:
		tweets = row[3]
		t = datetime.datetime.now()

		d = row[2]
		d = parser.parse(d)
		cur_time = datetime.datetime.now()

		delta = cur_time - d

		if delta < datetime.timedelta(hours=1):
			points_added = 0
		elif delta < datetime.timedelta(hours=6):
			points_added = 5
		elif delta < datetime.timedelta(hours=24):
			points_added = 10
		elif delta < datetime.timedelta(hours=72):
			points_added = 15
		else:
			points_added = 25


		print points_added

		add_money(username, points_added)
		tweets += 1
		query = "UPDATE tweets SET tweet_date = '"+str(cur_time)+"', tweets = '"+str(tweets)+"'\
				 WHERE user_id = '"+str(u_id)+"'"
		print query
		g.db.execute(query)
		g.db.commit()
		return str(tweets)


def facebook_sent(username):
	from money_utils import add_money, get_user_id
	import datetime, re
	global g
	from dateutil import parser
	u_id = get_user_id(str(username))

	print u_id
	if u_id == "FAILURE":
		return "FAILURE"
	query = "SELECT * FROM facebook WHERE user_id = '"+str(u_id)+"'"
	print query

	cur = g.db.execute(query)
	row = cur.fetchone()
	if row == None:
		add_money(username, 25)
		t = datetime.datetime.now()
		values = (u_id, str(t), 1)

		print values
		query = "INSERT INTO facebook(user_id, tweet_date, facebook) VALUES"\
		 + str(values)

		g.db.execute(query)
		g.db.commit()

		return "25"
	else:
		facebook = row[3]
		t = datetime.datetime.now()

		d = row[2]
		d = parser.parse(d)
		cur_time = datetime.datetime.now()

		delta = cur_time - d

		if delta < datetime.timedelta(hours=1):
			points_added = 0
		elif delta < datetime.timedelta(hours=6):
			points_added = 5
		elif delta < datetime.timedelta(hours=24):
			points_added = 10
		elif delta < datetime.timedelta(hours=72):
			points_added = 15
		else:
			points_added = 25


		print points_added

		add_money(username, points_added)
		facebook += 1
		query = "UPDATE facebook SET tweet_date = '"+str(cur_time)+"', facebook = '"+str(facebook)+"'\
				 WHERE user_id = '"+str(u_id)+"'"
		print query
		g.db.execute(query)
		g.db.commit()
		return str(points_added)


def is_valid_code(code):
	"49 - 57, 65 - 90, 97 - 122"
	if len(code) != 7:
		return False
	codeArray = [ord(x) for x in code]
	primes = codeArray[:2]
	for x in primes:
		if not prime(x):
			return False

	threes = codeArray[2:4]
	for x in threes:
		if x % 3 != 0:
			return False
	fours = codeArray[5:]
	for x in fours:
		if x % 4 != 0:
			return False

	return True


def prime(x):
	for n in range(2,x):
		if x % n == 0:
			return False
	return True


def drop_code_at_point(lat, lon, points):
	code = generate_code(int(points))
	if code == "Bad Code":
		return str(False)
	else:
		values = (str(lat), str(lon), code)
		query = "INSERT INTO mapped_rewards(lat, long, code) VALUES"\
		 + str(values)

		g.db.execute(query)
		g.db.commit()

		return str(True)


def get_all_rewards():
	global g
	query = "SELECT * FROM mapped_rewards"
	print query
	con = g.db.execute(query)

	entries = con.fetchall()

	r = []
	for entry in entries:
		r.append([entry[1], entry[2], str(entry[3])])

	return r


def haversine_distance(a1, a2):
    R = 6371  # earth radius, approx (km)

    a1 = (math.radians(a1[0]), math.radians(a1[1]))
    a2 = (math.radians(a2[0]), math.radians(a2[1]))

    a = math.sin(abs(a1[0] - a2[0]) / 2)**2
    a += math.cos(a1[0]) * math.cos(a2[0]) * \
        math.sin(abs(a1[1] - a2[1]) / 2)**2

    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    d = R * c
    return d


if __name__ == "__main__":
	get_all_rewards()

