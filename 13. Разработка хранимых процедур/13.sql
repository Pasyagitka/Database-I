use Z_UNIVER;
go

-- Задание 1. Разработать хранимую процедуру без параметров с именем PSUBJECT. 
-- Формирует результирующий набор на основе таблицы SUBJECT
-- К точке вызова процедура должна возвращать количество строк, выведенных в результирующий набор.
alter procedure PSUBJECT 
as
begin
	select SUBJECT.SUBJECT [код], SUBJECT.SUBJECT_NAME [дисциплина], SUBJECT.PULPIT [кафедра] from SUBJECT;
	return (select count(*) from SUBJECT);
end;

declare @sCount int = 0;
exec @sCount = PSUBJECT;
print 'Количество: ' +  cast(@sCount as varchar(3));


-- Задание 2. 
/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 21.05.2021 9:57:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--содержать строки, соответствующие коду кафедры, заданному параметром @p.
--формировать значение выходного параметра @с, равное количеству строк в результирующем наборе
--возвращать значение к точке вызова, равное общему количеству дисциплин (количеству строк в таблице SUBJECT)
ALTER procedure [dbo].[PSUBJECT]  @p varchar(20), @c int output
as
begin
	select SUBJECT.SUBJECT [код], SUBJECT.SUBJECT_NAME [дисциплина], SUBJECT.PULPIT [кафедра] from SUBJECT
		where SUBJECT.PULPIT = @p
	set @c = (select count(*) from SUBJECT where SUBJECT.PULPIT = @p);
	print 'Параметры: @p = ' + @p + ', @c = ' + cast(@c as varchar(3)); 
	return (select count(*) from SUBJECT)
end;
GO

declare @sCount int = 0, @r int = 0;
exec @sCount = PSUBJECT @p = 'ИСиТ', @c = @r output;
print 'Общее количество дисциплин: ' +  cast(@sCount as varchar(4));
go

-- Задание 3. Создать временную локальную таблицу с именем #SUBJECT. 
-- Наименование и тип столбцов таблицы должны соответствовать столбцам результирующего набора процедуры PSUBJECT, разработанной в задании 2. 
-- Изменить процедуру PSUBJECT таким образом, чтобы она не содержала выходного параметра.
-- Применив конструкцию INSERT… EXECUTE с модифицированной процедурой PSUBJECT, добавить строки в таблицу #SUBJECT. 
create table #SUBJECT(
  SUBJECT  char(10), 
  SUBJECT_NAME varchar(100),
  PULPIT  char(20)
);
go

alter procedure PSUBJECT @p nvarchar(20)
as
begin
	select SUBJECT.SUBJECT [код], SUBJECT.SUBJECT_NAME [дисциплина], SUBJECT.PULPIT [кафедра] from SUBJECT
		where SUBJECT.PULPIT = @p
	return (select count(*) from SUBJECT)
end
go

insert #SUBJECT exec PSUBJECT @p =  'ИСиТ'
select * from #SUBJECT
go


-- Задание 4. Разработать процедуру с именем PAUDITORIUM_INSERT. 
-- Процедура принимает четыре входных параметра: @a, @n, @c и @t. 
-- Параметр @a имеет тип CHAR(20), параметр @n имеет тип VARCHAR(50), параметр @c имеет тип INT и значение по умолчанию 0, параметр @t имеет тип CHAR(10).
 select * from AUDITORIUM
 go
-- 1) Процедура PAUDITORIUM_INSERT должна применять механизм TRY/CATCH для обработки ошибок.
-- 2) Процедура добавляет строку в таблицу AUDITORIUM. 
-- 3) Значения столбцов AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY и AUDITORIUM_TYPE добавляемой строки задаются соответственно параметрами @a, @n, @c и @t.
-- 4) В случае возникновения ошибки, процедура должна формировать сообщение, содержащее код ошибки, уровень серьезности и текст сообщения в стандартный выходной поток. 
-- 5) Процедура должна возвращать к точке вызова значение -1 в том случае, если произошла ошибка и 1, если выполнение успешно. 
 create procedure PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10) as
 begin
	begin try
		insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values (@a, @n, @c, @t);
		return 1;
	end try
	begin catch
		print 'Код ошибки: ' + cast(error_number() as varchar(6));
		print 'Уровень серьезности: ' + cast(error_severity() as varchar(6));
		print 'Текст сообщения: ' + error_message();
		if error_procedure() is not null
			print 'Имя процедуры: ' + error_procedure();
		return -1;
	end catch
 end
 go

declare @rc int;
exec @rc = PAUDITORIUM_INSERT @a = '200-3г', @n = '200-3г', @c = 60, @t = 'ЛК-К';
print 'Код : ' + cast(@rc as varchar(3))
go

declare @rc int;
exec @rc = PAUDITORIUM_INSERT @a = '200-3д', @n = '200-3д', @c = 60, @t = 'ЛЛ-К';
print 'Код : ' + cast(@rc as varchar(3))
go

