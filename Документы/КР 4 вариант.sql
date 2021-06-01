-----������� 1---------------------------------------------------------------------------------------------
--1
CREATE TABLE	Table1 (
t1 int, t2 int, t3 int)

insert into Table1(t1, t2, t3) 
values ((Select count(*) from teacher), (select count(*) from student),  (select count(*) from pulpit))

select * from Table1

--2
insert into progress(idstudent, note, subject) 
		(select idstudent, 6, '��' 
		from student join groups on student.idgroup = groups.idgroup
					join profession on groups.profession = profession.profession
		where qualification like ('%��������%'))
		delete  progress where subject='��'
--3
SELECT  * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY >= ALL(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM WHERE AUDITORIUM LIKE '3%') -->= �������� �� ���

--4 ������� ������� � ������ � �� ����������
select student.idgroup, groups.faculty, ROUND(avg	(cast(datediff(year, student.BDAY, getdate()) as float)),2)
from student join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
group by  rollup ( groups.faculty, student.idgroup)

--6 ���������
CREATE VIEW [���������]
AS SELECT AUDITORIUM.AUDITORIUM ���, AUDITORIUM.AUDITORIUM_TYPE [��� ���������]
FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE '��%';
GO
INSERT [���������] 	VALUES('200-3�', '��');
SELECT * FROM [���������]
GO


-----������� 2---------------------------------------------------------------------------------------------
--2 ��� �������� �� ������ ��� ������ ���� 6
select * from progress
select distinct progress.SUBJECT from progress 
except
select distinct progress.SUBJECT from progress where note <6

--���
select subject 
from PROGRESS p1 
where 6 <=all(select p2.note from progress p2 where p1.SUBJECT = p2.SUBJECT)

--3 exists - �������� � ������� ���� ������
select IDSTUDENT
from student 
where exists(select * from progress where student.IDSTUDENT = progress.IDSTUDENT)

--4 ������� ���� ��������
select idstudent, round(avg(cast(note as float)),2) 
from progress
group by idstudent

--5 �� ��������� insert, update, delete:
--��� group by, ���������� �������, distinct, top, union, intersect, except,
--�� ������ ���� ����������� � select-������, � from ���� ���� �������


-----������� 3---------------------------------------------------------------------------------------------
--2 ����� ��� ��������� ������� �������� >1 ������ ��� 0 (�� ���� ��� ����� 1)
select idstudent 
from progress 
group by idstudent having count(note)<>1


select (student.idstudent), count(note)
from student left join progress on student.IDSTUDENT= PROGRESS.IDSTUDENT	 
group by student.idstudent having count(note)<>1

--3 ���������� ��������� � ������ ������
select count(idstudent), idgroup
from student
group by idgroup

--4 Not exists - �������� � ������� ��� ������
select IDSTUDENT
from student 
where not exists(select * from progress where student.IDSTUDENT = progress.IDSTUDENT)


-----������� 4---------------------------------------------------------------------------------------------
---2 �������� ���� 8 � ���� 4 
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

--4 ������� ������ ��������� �� ��������
select avg(cast(note as float))
from progress 
where SUBJECT = '��'

--union ��� ������� ���������� ���������