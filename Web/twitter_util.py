import server
import twitter

def init_api():
	api = twitter.Api(consumer_key = 'y3NiPW3PucLcC7pAiltzA',\
	 				 consumer_secret='SilGe9cQ60VnPhTD3nv0ulHlRdzLCHPOkjrxC0b0ck',\
	 				 access_token_key='1569044905-wg0PRfoWxcIVypFBhaXFGwBQxcxkRl0JzefzyTR',\
	 				 access_token_secret='Th2K3MCaOOBoSGbodcN1Soso8bRmuB0VSks3gLymWo')
	users = api.GetFriends()
	print users
	

if __name__ == "__main__":
	init_api()