select * from AUDITORIUM
go

-- Задание 5. SUBJECT_REPORT, в стандартный выходной поток отчет со списком дисциплин на конкретной кафедре. 
-- В отчет должны быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в одну строку через запятую (использовать встроенную функцию RTRIM). 
-- Процедура имеет входной параметр с именем @p типа CHAR(10), который предназначен для указания кода кафедры.
-- В том случае, если по заданному значению @p невозможно определить код кафедры, процедура должна генерировать ошибку с сообщением ошибка в параметрах. 
create procedure SUBJECT_REPORT @p char(10) as
begin try
	if not exists(select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = @p)
		raiserror('Ошибка в параметрах', 11, 1)
	else
		begin
		declare @s nchar(10), @result nvarchar(200) = ''
		declare Subjects cursor local for select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = @p;
		open subjects
		fetch subjects into @s
		print 'Отчет со списком дисциплин на кафедре ' + @p
		while (@@fetch_status = 0)
			begin
				set @result = @result + rtrim(@s) + ', ';
				fetch subjects into @s
			end
		 close subjects
		 print @result
		 return (select count(*) from SUBJECT where SUBJECT.PULPIT = @p)
		end
end try
begin catch
	print 'Ошибка!' 
	print 'Уровень серьезности: ' + cast(error_severity() as varchar(6));
	print 'Текст сообщения: ' + error_message();
	if error_procedure() is not null  print 'Имя процедуры: ' + error_procedure()
end catch


-- Процедура SUBJECT_REPORT должна возвращать количество дисциплин, отображенных в отчете. 
declare @k int = 0;
exec @k = SUBJECT_REPORT @p =  'ИСиТ'
print 'Количество дисциплин, отображенных в отчете: ' + cast(@k as varchar(4))
go

declare @k int = 0;
exec @k = SUBJECT_REPORT @p =  'ИСи'
print 'Количество дисциплин, отображенных в отчете: ' + cast(@k as varchar(4))
go


-- Задание 6. Разработать процедуру с именем PAUDITORIUM_INSERTX. 
-- Процедура принимает пять входных параметров: @a, @n, @c, @t и @tn. 
-- Дополнительный параметр @tn является входным, имеет тип VARCHAR(50), предназначен для ввода значения в столбец AUDITORIUM_TYPE.AUDITORIUM_TYPENAME.
select * from AUDITORIUM_TYPE
go
-- 1) Добавление строки в таблицу AUDITORIUM_TYPE и вызов процедуры PAUDITORIUM_INSERT должны выполняться в рамках одной явной транзакции с уровнем изолированности SERIALIZABLE. 
-- 2) Процедура добавляет две строки
create procedure PAUDITORIUM_INSERTX @a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(50) as
begin
	begin try
		set transaction isolation level SERIALIZABLE
		begin tran
			-- Первая строка добавляется в таблицу AUDITORIUM_TYPE. Значения столбцов AUDITORIUM_TYPE и AUDITORIUM_TYPENAME добавляемой строки задаются соответственно параметрами @t и @tn. 
			insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values (@t, @tn);
			-- Вторая строка добавляется путем вызова процедуры PAUDITORIUM_INSERT.
			declare @rc int;
			exec @rc = PAUDITORIUM_INSERT @a = @a, @n = @n, @c = @c, @t = @t;		
		commit
		return @rc;
	end try
	begin catch
		if @@trancount > 0 rollback;
		print 'Код ошибки: ' + cast(error_number() as varchar(6));
		print 'Текст сообщения: ' + error_message();
		print 'Уровень серьезности: ' + cast(error_severity() as varchar(6));
		print 'Метка: ' + cast(error_state()   as varchar(8));
		print 'Номер строки: ' + cast(error_line()  as varchar(8));
		if error_procedure() is not null
			print 'Имя процедуры: ' + error_procedure();
		return -1;
	end catch
end
go

declare @rc int;
exec @rc = PAUDITORIUM_INSERTX  @a = '200-3е', @n = '200-3е', @c = 80, @t = 'ЛБ-К', @tn = 'Аудитория с ошибкой';
print @rc;
go

declare @rc int;
exec @rc = PAUDITORIUM_INSERTX  @a = '200-3о', @n = '200-3о', @c = 60, @t = 'АБ-О', @tn = 'Аудитория без ошибки';
print @rc;
go

select * from AUDITORIUM;
select * from AUDITORIUM_TYPE
go

delete AUDITORIUM where AUDITORIUM.AUDITORIUM_TYPE = 'АА-А';
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = 'Аудитория с ошибкой';
go


-- Задание 7. Разработать хранимые процедуры для базы данных X_MyBASE и продемонстрировать их работу. 
use Z_MyBase;
go

create procedure PSUBJECT
as
begin
	select ПРЕДМЕТЫ.Предмет [Предмет], ПРЕДМЕТЫ.Объём_лабораторных [Лабы] from ПРЕДМЕТЫ;
	return (select count(*) from ПРЕДМЕТЫ);
