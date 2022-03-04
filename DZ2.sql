--1.Вывести всеми возможными способами имена и фамилии студентов, средний балл которых от 4 до 4.5
SELECT st.name, st.surname, st.score
FROM student st
WHERE score>=4 AND score<=4.5

SELECT st.name, st.surname, st.score
FROM student st
WHERE score BETWEEN 4 AND 4.5

--2.Познакомиться с функцией CAST. Вывести при помощи неё студентов заданного курса (использовать Like)
SELECT st.name, st.surname, st.n_group
FROM student st
WHERE CAST (st.n_group AS varchar) LIKE '4%'

--3.Вывести всех студентов, отсортировать по убыванию номера группы и имени от а до я
SELECT st.name, st.surname, st.n_group
FROM student st
ORDER BY st.n_group DESC, st.name ASC

--4.Вывести студентов, средний балл которых больше 4 и отсортировать по баллу от большего к меньшему

SELECT st.name, st.surname, st.score
FROM student st
WHERE st.score>=4
ORDER BY st.score DESC

--5.Вывести на экран название и риск футбола и хоккея

SELECT h.name, h.risk
FROM hobby h
WHERE name='Футбол' OR name='Хоккей'

--7.Вывести студентов, средний балл которых больше 4.5 и отсортировать по баллу от большего к меньшему

SELECT st.name, st.surname, st.score
FROM student st
WHERE score>=4.5
ORDER BY st.score DESC

--8.Из запроса №7 вывести несколькими способами на экран только 5 студентов с максимальным баллом

SELECT st.name, st.surname, st.score
FROM student st
WHERE score>=4.5
ORDER BY st.score DESC
LIMIT 5

--9.Выведите хобби и с использованием условного оператора сделайте риск словами:
-- >=8 - очень высокий
-- >=6 & <8 - высокий
-- >=4 & <8 - средний
-- >=2 & <4 - низкий
-- <2 - очень низкий

SELECT h.name,
	CASE
	 WHEN risk >= 8 THEN 'очень высокий'
	 WHEN risk >= 6 AND risk <8 THEN 'высокий'
	 WHEN risk >= 4 AND risk <6 THEN 'средний'
	 WHEN risk >= 2 AND risk <4 THEN 'низкий'
	 WHEN risk < 2 THEN 'очень низкий'
	END
FROM hobby h


--10.Вывести 3 хобби с максимальным риском

SELECT h.name, h.risk
FROM hobby h
ORDER BY h.risk DESC
LIMIT 3
