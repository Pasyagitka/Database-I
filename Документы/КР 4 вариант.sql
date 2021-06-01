-----Вариант 1---------------------------------------------------------------------------------------------
--1
CREATE TABLE	Table1 (
t1 int, t2 int, t3 int)

insert into Table1(t1, t2, t3) 
values ((Select count(*) from teacher), (select count(*) from student),  (select count(*) from pulpit))

select * from Table1

--2
insert into progress(idstudent, note, subject) 
		(select idstudent, 6, 'ОХ' 
		from student join groups on student.idgroup = groups.idgroup
					join profession on groups.profession = profession.profession
		where qualification like ('%технолог%'))
		delete  progress where subject='ОХ'
--3
SELECT  * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY >= ALL(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM WHERE AUDITORIUM LIKE '3%') -->= большего из них

--4 средний возраст в группе и по факультету
select student.idgroup, groups.faculty, ROUND(avg	(cast(datediff(year, student.BDAY, getdate()) as float)),2)
from student join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
group by  rollup ( groups.faculty, student.idgroup)

--6 допускает
CREATE VIEW [Аудитории]
AS SELECT AUDITORIUM.AUDITORIUM Код, AUDITORIUM.AUDITORIUM_TYPE [Тип аудитории]
FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE 'ЛК%';
GO
INSERT [Аудитории] 	VALUES('200-3в', 'ЛК');
SELECT * FROM [Аудитории]
GO


-----Вариант 2---------------------------------------------------------------------------------------------
--2 все предметы по которм нет оценок ниже 6
select * from progress
select distinct progress.SUBJECT from progress 
except
select distinct progress.SUBJECT from progress where note <6

--или
select subject 
from PROGRESS p1 
where 6 <=all(select p2.note from progress p2 where p1.SUBJECT = p2.SUBJECT)

--3 exists - студенты у которых есть оценки
select IDSTUDENT
from student 
where exists(select * from progress where student.IDSTUDENT = progress.IDSTUDENT)

--4 средний балл студента
select idstudent, round(avg(cast(note as float)),2) 
from progress
group by idstudent

--5 не допускает insert, update, delete:
--нет group by, агрегатных функций, distinct, top, union, intersect, except,
--не должно быть вычисляемых в select-списке, в from лишь одна таблица


-----Вариант 3---------------------------------------------------------------------------------------------
--2 найти все студентов который получили >1 оценок или 0 (то есть все кроме 1)
select idstudent 
from progress 
group by idstudent having count(note)<>1


select (student.idstudent), count(note)
from student left join progress on student.IDSTUDENT= PROGRESS.IDSTUDENT	 
group by student.idstudent having count(note)<>1

--3 количество студентов в каждой группе
select count(idstudent), idgroup
from student
group by idgroup

--4 Not exists - студенты у которых нет оценок
select IDSTUDENT
from student 
where not exists(select * from progress where student.IDSTUDENT = progress.IDSTUDENT)


-----Вариант 4---------------------------------------------------------------------------------------------
---2 студенты выше 8 и ниже 4 
select distinct p1.idstudent
from
	(select idstudent, note from progress where note < 4) p1
	 inner join
	(select idstudent, note from progress where note > 8) p2
on p1.idstudent = p2.idstudent
	where p1.idstudent !=all(select distinct idstudent from progress  where note between 4 and 8)

--3 any
select  * from auditorium
where auditorium_capacity > any(select auditorium_capacity from auditorium where auditorium like '3%')

--4 средняя оценка студентов по предмету
select avg(cast(note as float))
from progress 
where SUBJECT = 'КГ'

--union два запроса одинаковый результат