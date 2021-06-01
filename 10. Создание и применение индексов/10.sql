use Z_UNIVER

--������� 1. ���������� ��� ������� Z_UNIVER
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

--����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
select * from #temptable where tind between 1500 and 2500 order by tind 

--������� ���������������� ������, ����������� ��������� SELECT-�������.
checkpoint;  --�������� ��
dbcc dropcleanbuffers;  --�������� �������� ���
create clustered index #temptable_cl on #temptable(tind asc)
drop index #temptable_cl  on #temptable


--������� 2. ������������������ ������������ ��������� ������
--������� ��������� ��������� �������. ��������� �� ������� (10000 ����� ��� ������).
create table #temptable2(
	tkey int, 
    cc int identity(1, 1),
    tf varchar(100)
);
go        
declare @i int = 0;
while   @i < 10000   
begin
    insert #temptable2 (tkey, tf) values(floor(30000*rand()), '�');
    set @i = @i + 1; 
end;
go

select * from  #temptable2 where  tkey > 1500 and  cc< 4500;  
select * from  #temptable2 order by  tkey, cc
select * from  #temptable2 where  tkey > 1500 and  cc = 4500;  

--������������������ ������������ ��������� ������
create index #temptable2_nonclu on #temptable2(tkey, cc)
drop index #temptable2_nonclu on #temptable2


--������� 3. ������������������ ������ ��������
--������� ��������� ��������� �������. ��������� �� ������� (�� ����� 10000 �����). 
select cc from #temptable2 where tkey > 15000 
create index #temptable2_tkey_x on #temptable2(tkey) include (cc)
drop index #temptable2_tkey_x on #temptable2


--������� 4. ������������������ ����������� ������
select tkey from #temptable2 where tkey between 5000 and 19999; 
select tkey from #temptable2 where tkey>15000 and  tkey < 20000  
select tkey from #temptable2 where tkey=17000

create index #temptable2_where on #temptable2(tkey) where (tkey>=15000 and tkey < 20000);  
drop index #temptable2_where on #temptable2
 

--������� 5.
--������� ������������������ ������. ������� ������� ������������ �������.
create index #temptable2_nonclu5 on #temptable2(tkey)
drop index #temptable2_nonclu5 on #temptable2

use tempdb;
select name [������], avg_fragmentation_in_percent [������������ (%)]
from sys.dm_db_index_physical_stats(db_id(N'TEMPDB'), 
	 object_id(N'#temptable2'), null, null, null) ss join sys.indexes ii 
	 on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
where name is not null;

insert top(10000) #temptable2(tkey, tf) select tkey, tf from #temptable2

alter index #temptable2_nonclu5 on #temptable2 reorganize; 
alter index #temptable2_nonclu5 on #temptable2 rebuild with (online = off);

--������� 6. ���������� ��������� FILLFACTOR ��� �������� ������������������� �������.
drop index #temptable2_nonclu5 on #temptable2
create index #temptable2_nonclu5 on #temptable2(tkey) with (fillfactor = 60)

select name [������], fill_factor [Fill factor]
from sys.dm_db_index_physical_stats(db_id(N'TEMPDB'), 
	 object_id(N'#temptable2'), null, null, null) ss join sys.indexes ii 
	 on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
where name is not null;

--������� 7. 
--������� ����������� ������� � ���������������� ����� �������� � �������������� ���� �������� ��� ������� ���� ������ Z_MyBASE.
use Z_MyBase

select * from  ��������
select * from  ��������
select * from  ������

exec sp_helpindex '��������' 
exec sp_helpindex '��������' 
exec sp_helpindex '������' 

--������������������ ������ ��������
select ������� from �������� where �����_�������� > 100003 
create index #��������_����_�������� on ��������(�����_��������) include (�������)
drop index #��������_����_�������� on ��������

--������������������ ����������� ������
select ������ from ������ where ������ between 5 and 8; 
select ������ from ������ where ������ > 5 and  ������ < 9  
select ������ from ������ where ������=7

create index #������_����_������ on ������(������) where (������>=5 and ������ < 9);  
drop index #������_����_������ on ������
 