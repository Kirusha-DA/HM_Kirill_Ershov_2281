Create TABLE hobby(
	id Serial Primary Key,
	name varchar(255) NOT NULL,
	risk int CHECK(risk<=0 and risk>=10)
);

Create TABLE student(
	id Serial Primary Key,
	name varchar(255) NOT NULL,
	surname varchar(255) NOT NULL,
	address varchar(3000),
	n_group int CHECK (n_group>=1000 and n_group<=9999),
	score real CHECK (score>=2 and score<=5)
);

Create TABLE student_hobby(
	student_id integer REFERENCES student (id),
	hobby_id integer REFERENCES hobby (id),
	started_at DATE,
	finished_at DATE
);