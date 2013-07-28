import server
import sqlite3
import re
import qrcode
import random
import math
import time
g = server.g

def redeem_reward_code(username, code):
	value = get_point_value(code)
	print "REDEEMING CODE FOR "+str(value)+" POINTS"

	from money_utils import add_money

	return add_money(username, value)


def get_point_value(code):
	if not is_valid_code(code):
		return "Bad Code"
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
	fours = [x for x in range(45,123) if x % 4 == 0]

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
		return False
	else:
		values = (str(lat), str(lon), code)
		query = "INSERT INTO mapped_rewards(lat, long, code) VALUES"\
		 + str(values)

		g.db.execute(query)
		g.db.commit()

		return True


def get_all_rewards():
	global g
	query = "SELECT * FROM mapped_rewards"
	print query
	con = g.db.execute(query)
	print "executed"
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

