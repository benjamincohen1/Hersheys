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