use Z_UNIVER
-- ������� 4. �������� B
--- �������� B. ����� ���������� � ������� ��������������� READ COMMITED (�� ���������). 
begin transaction
	select @@SPID
	insert subject values ('??', '����� �������', '����');
	update progress set subject  =  '??' where subject = '��' 
	select @@SPID
-------------------------- t1 --------------------
-------------------------- t2 --------------------
rollback;

----������� 5. �������� B
begin transaction
-------------------------- t1 --------------------
	insert subject values ('??', '����� �������', '����');
	update progress set subject  =  '??' where subject = '��' 
commit; --�� ������ �����
-------------------------- t2 --------------------

update progress set subject  =  '��' where subject = '??' 
delete from subject where subject like('??')



rollback;
-- ������� 6. �������� B. 
begin transaction--!!
-------------------------- t1 --------------------
	insert subject values ('??', '����� �������', '����');
commit
	update subject set subject  =  '!!' where subject = '??' 
commit;
-------------------------- t2 --------------------



rollback;
-- ������� 7. �������� B.
set transaction isolation level READ COMMITTED
begin transaction
-------------------------- t1 --------------------
	update progress set Note=2 where IDSTUDENT=1003;
	insert into progress values ('��', 1024, GETDATE(), 7);
	delete from progress where IDSTUDENT = 1025;
	select count(*) from progress where subject = '��';
commit
-------------------------- t2 --------------------
