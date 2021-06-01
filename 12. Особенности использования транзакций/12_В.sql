use Z_UNIVER
-- Задание 4. Сценарий B
--- Сценарий B. Явная транзакция с уровнем изолированности READ COMMITED (по умолчанию). 
begin transaction
	select @@SPID
	insert subject values ('??', 'Новый предмет', 'ИСиТ');
	update progress set subject  =  '??' where subject = 'МП' 
	select @@SPID
-------------------------- t1 --------------------
-------------------------- t2 --------------------
rollback;

----Задание 5. Сценарий B
begin transaction
-------------------------- t1 --------------------
	insert subject values ('??', 'Новый предмет', 'ИСиТ');
	update progress set subject  =  '??' where subject = 'МП' 
commit; --не делать сразу
-------------------------- t2 --------------------

update progress set subject  =  'МП' where subject = '??' 
delete from subject where subject like('??')



rollback;
-- Задание 6. Сценарий B. 
begin transaction--!!
-------------------------- t1 --------------------
	insert subject values ('??', 'Новый предмет', 'ИСиТ');
commit
	update subject set subject  =  '!!' where subject = '??' 
commit;
-------------------------- t2 --------------------



rollback;
-- Задание 7. Сценарий B.
set transaction isolation level READ COMMITTED
begin transaction
-------------------------- t1 --------------------
	update progress set Note=2 where IDSTUDENT=1003;
	insert into progress values ('КГ', 1024, GETDATE(), 7);
	delete from progress where IDSTUDENT = 1025;
	select count(*) from progress where subject = 'КГ';
commit
-------------------------- t2 --------------------
