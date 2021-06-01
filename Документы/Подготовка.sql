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

--2 - выше 8 и ниже 4 одновременно и 9 и 3 например
select distinct p1.idstudent 
from
	(select idstudent, note from progress where note < 4) p1
	join
	(select idstudent, note from progress where note > 8) p2
on p1.IDSTUDENT = p2.IDSTUDENT

select * from progress where idstudent in(1015,1016) order by idstudent

--3 any с подзапросов в секции where
select *
from auditorium
where auditorium_capacity >= any(select AUDITORIUM_CAPACITY from AUDITORIUM where AUDITORIUM_TYPE like ('ЛК-К')) --50, 60

--4. Средняя оценка студентов по премету
select subject [Предмет], avg(cast(note as float)) [Средняя оценка]
from progress
group by subject

--5. С помощью оператора UNION проверить...
--одинаковый
select avg(cast(note as float)) [Средняя оценка]
from PROGRESS where SUBJECT like ('ЭТ')
union
select avg(cast(note as float)) [Средняя оценка]
from PROGRESS where SUBJECT like ('ПЗ')

--не одинаковый
select avg(cast(note as float)) [Средняя оценка]
from PROGRESS where SUBJECT like ('ПЗ')
union
select avg(cast(note as float)) [Средняя оценка]
from PROGRESS where SUBJECT like ('КГ')

--6. Не допускающее INSERT, UPDATE, DELETE
create view [IUD] 
as
select AUDITORIUM_TYPE [Тип]
from AUDITORIUM 
group by AUDITORIUM_TYPE

select * from IUD

insert into IUD values ('ЛР')
update IUD set Тип='ЛР' where Тип='ЛК'
delete IUD where Тип='ЛК'