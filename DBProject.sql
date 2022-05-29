--- users with comments and answers
Create TABLE users(
	id Serial Primary Key,
	name varchar(255),
	surname varchar(255)
)

Create TABLE users_comment(
	user_id int REFERENCES users (id),
	comment_id int Primary Key,
	comment varchar(255)
)

Create TABLE answer(
	comment_id int REFERENCES users_comment (comment_id),
	answer int
)

--- news with comments

Create TABLE news(
	news int,
	comment_id int Primary Key REFERENCES users_comment (comment_id)
)

---- users with suggested news

Create TABLE user_suggest_news(
	id int Primary Key,
	user_id int REFERENCES users (id)
)

Create TABLE accepted_news(
	id int Primary Key REFERENCES user_suggest_news (id),
	accepted bool,
	reason varchar(255)
)


