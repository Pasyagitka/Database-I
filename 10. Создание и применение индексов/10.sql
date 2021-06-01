use Z_UNIVER

--Задание 1. Определить все индексы Z_UNIVER
exec sp_helpindex 'AUDITORIUM' 
exec sp_helpindex 'AUDITORIUM_TYPE'
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'GROUPS'
exec sp_helpindex 'PROFESSION'
exec sp_helpindex 'PROGRESS'
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'STUDENT'
exec sp_helpindex 'SUBJECT'
exec sp_helpindex 'TEACHER'
exec sp_helpindex 'TIMETABLE'

create table #temptable(
	tind int, 
	tfield varchar(30)
);
go  
declare @i int = 0;
while @i < 1000
	begin
		insert into #temptable(tind, tfield)
		values(floor(20000 * rand()), 'a');
		set @i = @i + 1; 
	end;
GO

--Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
select * from #temptable where tind between 1500 and 2500 order by tind 

--Создать кластеризованный индекс, уменьшающий стоимость SELECT-запроса.
checkpoint;  --фиксация бд
dbcc dropcleanbuffers;  --очистить буферный кэш
create clustered index #temptable_cl on #temptable(tind asc)
drop index #temptable_cl  on #temptable


--Задание 2. Некластеризованный неуникальный составной индекс
--Создать временную локальную таблицу. Заполнить ее данными (10000 строк или больше).
create table #temptable2(
	tkey int, 
    cc int identity(1, 1),
    tf varchar(100)
);
go        
declare @i int = 0;
while   @i < 10000   
begin
    insert #temptable2 (tkey, tf) values(floor(30000*rand()), 'б');
    set @i = @i + 1; 
end;
go

select * from  #temptable2 where  tkey > 1500 and  cc< 4500;  
select * from  #temptable2 order by  tkey, cc
select * from  #temptable2 where  tkey > 1500 and  cc = 4500;  

--некластеризованный неуникальный составной индекс
create index #temptable2_nonclu on #temptable2(tkey, cc)
drop index #temptable2_nonclu on #temptable2


--Задание 3. Некластеризованный индекс покрытия
--Создать временную локальную таблицу. Заполнить ее данными (не менее 10000 строк). 
select cc from #temptable2 where tkey > 15000 
create index #temptable2_tkey_x on #temptable2(tkey) include (cc)
drop index #temptable2_tkey_x on #temptable2


--Задание 4. Некластеризованный фильтруемый индекс
select tkey from #temptable2 where tkey between 5000 and 19999; 
select tkey from #temptable2 where tkey>15000 and  tkey < 20000  
select tkey from #temptable2 where tkey=17000

create index #temptable2_where on #temptable2(tkey) where (tkey>=15000 and tkey < 20000);  
drop index #temptable2_where on #temptable2
 

--Задание 5.
--Создать некластеризованный индекс. Оценить уровень фрагментации индекса.
create index #temptable2_nonclu5 on #temptable2(tkey)
drop index #temptable2_nonclu5 on #temptable2

use tempdb;
select name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id(N'TEMPDB'), 
	 object_id(N'#temptable2'), null, null, null) ss join sys.indexes ii 
	 on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
where name is not null;

insert top(10000) #temptable2(tkey, tf) select tkey, tf from #temptable2

alter index #temptable2_nonclu5 on #temptable2 reorganize; 
alter index #temptable2_nonclu5 on #temptable2 rebuild with (online = off);

--Задание 6. Применение параметра FILLFACTOR при создании некластеризованного индекса.
drop index #temptable2_nonclu5 on #temptable2
create index #temptable2_nonclu5 on #temptable2(tkey) with (fillfactor = 60)

select name [Индекс], fill_factor [Fill factor]
from sys.dm_db_index_physical_stats(db_id(N'TEMPDB'), 
	 object_id(N'#temptable2'), null, null, null) ss join sys.indexes ii 
	 on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
where name is not null;

--Задание 7. 
--Создать необходимые индексы и проанализировать планы запросов с использованием этих индексов для таблицы базы данных Z_MyBASE.
use Z_MyBase

select * from  СТУДЕНТЫ
select * from  ПРЕДМЕТЫ
select * from  ОЦЕНКИ

exec sp_helpindex 'СТУДЕНТЫ' 
exec sp_helpindex 'ПРЕДМЕТЫ' 
exec sp_helpindex 'ОЦЕНКИ' 

--Некластеризованный индекс покрытия
select Телефон from СТУДЕНТЫ where Номер_Студента > 100003 
create index #Студенты_некл_покрытия on СТУДЕНТЫ(Номер_Студента) include (Телефон)
drop index #Студенты_некл_покрытия on СТУДЕНТЫ

--Некластеризованный фильтруемый индекс
select Оценка from ОЦЕНКИ where Оценка between 5 and 8; 
select Оценка from ОЦЕНКИ where Оценка > 5 and  Оценка < 9  
select Оценка from ОЦЕНКИ where Оценка=7

create index #ОЦЕНКИ_некл_фильтр on ОЦЕНКИ(Оценка) where (Оценка>=5 and Оценка < 9);  
drop index #ОЦЕНКИ_некл_фильтр on ОЦЕНКИ
 