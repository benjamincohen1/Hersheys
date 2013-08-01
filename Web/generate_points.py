import server
import random


def make():
	from rewards_util import generate_code, drop_code_at_point,\
							 get_point_value
	for x in range(50):
		lat = random.randint(75, 130) * -1
		lon = random.randint(20, 80)
		denoms = [10, 25, 50, 100]
		code = generate_code(random.sample(denoms, 1)[0])

		drop_code_at_point(lon, lat, get_point_value(code))

	return "DONE"

def make_in_city(city):
	from rewards_util import generate_code, drop_code_at_point,\
							 get_point_value

	if city == "NY":
		for x in range(50):

			lon = random.uniform(40.7,40.9)
			lat = random.uniform(-73.9,-74.1)
			denoms = [10, 25, 50, 100]
			code = generate_code(random.sample(denoms, 1)[0])

			drop_code_at_point(lon, lat, get_point_value(code))
	elif city == "SF":
		for x in range(50):
			lon = random.uniform(37.6,37.8)
			lat = random.uniform(-122.4,-122.5)
			denoms = [10, 25, 50, 100]
			code = generate_code(random.sample(denoms, 1)[0])

			drop_code_at_point(lon, lat, get_point_value(code))
	return "DONE"