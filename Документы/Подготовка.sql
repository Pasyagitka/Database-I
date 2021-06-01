--1
create table table1 (
	t1 int, 
	t2 int
)
insert into table1 (t1, t2) 
values  (13, 435), 
		(12, 11), 
		(1, 11), 
		(45, 99)

select * from table1

create table table2 (
	t21 int identity, 
	t22 date, 
	t23 int
)

insert into table2(t22, t23)
	(select getdate(), avg(cast(t1 as float)) from table1)

select * from table2

--2 - ���� 8 � ���� 4 ������������ � 9 � 3 ��������
select distinct p1.idstudent 
from
	(select idstudent, note from progress where note < 4) p1
	join
	(select idstudent, note from progress where note > 8) p2
on p1.IDSTUDENT = p2.IDSTUDENT

select * from progress where idstudent in(1015,1016) order by idstudent

--3 any � ����������� � ������ where
select *
from auditorium
where auditorium_capacity >= any(select AUDITORIUM_CAPACITY from AUDITORIUM where AUDITORIUM_TYPE like ('��-�')) --50, 60

--4. ������� ������ ��������� �� �������
select subject [�������], avg(cast(note as float)) [������� ������]
from progress
group by subject

--5. � ������� ��������� UNION ���������...
--����������
select avg(cast(note as float)) [������� ������]
from PROGRESS where SUBJECT like ('��')
union
select avg(cast(note as float)) [������� ������]
from PROGRESS where SUBJECT like ('��')

--�� ����������
select avg(cast(note as float)) [������� ������]
from PROGRESS where SUBJECT like ('��')
union
select avg(cast(note as float)) [������� ������]
from PROGRESS where SUBJECT like ('��')

--6. �� ����������� INSERT, UPDATE, DELETE
create view [IUD] 
as
select AUDITORIUM_TYPE [���]
from AUDITORIUM 
group by AUDITORIUM_TYPE

select * from IUD

insert into IUD values ('��')
update IUD set ���='��' where ���='��'
delete IUD where ���='��'