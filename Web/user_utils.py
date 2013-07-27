import sqlite3
import server



def new_account(username, password):
	g = server.g
	values = (str(username), str(password))
	query = "SELECT * FROM users WHERE username = '"+username+"'"
	print query
	cur = g.db.execute(query)
	exists = cur.fetchone() != None

	if exists:
		return False
	else:

		query = "INSERT INTO users (username, password)\
			 	VALUES "+str(values)
		print query
		g.db.execute(query)
		g.db.commit()
		query = "SELECT * FROM users WHERE username = '"+username+"'"
		cur = g.db.execute(query).fetchone()
		user_id = cur[0]
		values = (user_id, 50)
		query = "INSERT INTO currency (user_id, money)\
			 	VALUES "+str(values)
		g.db.execute(query)
		g.db.commit()

		return True