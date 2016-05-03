/* Database for managing photos at home */

create table if not exists MediaType (
	id integer PRIMARY KEY,
	name TEXT
);
insert into MediaType values(1, 'Photo');
insert into MediaType values(2, 'Video');

create table if not exists MediaFile (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	path TEXT NOT NULL,
	md5_hash INTEGER NOT NULL,
	root_location INTEGER NOT NULL REFERENCES MountPoint(id),
	name TEXT,
	date_taken TEXT,
	media_type INTEGER NOT NULL REFERENCES MediaType(id)
);

create table if not exists MountPoint (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	path TEXT NOT NULL
);

create table if not exists Country (
	country_code TEXT PRIMARY KEY,
	country TEXT
);

create table if not exists City (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	country TEXT NOT NULL REFERENCES Country(country_code),
	city TEXT NOT NULL
);

create table if not exists Location (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	description TEXT NOT NULL,
	city INTEGER REFERENCES City(id)
);

create table if not exists MediaLocation (
	media INTEGER NOT NULL REFERENCES MediaFile(id),
	Location INTEGER NOT NULL REFERENCES Location(id)
);

create table if not exists Actor (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	birth_date TEXT
);

create table if not exists MediaActor (
	actor INTEGER NOT NULL REFERENCES Actor(id),
	media INTEGER NOT NULL REFERENCES MediaFile(id)
);

create table if not exists Tag (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	description TEXT NOT NULL
);

create table if not exists MediaTag (
	tag INTEGER NOT NULL REFERENCES Tag(id),
	media INTEGER NOT NULL REFERENCES MediaFile(id)
);