drop table if exists users;
create table users (
  id integer primary key autoincrement,
  username text not null,
  password text not null
);

INSERT INTO users( username, password ) VALUES
   ("admin", "5f4dcc3b5aa765d61d8327deb882cf99" );

drop table if exists currency;
create table currency(
	id integer primary key autoincrement,
	user_id integer not null,
	money integer not null
);