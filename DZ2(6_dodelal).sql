--6.Вывести id хобби и id студента которые начали заниматься хобби между двумя
--заданными датами (выбрать самим) и студенты должны до сих пор заниматься хобби
SELECT sh.student_id, sh.hobby_id
FROM student_hobby sh
WHERE (started_at BETWEEN '2002-12-12' AND '2003-12-12') AND (finished_at IS NULL)