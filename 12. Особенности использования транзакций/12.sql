use Z_UNIVER

-- ������� 1. ����������� ��������, ��������������� ������ � ������ ������� ����������.

if exists (select * from  SYS.OBJECTS  where OBJECT_ID= object_id('dbo.Z') )	            
	drop table Z;     
	
declare @c int, @flag char = 'c';         
SET IMPLICIT_TRANSACTIONS  ON   

CREATE table Z(ID int);                        
INSERT Z values (1),(2),(3);
set @c = (select count(*) from Z);
print '���������� ����� � ������� Z: ' + cast( @c as varchar(2));
if @flag = 'c'  commit  
	else  rollback;                              
SET IMPLICIT_TRANSACTIONS  OFF 
	
if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id('dbo.Z') )
print '������� Z ����';  
    else print '������� Z ���'


-- ������� 2. ����������� ��������, ��������������� �������� ����������� ����� ����������
select * from progress

begin try
	begin tran --������������ � ����� ����� ���������
		update progress set Note=4 where IDSTUDENT=1002;
		insert into progress values ('��', 1025, GETDATE(), 100);
		insert into progress values ('��', 1020, GETDATE(), 9);
		delete from progress where IDSTUDENT = 1025;
	commit tran;
end try
begin catch
	print '������! ' + case
	when error_number() = 547 then '������� �������� �������� < 0 > 10 � ������� ������'
	else cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount > 0  rollback tran;
end catch

--������� 3. ����������� ��������, ��������������� ���������� ��������� SAVE TRAN
select * from progress

declare @point varchar(32);
begin try
	begin tran
  		update progress set Note=2 where IDSTUDENT=1002;
		set @point = '1. ����������: Note=2'; save tran @point;
		insert into progress values ('��', 1024, GETDATE(), 7);
		set @point = '2. ������� �������'; save tran @point;
		insert into progress values ('��', 1024, GETDATE(), 100);
		set @point = '3. ������� ���������'; save tran @point;
		delete from progress where IDSTUDENT = 1025;
	commit tran;
end try
begin catch
	print '������! ' + 
	case
		when error_number() = 547 then '������� �������� �������� < 0 > 10 � ������� ������'
		else cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount>0 
	begin 
		print '����������� ����� ' + @point;
		rollback tran @point;
		commit tran;
	end
end catch


-- ������� 4.
-- �������� �. ����� ���������� � ������� ��������������� READ UNCOMMITED. 
-- ��������� ����������������, ��������������� � ��������� ������.
select * from subject

set transaction isolation level READ UNCOMMITTED
begin transaction
	select @@SPID, 'insert progress' '���������', * from subject where subject = '??';
	select @@SPID, 'update subject' '���������', * from progress where subject = '??';
-------------------------- t1 --------------------
	select @@SPID, 'insert progress' '���������', * from subject where subject = '??';
	select @@SPID, 'update subject' '���������', * from progress where subject = '??';
commit;
-------------------------- t2 --------------------
--- �������� B. ����� ���������� � ������� ��������������� READ COMMITED (�� ���������). 
begin transaction
	select @@SPID
	insert subject values ('??', '����� �������', '����');
	update progress set subject  =  '??' where subject = '��' 
	select @@SPID
-------------------------- t1 --------------------
-------------------------- t2 --------------------
rollback;

-- ������� 5. ����� ���������� � ������� ��������������� READ COMMITED
-- �������� A. �� ��������� �����������������, �������� ��������������� � ���������.
set transaction isolation level READ COMMITTED
begin transaction
	select count(*) from subject where subject = '??';
	select count(*) from progress where subject = '??';
-------------------------- t1 --------------------
-------------------------- t2 --------------------
	select 'insert progress' '���������', count(*) from subject where subject = '??';
	select 'update subject' '���������', count(*) from progress where subject = '??';
commit;

--- �������� B. ����� ���������� � ������� ��������������� READ COMMITED (�� ���������). 
begin transaction
-------------------------- t1 --------------------
	insert subject values ('??', '����� �������', '����');
	update progress set subject  =  '??' where subject = '��' 
commit;
	--update progress set subject  =  '��' where subject = '??' 
	--delete from subject where subject like('??')
	--delete from subject where subject like('!!')
-------------------------- t2 --------------------


rollback;
select  * from subject
-- ������� 6.
-- �������� A. ����� ���������� � ������� ��������������� REPEATABLE READ
-- �� ��������� ����������������� ������ � ���������������, �������� ��������� ������
set transaction isolation level REPEATABLE READ
begin transaction
	select count(*) from subject where subject = '??';
-------------------------- t1 --------------------
	select 'subject' '���������', count(*) from subject where subject = '??';
	select 'subject' '���������', count(*) from subject where subject = '!!';
-------------------------- t2 --------------------
commit;

--- �������� B. ����� ���������� � ������� ��������������� READ COMMITED. 
begin transaction
-------------------------- t1 --------------------
	insert subject values ('??', '����� �������', '����');
commit
	update subject set subject  =  '!!' where subject = '??' 
commit;
-------------------------- t2 --------------------

-- ������� 7
select * from progress

-- �������� A. SERIALIZABLE
set transaction isolation level SERIALIZABLE
begin transaction
	select count(*) from progress where subject = '��';
-------------------------- t1 --------------------
-------------------------- t2 --------------------
	select count(*) from progress where subject = '��';
commit;


--rollback


-- ������� 8. ��������� ����������
select * from SUBJECT
select * from PROGRESS
delete from SUBJECT where SUBJECT like('**')

begin transaction
	insert into SUBJECT values ('**', '����� ����� �������','����');
	begin transaction
		update PROGRESS set SUBJECT='**' where subject like('����')
		commit
		print @@trancount
		if (@@trancount > 0) rollback;
rollback

-- ������� 9. Z_MyBase
use Z_MyBase;

begin try
	begin tran --������������ � ����� ����� ���������
		update ������ set ������=10 where �������_�����=100002;
		insert into ������(�������_�����, ���������������_�������, ������) 
		values (100002, '��', -2)
	commit tran;
end try
begin catch
	print '������! ' + case
	when error_number() = 547 then '������� �������� > 10 � ������� ������'
	when error_number() = 220 then '������� �������� �������� < 0 � ������� ������'
	else cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount > 0  rollback tran;
end catch


delete from  �������� where ������� like('�������')
select * from ��������
select * from ������
begin transaction
	insert into ��������(�������) values ('�������');
	begin transaction
		update ������ set ���������������_�������='�������' where ���������������_������� like('����������')
		commit
		print @@trancount
		if (@@trancount > 0) rollback;



-- ������� 10. ���������� ������� ��������������� ���������� ��� ���������� ��������-��������. ��������� �������.

