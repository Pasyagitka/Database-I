use Z_UNIVER

-- Задание 1. Разработать сценарий, демонстрирующий работу в режиме неявной транзакции.

if exists (select * from  SYS.OBJECTS  where OBJECT_ID= object_id('dbo.Z') )	            
	drop table Z;     
	
declare @c int, @flag char = 'c';         
SET IMPLICIT_TRANSACTIONS  ON   

CREATE table Z(ID int);                        
INSERT Z values (1),(2),(3);
set @c = (select count(*) from Z);
print 'количество строк в таблице Z: ' + cast( @c as varchar(2));
if @flag = 'c'  commit  
	else  rollback;                              
SET IMPLICIT_TRANSACTIONS  OFF 
	
if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id('dbo.Z') )
print 'Таблица Z есть';  
    else print 'таблицы Z нет'


-- Задание 2. Разработать сценарий, демонстрирующий свойство атомарности явной транзакции
select * from progress

begin try
	begin tran --Переключение в режим явной транзакци
		update progress set Note=4 where IDSTUDENT=1002;
		insert into progress values ('МП', 1025, GETDATE(), 100);
		insert into progress values ('МП', 1020, GETDATE(), 9);
		delete from progress where IDSTUDENT = 1025;
	commit tran;
end try
begin catch
	print 'Ошибка! ' + case
	when error_number() = 547 then 'Попытка вставить значение < 0 > 10 в столбец оценок'
	else cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount > 0  rollback tran;
end catch

--Задание 3. Разработать сценарий, демонстрирующий применение оператора SAVE TRAN
select * from progress

declare @point varchar(32);
begin try
	begin tran
  		update progress set Note=2 where IDSTUDENT=1002;
		set @point = '1. Обновление: Note=2'; save tran @point;
		insert into progress values ('МП', 1024, GETDATE(), 7);
		set @point = '2. Вставка верного'; save tran @point;
		insert into progress values ('МП', 1024, GETDATE(), 100);
		set @point = '3. Вставка неверного'; save tran @point;
		delete from progress where IDSTUDENT = 1025;
	commit tran;
end try
begin catch
	print 'Ошибка! ' + 
	case
		when error_number() = 547 then 'Попытка вставить значение < 0 > 10 в столбец оценок'
		else cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount>0 
	begin 
		print 'Контрольная точка ' + @point;
		rollback tran @point;
		commit tran;
	end
end catch


-- Задание 4.
-- Сценарий А. Явная транзакция с уровнем изолированности READ UNCOMMITED. 
-- Допускает неподтвержденное, неповторяющееся и фантомное чтение.
select * from subject

set transaction isolation level READ UNCOMMITTED
begin transaction
	select @@SPID, 'insert progress' 'результат', * from subject where subject = '??';
	select @@SPID, 'update subject' 'результат', * from progress where subject = '??';
-------------------------- t1 --------------------
	select @@SPID, 'insert progress' 'результат', * from subject where subject = '??';
	select @@SPID, 'update subject' 'результат', * from progress where subject = '??';
commit;
-------------------------- t2 --------------------
--- Сценарий B. Явная транзакция с уровнем изолированности READ COMMITED (по умолчанию). 
begin transaction
	select @@SPID
	insert subject values ('??', 'Новый предмет', 'ИСиТ');
	update progress set subject  =  '??' where subject = 'МП' 
	select @@SPID
-------------------------- t1 --------------------
-------------------------- t2 --------------------
rollback;

-- Задание 5. Явные транзакции с уровнем изолированности READ COMMITED
-- Сценарий A. Не допускает неподтвержденного, возможно неповторяющееся и фантомное.
set transaction isolation level READ COMMITTED
begin transaction
	select count(*) from subject where subject = '??';
	select count(*) from progress where subject = '??';
-------------------------- t1 --------------------
-------------------------- t2 --------------------
	select 'insert progress' 'результат', count(*) from subject where subject = '??';
	select 'update subject' 'результат', count(*) from progress where subject = '??';
commit;

--- Сценарий B. Явная транзакция с уровнем изолированности READ COMMITED (по умолчанию). 
begin transaction
-------------------------- t1 --------------------
	insert subject values ('??', 'Новый предмет', 'ИСиТ');
	update progress set subject  =  '??' where subject = 'МП' 
commit;
	--update progress set subject  =  'МП' where subject = '??' 
	--delete from subject where subject like('??')
	--delete from subject where subject like('!!')
-------------------------- t2 --------------------


rollback;
select  * from subject
-- Задание 6.
-- Сценарий A. Явная транзакция с уровнем изолированности REPEATABLE READ
-- Не допускает неподтвержденного чтения и неповторяющееся, возможно фантомное чтение
set transaction isolation level REPEATABLE READ
begin transaction
	select count(*) from subject where subject = '??';
-------------------------- t1 --------------------
	select 'subject' 'результат', count(*) from subject where subject = '??';
	select 'subject' 'результат', count(*) from subject where subject = '!!';
-------------------------- t2 --------------------
commit;

--- Сценарий B. Явная транзакция с уровнем изолированности READ COMMITED. 
begin transaction
-------------------------- t1 --------------------
	insert subject values ('??', 'Новый предмет', 'ИСиТ');
commit
	update subject set subject  =  '!!' where subject = '??' 
commit;
-------------------------- t2 --------------------

-- Задание 7
select * from progress

-- Сценарий A. SERIALIZABLE
set transaction isolation level SERIALIZABLE
begin transaction
	select count(*) from progress where subject = 'КГ';
-------------------------- t1 --------------------
-------------------------- t2 --------------------
	select count(*) from progress where subject = 'КГ';
commit;


--rollback


-- Задание 8. Вложенные транзакции
select * from SUBJECT
select * from PROGRESS
delete from SUBJECT where SUBJECT like('**')

begin transaction
	insert into SUBJECT values ('**', 'Новый новый предмет','ИСиТ');
	begin transaction
		update PROGRESS set SUBJECT='**' where subject like('ОАиП')
		commit
		print @@trancount
		if (@@trancount > 0) rollback;
rollback

-- Задание 9. Z_MyBase
use Z_MyBase;

begin try
	begin tran --Переключение в режим явной транзакци
		update ОЦЕНКИ set Оценка=10 where Студент_номер=100002;
		insert into ОЦЕНКИ(Студент_номер, Экзаменационный_предмет, Оценка) 
		values (100002, 'БД', -2)
	commit tran;
end try
begin catch
	print 'Ошибка! ' + case
	when error_number() = 547 then 'Попытка вставить > 10 в столбец оценок'
	when error_number() = 220 then 'Попытка вставить значение < 0 в столбец оценок'
	else cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount > 0  rollback tran;
end catch


delete from  ПРЕДМЕТЫ where Предмет like('Предмет')
select * from ПРЕДМЕТЫ
select * from ОЦЕНКИ
begin transaction
	insert into ПРЕДМЕТЫ(Предмет) values ('Предмет');
	begin transaction
		update ОЦЕНКИ set Экзаменационный_предмет='Предмет' where Экзаменационный_предмет like('Математика')
		commit
		print @@trancount
		if (@@trancount > 0) rollback;



-- Задание 10. Предложить уровень изолированности транзакций для некоторого интернет-магазина. Объяснить решение.

