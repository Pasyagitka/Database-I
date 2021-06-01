use Z_UNIVER
go

-- Задание 1.
-- Таблица предназначена для добавления в нее строк триггерами. 
-- В столбец STMT триггер должен поместить событие, на которое он среагировал, а в столбец TRNAME - собственное имя. 
create table TR_AUDIT (
	ID int identity,
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
	TRNAME varchar(50),
	CC varchar(300) --комментарий
)
go

-- Разработать AFTER-триггер с именем TR_TEACHER_INS для таблицы TEACHER, реагирующий на событие INSERT. 
-- Триггер должен записывать строки вводимых данных в таблицу TR_AUDIT. В столбец СС помещаются значения столбцов вводимой строки. 
create trigger TR_TEACHER_INS on TEACHER after INSERT
	as 
	declare @teach varchar(15), @teachname varchar(50), @gen char(1), @pul varchar(15), @in varchar(300);
	print 'Операция вставки';
	set @teach = (select TEACHER from inserted);
	set @teachname = (select TEACHER_NAME from inserted);
	set @gen = (select GENDER from inserted);
	set @pul = (select PULPIT from inserted);
	set @in = rtrim(@teach) + ' ' + rtrim(@teachname) + ' ' + @gen + ' ' + rtrim(@pul);
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @in);
	return;
go

insert into teacher values ('ААА', 'Ааа Ааа Ааа', 'м', 'ИСиТ')
select * from TR_AUDIT
go

-- Задание 2.
-- Создать AFTER-триггер с именем TR_TEACHER_DEL для таблицы TEACHER, реагирующий на событие DELETE. 
-- Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой удаляемой строки. 
-- В столбец СС помещаются значения столбца TEACHER удаляемой строки. 
create trigger TR_TEACHER_DEL on TEACHER after DELETE
	as 
	declare @teach varchar(15), @teachname varchar(50), @gen char(1), @pul varchar(15), @in varchar(300);
	print 'Операция удаления';
	set @teach = (select TEACHER from deleted)
	set @teachname = (select TEACHER_NAME from deleted)
	set @gen = (select GENDER from deleted)
	set @pul = (select PULPIT from deleted)
	set @in = rtrim(@teach) + ' ' + rtrim(@teachname) + ' ' + @gen + ' ' + rtrim(@pul)
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @in)
	return
go

delete teacher where TEACHER = 'ААА';
select * from TR_AUDIT;
go

-- Задание 3.
-- Создать AFTER-триггер с именем TR_TEACHER_UPD для таблицы TEACHER, реагирующий на событие UPDATE. 
-- Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой изменяемой строки.
-- В столбец СС помещаются значения столбцов изменяемой строки до и после изменения.
create trigger TR_TEACHER_UPD on TEACHER after UPDATE
	as 
	declare @teach varchar(15), @teachname varchar(50), @gen char(1), @pul varchar(15), @in varchar(300);
	print 'Операция изменения'
	set @teach = (select TEACHER from inserted)
	set @teachname = (select TEACHER_NAME from inserted)
	set @gen = (select GENDER from inserted)
	set @pul = (select PULPIT from inserted)
	set @in = rtrim(@teach) + ' ' + rtrim(@teachname) + ' ' + @gen + ' ' + rtrim(@pul)

	set @teach = (select TEACHER from deleted)
	set @teachname = (select TEACHER_NAME from deleted)
	set @gen = (select GENDER from deleted)
	set @pul = (select PULPIT from deleted)
	set @in = rtrim(@teach) + ' ' + rtrim(@teachname) + ' ' + @gen + ' ' + rtrim(@pul) + ' -> ' + @in
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @in)
	return
go

update TEACHER set TEACHER_NAME = 'А к н в ч' where TEACHER = 'АКНВЧ';
select * from TR_AUDIT;
go

