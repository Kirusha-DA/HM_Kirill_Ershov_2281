--10.Аналогично 9 заданию, но вывести в одном запросе для каждой группы студента с максимальным баллом.

SELECT st.n_group, st.name, st.score
FROM student st 
WHERE st.score in
    (
	SELECT max(st_pod.score)
	FROM student st_pod
	GROUP BY st_pod.n_group
	)
ORDER BY st.n_group DESC