end;

declare @sCount int = 0;
exec @sCount = PSUBJECT;
print 'Количество: ' +  cast(@sCount as varchar(3));


 create procedure PINSERT @i int, @s nvarchar(15), @f nvarchar(15), @p nvarchar(15), @a nvarchar(30), @t nvarchar(10) as
 begin
	begin try
		insert into СТУДЕНТЫ values (@i, @s, @f, @p, @a, @t);
		return 1;
	end try
	begin catch
		print 'Код ошибки: ' + cast(error_number() as varchar(6));
		print 'Уровень серьезности: ' + cast(error_severity() as varchar(6));
		print 'Текст сообщения: ' + error_message();
		if error_procedure() is not null
			print 'Имя процедуры: ' + error_procedure();
		return -1;
	end catch
 end
 go

declare @rc int;
exec @rc = PINSERT @i = 100007, @s = 'Фамилия', @f = 'Имя', @p = 'Отчество', @a = 'Минск', @t = '4456342536';
print 'Код : ' + cast(@rc as varchar(3))
go



-- Задание 8*. Примечание: при разработке процедуры использовать сценарий пункта 1 и применить механизм TRY/CATCH.
-- Разработать процедуру с именем PRINT_REPORT, формирующую в стандартный выходной поток отчет, аналогичный отчету, представленному на рисунке в задании 8 лабораторной работы № 11. 
use Z_UNIVER;
go 
-- 1) f != null, p = null  => только для f
-- 2) f != null, p != null => только для p на f
-- 3) f = null,  p != null => p, pulpit.faculty (мб ошибка в параметрах)
-- 4) Возвращать к точке вызова количество кафедр в отчете
alter procedure PRINT_REPORT @f char(10) = null, @p char(10) = null 
as 
	declare @faculty char(50), @pulpit char(10), @subject char(10), @teachercount int;
	declare @currentfaculty char(50), 
			@currentpulpit char(10), 
			@list varchar(100), 
			@subjects nvarchar(300) = ''

	begin try
		if (@p is not null and not exists (select FACULTY from PULPIT where PULPIT = @p))
			raiserror('Ошибка в параметрах', 11, 1);

		declare @pulpitreportcount int = 0;

		declare cursor8 cursor local static for
		select faculty.faculty, pulpit.pulpit, subject.subject, count(TEACHER.TEACHER)
		from faculty left join pulpit on pulpit.faculty = faculty.faculty 
					 left join subject on subject.pulpit = pulpit.pulpit 
					 left join teacher on teacher.pulpit = pulpit.pulpit
		where faculty.faculty = isnull(@f, pulpit.faculty) and pulpit.pulpit = isnull(@p, pulpit.pulpit)
		group by faculty.faculty, pulpit.pulpit, subject.subject;

		open cursor8;
		fetch cursor8 into @faculty, @pulpit, @subject, @teachercount;
		while @@fetch_status = 0
			begin 
				print 'Факультет: ' + rtrim(@faculty);
				set @currentfaculty = @faculty;
				while (@faculty = @currentfaculty and  @@fetch_status = 0)
				begin
					print space(1)+'Кафедра: ' + rtrim(@pulpit);
					print space(2)+'Количество преподавателей: ' + rtrim(@teachercount);
					set @pulpitreportcount += 1;

					set @currentpulpit = @pulpit;
					while (1=1 and @@fetch_status = 0)
					begin
						if(@subject != '') set @subjects = @subjects  + rtrim(@subject) + ', ';
						fetch cursor8 into @faculty, @pulpit, @subject, @teachercount;
						if(@pulpit <> @currentpulpit) break;
					end;
					if(@subjects != '')
					begin
						print space(2) + 'Дисциплины: ' + substring(@subjects, 1, len(@subjects)-1) + '.';
						set @subjects = '';
					end
					else print space(2) +'Дисциплины: нет.' ;
				end
			end
		close cursor8;
		return @pulpitreportcount;
	end try
	begin catch
		print 'Сообщение: ' + error_message();
		print 'Уровень: ' + convert(varchar, error_severity());
		print 'Метка: ' + convert(varchar, error_state());
		print 'Номер строки: ' + convert(varchar, error_line());
		if error_procedure() is not null
			print 'Имя процедуры: ' + error_procedure();
		return -1;
	end catch;
go

declare @k1 int;
exec @k1 = PRINT_REPORT 'ИЭФ', null;
select @k1;
go

declare @k2 int;
exec @k2 = PRINT_REPORT null, 'ЛВ';
select @k2;
go

declare @k3 int;
exec @k3 = PRINT_REPORT null, 'Ошибка';
select @k3;
go

declare @k4 int;
exec @k4 = PRINT_REPORT 'ИТ', 'ТЛ';
select @k4;
go

select * from FACULTY left join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
