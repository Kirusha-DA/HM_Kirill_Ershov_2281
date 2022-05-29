Create TABLE users(
	id Serial Primary Key,
	name varchar(255),
	surname varchar(255)
)

Create TABLE comment(
	id Serial Primary Key,
	users_id int REFERENCES users (id),
	comment varchar(255)
)

Create TABLE news(
	id int, 
	comment int Primary Key REFERENCES comment (id)
)

Create TABLE answer(
	comment_id int REFERENCES comment (id),
	answer varchar(255)
)
------

Create TABLE user_suggested_news(
	user_id int REFERENCES users (id),
	suggested_news_id int Primary Key REFERENCES suggested_news (id)
)

Create TABLE suggested_news(
	id int Primary Key,
	accepted_or_not bool,
	reason varchar(255)
)
