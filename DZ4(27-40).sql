--27.Для каждой буквы алфавита из имени найти максимальный, средний и минимальный балл. 
--(Т.е. среди всех студентов, чьё имя начинается на А (Алексей, Алина, Артур, Анджела) найти то, что указано в задании. 
--Вывести на экран тех, максимальный балл которых больше 3.6
SELECT substr(st.name::varchar,1,1), MAX(st.score), AVG(st.score), MIN(st.score)
FROM student st
GROUP BY substr(st.name::varchar,1,1)
HAVING MAX(st.score)>3.6

--28.Для каждой фамилии на курсе вывести максимальный и минимальный средний балл. 
--(Например, в университете учатся 4 Иванова (1-2-3-4). 1-2-3 учатся на 2 курсе и имеют средний балл 4.1, 4, 3.8 соответственно, 
--а 4 Иванов учится на 3 курсе и имеет балл 4.5. На экране должно быть следующее: 2 Иванов 4.1 3.8 3 Иванов 4.5 4.5
SELECT substr(st.n_group::varchar,1,1), st.surname, MIN(st.score), MAX(st.score)
FROM student st
GROUP BY substr(st.n_group::varchar,1,1), st.surname
ORDER BY substr(st.n_group::varchar,1,1) DESC

--29.Для каждого года рождения подсчитать количество хобби, которыми занимаются или занимались студенты.
SELECT st.birthday, COUNT(st_h.hobby_id)
FROM student st
INNER JOIN student_hobby st_h ON st_h.student_id=st.id
GROUP BY st.birthday

--30.Для каждой буквы алфавита в имени найти максимальный и минимальный риск хобби.
SELECT LEFT(st.name,1), MAX(pod.risk), MIN(pod.risk)
FROM student st, (
	SELECT *
	FROM student_hobby st_h
	INNER JOIN hobby h ON h.id = st_h.hobby_id
) pod
WHERE st.id = pod.student_id
GROUP BY LEFT(st.name,1)

--31.Для каждого месяца из даты рождения вывести средний балл студентов, которые занимаются хобби с названием «Футбол»
--to_char(st.birthday, 'Month')
SELECT to_char(pod.birthday, 'Month'), AVG(pod.score)
FROM hobby h, (
	SELECT *
	FROM student st
	INNER JOIN student_hobby st_h ON st.id = st_h.student_id
) pod
WHERE h.id = pod.hobby_id AND h.name='Футбол'
GROUP BY to_char(pod.birthday, 'Month')

--32.Вывести информацию о студентах, которые 
--занимались или занимаются хотя бы 1 хобби в следующем формате: Имя: Иван, фамилия: Иванов, группа: 1234
SELECT st.name, st.surname, st.n_group
FROM student st, (
	SELECT st_h.student_id, COUNT(st_h.hobby_id)
	FROM student_hobby st_h
	GROUP BY st_h.student_id
) pod
WHERE pod.student_id = st.id

--33.Найдите в фамилии в каком по счёту символа встречается «ов». Если 0 (т.е. не встречается, то выведите на экран «не найдено».
SELECT st.surname, 
	CASE
		WHEN POSITION('ов' IN st.surname) = 0 THEN 'не найдено'
		ELSE POSITION('ов' IN st.surname)::varchar
	END
FROM student st
	
--34.Дополните фамилию справа символом # до 10 символов.
SELECT rpad(st.surname,10,'#')
FROM student st
		
--35.При помощи функции удалите все символы # из предыдущего запроса.
SELECT TRIM(TRAILING '#' FROM rpad(st.surname,10,'#'))
FROM student st

--36.Выведите на экран сколько дней в апреле 2018 года.
SELECT '2018-05-01'::TIMESTAMP - '2018-04-01'::TIMESTAMP

--37.Выведите на экран какого числа будет ближайшая суббота.
SELECT NOW()::DATE + (6-EXTRACT(DOW FROM NOW()))::INT

--38.Выведите на экран век, а также какая сейчас неделя года и день года.
SELECT EXTRACT(CENTURY FROM NOW()) vek, EXTRACT(WEEK FROM NOW()) weeks, EXTRACT(DOY FROM NOW()) days

--39.Выведите всех студентов, которые занимались или занимаются хотя бы 1 хобби. 
--Выведите на экран Имя, Фамилию, Названию хобби, а также надпись «занимается», 
--если студент продолжает заниматься хобби в данный момент или «закончил», если уже не занимает.
SELECT pod.name, pod.surname, h.name, pod.hobby_status
FROM hobby h, (
	SELECT st.id, st_h.hobby_id, st.name, st.surname,
		CASE
			WHEN st_h.finished_at IS NULL THEN 'не занимается'
			ELSE 'занимается'
		END hobby_status
	FROM student_hobby st_h
	INNER JOIN student st ON st.id = st_h.student_id
) pod
WHERE h.id = pod.hobby_id

--40.Для каждой группы вывести сколько студентов учится на 5,4,3,2. 
--Использовать обычное математическое округление. Итоговый результат должен выглядеть примерно в таком виде:
SELECT st.n_group, 
	COUNT(st.score) FILTER (WHERE ROUND(st.score) = '2') two,
	COUNT(st.score) FILTER (WHERE ROUND(st.score) = '3') tree,
	COUNT(st.score) FILTER (WHERE ROUND(st.score) = '4') four,
	COUNT(st.score) FILTER (WHERE ROUND(st.score) = '5') five
FROM student st
GROUP BY st.n_group
