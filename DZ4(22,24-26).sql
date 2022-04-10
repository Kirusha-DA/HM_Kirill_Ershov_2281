--22.Представление: найти каждое популярное хобби на каждом курсе.
CREATE OR REPLACE VIEW kours_most_popular AS
SELECT DISTINCT ON (1) substr(st.n_group::varchar,1,1), COUNT(st_h.hobby_id) hobby_count, st_h.hobby_id
FROM student st
INNER JOIN student_hobby st_h ON st_h.student_id=st.id
GROUP BY substr(st.n_group::varchar,1,1), st_h.hobby_id
ORDER BY substr(st.n_group::varchar,1,1) DESC, hobby_count DESC


--24.Представление: для каждого курса подсчитать количество студентов на курсе и количество отличников.
CREATE OR REPLACE VIEW student_and_5 AS
SELECT substr(st.n_group::varchar,1,1), COUNT(st.id), COUNT(st.id) FILTER (WHERE st.score >= 4.5) count_score_5
FROM student st
GROUP BY substr(st.n_group::varchar,1,1)

--25.Представление: самое популярное хобби среди всех студентов.
CREATE OR REPLACE VIEW most_popular_hobby AS
SELECT st_h.hobby_id
FROM student_hobby st_h
GROUP BY hobby_id
ORDER BY COUNT(st_h.student_id) DESC
LIMIT 1

--26.Создать обновляемое представление.
CREATE OR REPLACE VIEW updatable_table AS
SELECT st.*
FROM student st