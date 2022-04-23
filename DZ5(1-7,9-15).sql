--1.Удалите всех студентов с неуказанной датой рождения
DELETE 
FROM student
WHERE birthday IS NULL

--2.Измените дату рождения всех студентов, с неуказанной датой рождения на 01-01-1999
UPDATE student
SET birthday = '1999-01-01'
WHERE birthday IS NULL
RETURNING *

--3.Удалите из таблицы студента с номером зачётки 21
DELETE 
FROM student 
WHERE n_zachet = 21

--4.Уменьшите риск хобби, которым занимается наибольшее количество человек
UPDATE hobby 
SET risk = 8
WHERE id = (
	SELECT pod.*
	FROM hobby h, (
		SELECT st_h.hobby_id
		FROM student_hobby st_h
		GROUP BY hobby_id
		ORDER BY COUNT(st_h.student_id) DESC
		LIMIT 1
	) pod
	WHERE pod.hobby_id = h.id
)

--5.Добавьте всем студентам, которые занимаются хотя бы одним хобби 0.01 балл
UPDATE student
SET score = score + 0.01
WHERE id in (
	SELECT st_h.student_id
	FROM student_hobby st_h
	WHERE hobby_id IS NOT NULL
)

--6.Удалите все завершенные хобби студентов
DELETE
FROM student_hobby
WHERE finished_at IS NOT NULL

--7.Добавьте студенту с id 4 хобби с id 5. date_start - '15-11-2009, date_finish - null
UPDATE student_hobby
SET started_at = '2009-11-15', finished_at = NULL
WHERE student_id = 4 AND hobby_id = 5

--9.Поменяйте название хобби всем студентам, кто занимается футболом - на бальные танцы, а кто баскетболом - на вышивание крестиком.
UPDATE student_hobby 
SET hobby_id = CASE
	WHEN hobby_id = 11 THEN 16
	WHEN hobby_id = 12 THEN 17
	ELSE hobby_id
	END 

--10.Добавьте в таблицу хобби новое хобби с названием "Учёба"
INSERT INTO hobby (id, name, risk)
VALUES(18, 'Учеба', 10)

--11.У всех студентов, средний балл которых меньше 3.2 поменяйте во всех хобби 
--(если занимается чем-либо) и добавьте (если ничем не занимается), что студент занимается хобби из 10 задания
BEGIN;
UPDATE student_hobby
SET hobby_id = 18
WHEN student_id IN (
	SELECT st.id
	FROM student st, student_hobby st_h
	WHERE st.score < 3.2 AND st_h.hobby_id IS NULL AND st_h.student_id = st.id
)
RETURNING *;
ROLLBACK;

--12.Переведите всех студентов не 4 курса на курс выше
UPDATE student 
SET n_group = CAST(CONCAT('5', RIGHT(n_group::varchar, 3)) AS integer)
WHERE n_group::varchar LIKE '4%'

--13.Удалите из таблицы студента с номером зачётки 2
DELETE 
FROM student 
WHERE n_zachet = 2

--14.Измените средний балл у всех студентов, которые занимаются хобби более 10 лет на 5.00
UPDATE student
SET score = 5.00
WHERE id IN (
	SELECT student_id
	FROM student_hobby
	WHERE extract(years from age(finished_at, started_at)) > 10
)

--15.Удалите информацию о хобби, если студент начал им заниматься раньше, чем родился
DELETE
FROM student_hobby st_h
WHERE st_h.student_id IN (
	SELECT st.id
	FROM student st
	INNER JOIN student_hobby st_h ON st_h.student_id = st.id
	WHERE birthday > started_at
)
