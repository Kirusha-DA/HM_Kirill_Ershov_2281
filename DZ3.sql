--1.Выведите на экран номера групп и количество студентов, обучающихся в них

SELECT st.n_group, count(*)
FROM student st
GROUP BY st.n_group

--2.Выведите на экран для каждой группы максимальный средний балл

SELECT st.n_group, max(score), avg(score)::real
FROM student st
GROUP BY st.n_group

--3.Подсчитать количество студентов с каждой фамилией

SELECT st.surname, count(surname)
FROM student st
GROUP BY st.surname

--4.Подсчитать студентов, которые родились в каждом году

SELECT st.birthday, count(*)
FROM student st
GROUP BY st.birthday

--5.Для студентов каждого курса подсчитать средний балл см. Substr

SELECT substr(st.n_group::varchar,1,1) as n_group, avg(score)::real
FROM student st
GROUP BY st.n_group
--6.Для студентов заданного курса вывести один номер группы с максимальным средним баллом

SELECT st.n_group, avg(st.score)
FROM student st 
WHERE substr(st.n_group::varchar,1,1)='4'
GROUP BY st.n_group 
ORDER BY avg(st.score) DESC
LIMIT 1

--7.Для каждой группы подсчитать средний балл, вывести на экран только те
--номера групп и их средний балл, в которых он менее или равен 3.5. 
--Отсортировать по от меньшего среднего балла к большему.

SELECT st.n_group, avg(st.score)
FROM student st 
GROUP BY st.n_group 
HAVING avg(st.score)<=3.5
ORDER BY avg(st.score) ASC

--8.Для каждой группы в одном запросе вывести количество студентов, максимальный балл в группе,
--средний балл в группе, минимальный балл в группе

SELECT st.n_group, count(*), max(score), avg(score), min(score)
FROM student st 
GROUP BY st.n_group 

--9.Вывести студента/ов, который/ые имеют наибольший балл в заданной группе

SELECT st.name, max(st.score)
FROM student st 
WHERE st.n_group=4032
GROUP BY st.n_group, st.name
ORDER BY max(st.score) DESC
LIMIT 1