-- Задание 4.
-- Создать AFTER-триггер с именем TR_TEACHER для таблицы TEACHER, реагирующий на события INSERT, DELETE, UPDATE. 
-- Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой изменяемой строки.
-- В коде триггера определить событие, активизировавшее триггер и поместить в столбец СС соответствующую событию информацию. 
create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE
	as
	declare @teach varchar(15), @teachname varchar(50), @gen char(1), @pul varchar(15), @in varchar(300);
	declare @ins int = (select count(*) from inserted), 
			@del int = (select count(*) from deleted);
	if @ins > 0 and @del = 0
		begin
			print 'Операция добавления';
			set @teach = (select TEACHER from inserted);
			set @teachname = (select TEACHER_NAME from inserted);
			set @gen = (select GENDER from inserted);
			set @pul = (select PULPIT from inserted);
			set @in = rtrim(@teach) + ' ' + rtrim(@teachname) + ' ' + @gen + ' ' + rtrim(@pul);
			insert into TR_AUDIT(STMT, TRNAME, CC) values ('INS', 'TR_TEACHER', @in);
			return;
		end;
	else
	if @ins = 0 and @del > 0
		begin
			print 'Операция удаления';
			set @teach = (select TEACHER from deleted);
			set @teachname = (select TEACHER_NAME from deleted);
			set @gen = (select GENDER from deleted);
			set @pul = (select PULPIT from deleted);
			set @in = rtrim(@teach) + ' ' + rtrim(@teachname) + ' ' + @gen + ' ' + rtrim(@pul);
			insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER', @in);
			return;
		end;
	else 
	if @ins > 0 and  @del > 0 
	begin
		print 'Операция изменения';
		set @teach = (select TEACHER from inserted);
		set @teachname = (select TEACHER_NAME from inserted);
		set @gen = (select GENDER from inserted);
		set @pul = (select PULPIT from inserted);
		set @in = rtrim(@teach) + ' ' + rtrim(@teachname) + ' ' + @gen + ' ' + rtrim(@pul);

		set @teach = (select TEACHER from deleted);
		set @teachname = (select TEACHER_NAME from deleted);
		set @gen = (select GENDER from deleted);
		set @pul = (select PULPIT from deleted);
		set @in = rtrim(@teach) + ' ' + rtrim(@teachname) + ' ' + @gen + ' ' + rtrim(@pul) + ' -> ' + @in;
		insert into TR_AUDIT(STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER', @in);
	end
	return
go

insert into TEACHER values ('БББ', 'Ббб Ббб Ббб', 'м', 'ИСиТ');
update TEACHER set TEACHER_NAME = 'АКНВЧ' where TEACHER = 'БББ';
delete TEACHER where TEACHER = 'БББ';
select * from TR_AUDIT;
go


-- Задание 5.
-- Разработать сценарий, который демонстрирует на примере базы данных Z_UNIVER, что проверка 
-- ограничения целостности выполняется до срабатывания AFTER-триггера.
update TEACHER set GENDER = 'а' where TEACHER = 'АКНВЧ';
select * from TR_AUDIT;
go

-- Задание 6.
-- Создать для таблицы TEACHER три AFTER-триггера с именами: TR_TEACHER_ DEL1, TR_TEACHER_DEL2 и TR_TEACHER_ DEL3. 
-- Триггеры должны реагировать на событие DELETE и формировать соответствующие строки в таблицу TR_AUDIT.  
create trigger TR_TEACHER_DEL1 on TEACHER after DELETE  
       as 
	   insert into TR_AUDIT(STMT, TRNAME) values ('DEL', ' TR_TEACHER_DEL1');
	return;  
go 
create trigger TR_TEACHER_DEL2 on TEACHER after DELETE  
       as 
	   insert into TR_AUDIT(STMT, TRNAME) values ('DEL', ' TR_TEACHER_DEL2');
	return;  
go 
create trigger TR_TEACHER_DEL3 on TEACHER after DELETE  
       as 
	   insert into TR_AUDIT(STMT, TRNAME) values ('DEL', ' TR_TEACHER_DEL3');
	return;  
go 

-- Примечание: использовать системные представления SYS.TRIGGERS и SYS.TRIGGERS_ EVENTS, 
-- а также системную процедуру SP_SETTRIGGERORDERS. 

-- Получить список триггеров
select t.name, e.type_desc 
from sys.triggers t join sys.trigger_events e  
	on t.object_id = e.object_id  
		where OBJECT_NAME(t.parent_id) = 'TEACHER';
go

-- Упорядочить выполнение триггеров для таблицы TEACHER, реагирующих на событие DELETE следующим образом: первым должен выполняться триггер с именем TR_TEACHER_DEL3, последним – триггер TR_TEACHER_DEL2. 
exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL3',
	@order = 'First', @stmttype = 'DELETE';

exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL2',
	@order = 'Last', @stmttype = 'DELETE';

insert into TEACHER values ('БББ', 'Ббб Ббб Ббб', 'м', 'ИСиТ');
delete TEACHER where TEACHER = 'БББ';
select * from TR_AUDIT;
go

-- Задание 7.
-- Разработать сценарий, демонстрирующий на примере базы данных Z_UNIVER утверждение: 
-- AFTER-триггер является частью транзакции, в рамках которого выполняется оператор, 
-- активизировавший триггер.
create trigger TR_AUDITORIUM on AUDITORIUM after INSERT, UPDATE
	as 
	declare @c int = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM);
	if (@c > 500)
		begin
			raiserror('Общая вместимость аудиторий не может быть больше 500', 10, 1);
			rollback;
		end;
	return;
go

--Если попробовать обновить информацию с помощью оператора insert/update, то это вызовет сообщение об ошибке и транзакция завершится аварийно:
insert AUDITORIUM values ('500-1', 'ЛБ-К', 500, '500-1');
select * from AUDITORIUM;
go
select * from TR_AUDIT;
go

-- Задание 8.
-- Для таблицы FACULTY создать INSTEAD OF-триггер, запрещающий удаление строк в таблице. 
-- Разработать сценарий, который демонстрирует на примере базы данных Z_UNIVER, что проверка 
-- ограничения целостности выполнена, если есть INSTEAD OF-триггер.
create trigger TR_FACULTY_INSTEAD_OF on FACULTY instead of DELETE
	as raiserror('Удаление запрещено', 10, 1);
	return;
go

delete FACULTY where FACULTY = 'ИТ';
select * from FACULTY
go

