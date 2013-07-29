drop table if exists users;
create table users (
  id integer primary key autoincrement,
  username text not null,
  password text not null
);

INSERT INTO users( username, password ) VALUES
   ("admin", "5f4dcc3b5aa765d61d8327deb882cf99" );
INSERT INTO users( username, password ) VALUES
   ("ben", "5f4dcc3b5aa765d61d8327deb882cf99" );
drop table if exists currency;
create table currency(
	id integer primary key autoincrement,
	user_id integer not null,
	money integer not null
);
INSERT INTO currency( user_id, money ) VALUES
   ("1", "50" );
INSERT INTO currency( user_id, money ) VALUES
   ("2", "50" );
drop table if exists mapped_rewards;
create table mapped_rewards(
	id integer primary key autoincrement,
	lat REAL not null,
	long REAL not null,
	code VARCHAR not null
);

INSERT INTO mapped_rewards(lat, long, code) VALUES
	("40.753641", "-73.986652", "55TfiT\");

INSERT INTO mapped_rewards(lat, long, code) VALUES
	("42.753641", "-79.986652", "qC9]<p<");

INSERT INTO mapped_rewards(lat, long, code) VALUES
	("40.753541", "-73.986452", "IqZNa@D");


drop table if exists tweets;
create table tweets(
	id integer primary key autoincrement,
	user_id integer not null,
	tweet_date VARCHAR not null,
	tweets integer not null default 0
);

drop table if exists facebook;
create table facebook(
	id integer primary key autoincrement,
	user_id integer not null,
	tweet_date VARCHAR not null,
	facebook integer not null default 0
);

drop table if exists redeemed;
create table redeemed(
	id integer primary key autoincrement,
	user_id integer not null,
	code VARCHAR not null,
	redeem_date VARCHAR not null
);

drop table if exists rewards;
create table rewards(
	id integer primary key autoincrement,
	name VARCHAR not null,
	points_required INT not null
);

INSERT INTO rewards(name, points_required) VALUES
	("Free chocolate bar", 25);
INSERT INTO rewards(name, points_required) VALUES
	("Free jumbo chocolate bar", 250);
INSERT INTO rewards(name, points_required) VALUES
	("New Owner", 500);