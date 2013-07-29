import sqlite3
import server
g = server.g

def get_user_id(username):
	global g
	query = "SELECT * from users WHERE username = '"+username+"'"
	cur = g.db.execute(query)
	entry = cur.fetchone()
	exists = entry != None

	if not exists:
			return "FAILURE"
	else:
		user_id = entry[0]
		return user_id

def get_cur_money(username):
	global g
	user_id = get_user_id(username)
	print user_id
	if user_id == "FAILURE":
		return "FAILURE"

	query = "SELECT * from currency WHERE user_id = '"+str(user_id)+"'"
	cur = g.db.execute(query).fetchone()
	return str(cur[2])


def add_money(username, ammount):
	global g
	user_id = get_user_id(username)
	print user_id
	if user_id == "FAILURE":
		return "FAILURE"

	query = "SELECT * from currency WHERE user_id = '"+str(user_id)+"'"
	cur_money = int(g.db.execute(query).fetchone()[2])

	cur_money += int(ammount)

	query = "UPDATE currency SET money = '"+str(cur_money)+"' WHERE user_id = '"+str(user_id)+"'"
	print query

	g.db.execute(query)
	g.db.commit()

	return str(cur_money)

def remove_money(username, ammount):
	global g
	user_id = get_user_id(username)
	print user_id
	if user_id == "FAILURE":
		return "FAILURE"

	query = "SELECT * from currency WHERE user_id = '"+str(user_id)+"'"
	cur_money = int(g.db.execute(query).fetchone()[2])

	cur_money -= int(ammount)

	if cur_money < 0:
		return "FAILURE"
	query = "UPDATE currency SET money = '"+str(cur_money)+"' WHERE user_id = '"+str(user_id)+"'"
	print query

	g.db.execute(query)
	g.db.commit()

	return str(cur_money)
	