-- С помощью оператора DROP удалить все DML-триггеры, созданные в этой лабораторной работе.
drop trigger TR_TEACHER_INS
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD
drop trigger TR_TEACHER
drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3
drop trigger TR_AUDITORIUM
drop trigger TR_FACULTY_INSTEAD_OF
drop table TR_AUDIT
go

-- Задание 9.
-- Создать DDL-триггер, реагирующий на все DDL-события в БД UNIVER. Триггер должен запрещать создавать новые таблицы и удалять существующие. 
-- Свое выполнение триггер должен сопровождать сообщением, которое содержит: тип события, имя и тип объекта,
-- а также пояснительный текст, в случае запрещения выполнения оператора. 
create trigger TR_DDL_UNIVER on database for DDL_DATABASE_LEVEL_EVENTS
	as 
	declare @ev_type varchar(50) = eventdata().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
	declare @obj_name varchar(50) = eventdata().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
	declare @obj_type varchar(50) = eventdata().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');
	if (@ev_type = 'CREATE_TABLE') 
		begin
			raiserror('Создание таблиц запрещено', 16, 1);
			rollback;
		end;
	if (@ev_type = 'DROP_TABLE') 
		begin
			raiserror('Удаление таблиц запрещено', 16, 1);
			rollback;
		end;
go

create table TESTING (value int);
go
drop table TR_AUDIT;
go

-- Задание 10.
-- Разработать различные виды триггеров для базы данных Z_MyBase и продемонстрировать их работу. 
use Z_MyBase
go
create table TR_AUDIT_MYBASE (
	ID int identity,
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
	TRNAME varchar(50),
	CC varchar(300)
)
go
select * from ОЦЕНКИ
go
alter trigger TR_MYBASE_INS on ОЦЕНКИ after INSERT
	as 
	declare @nm int, @s nvarchar(12), @o tinyint, @id int, @in varchar(300);
	print 'Операция вставки';
	set @nm = (select Студент_номер from inserted);
	set @s = (select Экзаменационный_предмет from inserted);
	set @o = (select Оценка from inserted);
	set @id = (select ID_Оценки from inserted);
	set @in = cast(@nm as varchar(7)) + ' ' + rtrim(@s) + ' ' + cast(@o as varchar(3));
	insert into TR_AUDIT_MYBASE(STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @in);
	return
go
insert into ОЦЕНКИ(Студент_номер, Экзаменационный_предмет, Оценка, ID_Оценки) 
	values (100000, 'МП', 1, 100)
select * from TR_AUDIT_MYBASE
go


create trigger TR_MYBASE_DEL on ОЦЕНКИ after DELETE
	as 
	declare @nm int, @s nvarchar(12), @o tinyint, @id int, @in varchar(300);
	print 'Операция удаления';
	set @nm = (select Студент_номер from inserted);
	set @s = (select Экзаменационный_предмет from inserted);
	set @o = (select Оценка from inserted);
	set @id = (select ID_Оценки from inserted);
	set @in = cast(@nm as varchar(7)) + ' ' + rtrim(@s) + ' ' + cast(@o as varchar(3));
	insert into TR_AUDIT_MYBASE(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @in);
	return;
go
delete ОЦЕНКИ where ID_Оценки = 100;
select * from TR_AUDIT_MYBASE;
go

select t.name, e.type_desc 
from sys.triggers t join sys.trigger_events e  
	on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'ОЦЕНКИ';
go

-- Задание 11*.
-- Создать таблицу WEATHER (город, начальная дата, конечная дата, температура). Создать триггер, проверяющий корректность ввода и изменения данных. 
-- Временные периоды могут быть различными.
drop table WEATHER;
drop trigger TR_WEATHER;
go
create table WEATHER (
	CITY varchar(30),
	START_DATE datetime,
	END_DATE datetime,
	TEMP float
)
go
alter trigger TR_WEATHER on WEATHER for INSERT, UPDATE
	as 
	declare @city varchar(30), @from datetime, @to datetime, @temp float, @count int = 0, @in varchar(300);
	set @city = (select CITY from inserted);
	set @from = (select START_DATE from inserted);
	set @to = (select END_DATE from inserted);
	set @temp = (select TEMP from inserted);
	set @in = rtrim(@city) + ' '  + cast(@from as varchar(10)) + ' ' + cast(@to as varchar(10)) + ' ' + cast(@temp as varchar(10));
	set @count = (select count(*) from WEATHER 
	where CITY = @city and 
				(@from between START_DATE and END_DATE) and 
				(@to between START_DATE and END_DATE));
	if (@count > 1)
		begin
			raiserror(@in, 16, 1);
			rollback
		end
	return
go

insert into WEATHER values ('Минск','01-01-2017 00:00','01-01-2017 23:59', -6);
insert into WEATHER values ('Минск','01-01-2017 00:00','01-01-2017 23:59', -2);
insert into WEATHER values ('Минск','01-01-2017 00:00','01-01-2017 21:59', -10);
insert into WEATHER values ('Минск','02-01-2017 00:00','02-01-2017 23:59', -10);
select * from WEATHER
go