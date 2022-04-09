--11.Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.
SELECT pod.n_group
FROM (
	SELECT st.n_group, COUNT(st.score) total_score, COUNT(st.score) FILTER (WHERE st.score>=4) sub_score
	FROM student st 
	GROUP BY st.n_group
	) pod
GROUP BY pod.n_group
HAVING SUM(sub_score)/SUM(total_score) > 0.6

--12.Для каждого курса подсчитать количество различных действующих хобби на курсе.
SELECT substr(st.n_group::varchar,1,1), COUNT(pod.hobby_count_each_student)
FROM student st
INNER JOIN (
	SELECT st_h.student_id, COUNT(st_h.hobby_id) hobby_count_each_student
	FROM student_hobby st_h
	WHERE st_h.finished_at IS NULL
	GROUP BY st_h.student_id
) pod on pod.student_id=st.id
GROUP BY substr(st.n_group::varchar,1,1)

--13.Вывести номер зачётки, фамилию и имя, дату рождения и номер курса 
--для всех отличников, не имеющих хобби. 
--Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.
SELECT st.n_zachet, st.surname, st.name, st.birthday, substr(st.n_group::varchar,1,1) kurs_number
FROM student st, (
	SELECT *
	FROM student_hobby st_h
	WHERE st_h.hobby_id IS NULL
) pod
WHERE st.score>=4.5 AND pod.student_id=st.id

--14.Создать представление, в котором отображается вся информация о студентах, которые продолжают
--заниматься хобби в данный момент и занимаются им как минимум 5 лет.
CREATE OR REPLACE VIEW student_V1 AS
SELECT st.*
FROM student st, (
	SELECT st_h.student_id, age(NOW(), st_h.started_at)
	FROM student_hobby st_h
	WHERE st_h.finished_at IS NULL AND EXTRACT(YEAR FROM age(NOW(), st_h.started_at)) >= 5
) pod
WHERE pod.student_id=st.id

--15.Для каждого хобби вывести количество людей, которые им занимаются.
SELECT st_h.hobby_id, COUNT(st_h.student_id)
FROM student_hobby st_h
GROUP BY hobby_id

--16.Вывести ИД самого популярного хобби.
SELECT st_h.hobby_id
FROM student_hobby st_h
GROUP BY hobby_id
ORDER BY COUNT(st_h.student_id) DESC
LIMIT 1

--17.Вывести всю информацию о студентах, занимающихся самым популярным хобби.
SELECT st.*
FROM student_hobby st_h
INNER JOIN student st ON st.id = st_h.student_id
WHERE st_h.hobby_id = (
	SELECT st_h.hobby_id 
	FROM student_hobby st_h
	GROUP BY hobby_id
	ORDER BY COUNT(st_h.student_id) DESC
	LIMIT 1
)

--18.Вывести ИД 3х хобби с максимальным риском.
SELECT h.id
FROM hobby h
ORDER BY h.risk DESC
LIMIT 3

--19.Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.
SELECT st_h.student_id
FROM student_hobby st_h
ORDER BY age(st_h.finished_at, st_h.started_at) DESC
LIMIT 10

--20.Вывести номера групп (без повторений), в которых учатся студенты из предыдущего запроса.
SELECT DISTINCT st.n_group
FROM student st, (
	SELECT st_h.student_id
	FROM student_hobby st_h
	ORDER BY age(st_h.finished_at, st_h.started_at) DESC
	LIMIT 10
) pod
WHERE st.id = pod.student_id

--21.Создать представление, которое выводит номер зачетки, имя и фамилию студентов, отсортированных по убыванию среднего балла.
CREATE OR REPLACE VIEW student_V2 AS
SELECT st.n_zachet, st.name, st.surname
FROM student st
ORDER BY st.score DESC

