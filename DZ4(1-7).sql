--1.Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.

SELECT st.name, st.surname, pod.name
FROM student st,
	(
	SELECT *
	FROM student_hobby st_h
	INNER JOIN hobby h on st_h.hobby_id=h.id
	) pod
WHERE st.id = pod.student_id

--2.Вывести информацию о студенте, занимающимся хобби самое продолжительное время.

SELECT st.id, st.name, st.surname, st.address, st.n_group, st.score, st.birthday
FROM student st, (
	SELECT st_h.student_id , st_h.finished_at - st_h.started_at as time_difference
	FROM student_hobby st_h
	WHERE st_h.finished_at - st_h.started_at IS NOT NULL
	ORDER BY time_difference DESC
	LIMIT 1
	) pod
WHERE st.id=pod.student_id

--3.Вывести имя, фамилию, номер зачетки и дату рождения для студентов, 
--средний балл которых выше среднего, 
--а сумма риска всех хобби, которыми он занимается в данный момент, больше 9.


SELECT pod2.id, pod2.name, pod2.surname, pod2.n_zachet, pod2.birthday
FROM (
	SELECT st.id ,st.name, st.surname, st.n_zachet, st.birthday
	FROM student st
	WHERE st.score > (
	SELECT AVG(st.score)
	FROM student st
	)
) pod2
INNER JOIN (
	SELECT pod1.student_id, SUM(pod1.risk)
	FROM(
		SELECT st_h.student_id, h.name, h.risk
		FROM student_hobby st_h
		INNER JOIN hobby h on st_h.hobby_id=h.id
	) pod1
	GROUP BY pod1.student_id
	HAVING SUM(pod1.risk)>9
) pod1 on pod1.student_id=pod2.id

--4.Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби.

SELECT st.name, st.surname, st.n_zachet, st.birthday, pod.name, pod.months
FROM student st, (
	SELECT st_h.student_id, h.name, 12 * extract(year from age(st_h.finished_at, st_h.started_at)) as months
	FROM hobby h
	INNER JOIN student_hobby st_h on h.id=st_h.hobby_id
	WHERE st_h.finished_at IS NOT NULL
) pod
WHERE st.id=pod.student_id


--5.Вывести фамилию, имя, зачетку, дату рождения студентов, которым исполнилось N полных лет на текущую дату, и которые имеют более 1 действующего хобби.

SELECT st.surname, st.name, st.n_zachet, st.birthday
FROM student st, (
	SELECT st_h.student_id, COUNT(st_h.hobby_id)
	FROM student_hobby st_h
	GROUP BY st_h.student_id 
	HAVING COUNT(st_h.hobby_id) > 1
) pod
WHERE st.id=pod.student_id AND st.birthday < '1982-01-01'


--6.Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби.

SELECT st.n_group, AVG(st.score)
FROM student st
INNER JOIN(
	SELECT st_h.student_id, COUNT(st_h.hobby_id)
	FROM student_hobby st_h
	GROUP BY st_h.student_id 
	HAVING COUNT(st_h.hobby_id) >= 1
) pod on pod.student_id=st.id
GROUP BY n_group 

--7.Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, указав номер зачетки студента.

SELECT h.name, h.risk, pod.months, pod.n_zachet 
FROM hobby h
INNER JOIN (
	SELECT pod.hobby_id , st.id, st.n_zachet, pod.months
	FROM student st, (
		SELECT st_h.hobby_id ,st_h.student_id, 12 * extract(year from age('2021-01-01', st_h.started_at)) as months
		FROM student_hobby st_h
		WHERE st_h.finished_at IS NULL
		ORDER BY months DESC
		LIMIT 1
	) pod
	WHERE st.id=pod.student_id
) pod on pod.hobby_id = h.id
	
