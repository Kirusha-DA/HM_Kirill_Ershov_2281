--8.Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл

SELECT st.name, pod.id
FROM student st, (
	SELECT st.name, st_h.hobby_id 
	FROM student st
	INNER JOIN student_hobby st_h ON st.id=st_h.student_id
) pod
WHERE st.score = (SELECT MAX(student.score) FROM student) AND st.name=pod.name

--9.Найти все действующие хобби, которыми увлекаются троечники 2-го курса.
SELECT st_h.hobby_id
FROM student_hobby st_h, (
	SELECT st.id, st.score
	FROM student st
	WHERE (st.score<3.5 AND st.score>=2.5) AND substr(st.n_group::varchar,1,1)='2'
) pod
WHERE pod.id=st_h.student_id AND st_h.finished_at IS NULL

--10.Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.
SELECT substr(st.n_group::varchar,1,1) as n_kursa
FROM student st, (
	SELECT st_h.student_id, COUNT(st_h.hobby_id)
	FROM student_hobby st_h
	GROUP BY st_h.student_id
	HAVING COUNT(st_h.hobby_id)>1
) pod
GROUP BY st.id
HAVING COUNT(pod.student_id)/COUNT(st.id)>0.5
