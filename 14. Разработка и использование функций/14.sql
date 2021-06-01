use Z_UNIVER
go
-- Задание 1.
-- Разработать скалярную функцию с именем COUNT_STUDENTS, которая вычисляет количество 
--студентов на факультете, код которого задается параметром типа VARCHAR(20) с именем @faculty. 
--Использовать внутреннее соединение таблиц FACULTY, GROUPS, STU-DENT. Опробовать работу функции.
alter function COUNT_STUDENTS(@faculty varchar(20)) returns int
as begin declare @rc int = 0;
	set @rc = (select count(IDSTUDENT) 
		from FACULTY join GROUPS on  GROUPS.FACULTY = FACULTY.FACULTY 
					 join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
		where FACULTY.FACULTY = @faculty);
	return @rc;
	end;
go

declare @n int = dbo.COUNT_STUDENTS('ИТ');
print 'Количество студентов: ' + cast(@n as varchar(4));
go

select FACULTY.FACULTY, dbo.COUNT_STUDENTS(FACULTY.FACULTY) [Количество студентов] from FACULTY;
go


--внести изменения, чтобы функция принимала второй параметр (специальность), для параметров значение по умолчанию null
alter function COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as begin
	declare @rc int = 0;
	set @rc = (select count(IDSTUDENT) 
		from FACULTY join GROUPS  on  GROUPS.FACULTY = FACULTY.FACULTY 
					 join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
		where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = isnull(@prof, GROUPS.PROFESSION));
	return @rc;
	end;
go

select FACULTY.FACULTY, dbo.COUNT_STUDENTS(FACULTY.FACULTY, default) [Количество студентов] from FACULTY;
go

--select * from student join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP where FACULTY = 'ИТ'
declare @n int = dbo.COUNT_STUDENTS('ИТ', '1-36 06 01');
print 'Количество студентов: ' + cast(@n as varchar(4));
go
declare @n int = dbo.COUNT_STUDENTS('ИТ', default);
print 'Количество студентов: ' + cast(@n as varchar(4));
go

-- Задание 2.
-- Разработать скалярную функцию с именем FSUBJECTS, принимающую параметр @p типа 
-- VARCHAR(20), значение которого задает код кафедры (столбец SUBJECT.PULPIT). 
-- Функция должна возвращать строку типа VARCHAR(300) с перечнем дисциплин в отчете.
alter function FSUBJECTS(@p varchar(20)) returns varchar(300)
as begin
	declare @subject varchar(10), @result varchar(100) = 'Дисциплины. '
	declare cSubjects cursor local static for select SUBJECT from SUBJECT where PULPIT like @p
	open cSubjects
		fetch cSubjects into @subject;
		while @@fetch_status = 0
		begin
			set @result = @result + rtrim(@subject) + ', ';
			fetch cSubjects into @subject;
		end;
	close cSubjects;
	return @result
end
go

select PULPIT, dbo.FSUBJECTS(PULPIT) [Перечень дисциплин] from PULPIT;
go

-- Задание 3.
-- Разработать табличную функцию FFACPUL, результаты работы которой продемонстрированы на рисунке ниже. 
-- Функция принимает два параметра, задающих код фа-культета (столбец FACULTY.FACULTY) и код 
-- кафедры (столбец PULPIT.PULPIT). Использует SELECT-запрос c левым внешним соединением между 
-- таблицами FACULTY и PULPIT. 
alter function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY 
	   left join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
	   where FACULTY.FACULTY = ISNULL(@f, FACULTY.FACULTY) and PULPIT.PULPIT = ISNULL(@p, PULPIT.PULPIT);
go
--select * from FACULTY left join pulpit on FACULTY.FACULTY = PULPIT.FACULTY
select * from dbo.FFACPUL(null, null); --список всех кафедр на всех факультетах
select * from dbo.FFACPUL('ЛХФ', null); --список всех кафедр заданного факультета
select * from dbo.FFACPUL(null, 'ЛМиЛЗ'); -- заданная кафедра
select * from dbo.FFACPUL('ТТЛП', 'ЛМиЛЗ'); -- заданная кафедра на заданном факультете
select * from dbo.FFACPUL('ИТ', 'ЛМиЛЗ'); --Если по заданным значениям параметров невозможно сформировать строки, функция возвращает пустой результирующий набор


--Задание 4. Функция принимает один параметр, задающий код кафедры. Функция возвращает количество преподавателей на 
--заданной параметром кафедре. 
--Если параметр равен NULL, то возвращается общее количество преподавателей. 
alter function FCTEACHER(@p varchar(20)) returns int
as begin
	declare @rc int = (select count(*) from TEACHER where PULPIT = ISNULL(@p, PULPIT))
	return @rc
end
go
select distinct PULPIT, dbo.FCTEACHER(PULPIT)[Количество преподавателей] from TEACHER
select dbo.FCTEACHER(null)[Общее количество преподавателей]
go

--Задание 5. Z_MyBase
use Z_MyBase
select * from СТУДЕНТЫ
select * from ПРЕДМЕТЫ
select * from ОЦЕНКИ

alter function COUNT_MARK(@mark int) returns int
as begin 
	declare @rc int = 0;
	set @rc = (select count(Студент_номер)from ОЦЕНКИ where Оценка < @mark)
	return @rc
	end
go
declare @n int = dbo.COUNT_MARK(8);
print 'Количество оценок ниже заданной: ' + cast(@n as varchar(4));
go

select * from ОЦЕНКИ
go
alter function FSUBJECTS_Z(@mark int) returns varchar(300)
as begin
	declare @subject varchar(10), @result varchar(100) = 'Дисциплины. '
	declare cSubjects cursor local static for 
		select Экзаменационный_предмет from ОЦЕНКИ where Оценка = @mark
	open cSubjects
		fetch cSubjects into @subject;
		while @@fetch_status = 0
		begin
			set @result = @result + rtrim(@subject) + ', ';
			fetch cSubjects into @subject;
		end;
	close cSubjects;
	return @result
end
go
select distinct dbo.FSUBJECTS_Z(5) from ОЦЕНКИ;
go


--Задание 6.
use Z_UNIVER

alter function FACULTY_REPORT(@c int) returns @fr table
	          ([Факультет] varchar(50), [Количество кафедр] int, [Количество групп] int,  [Количество студентов] int, [Количество специальностей] int )
as begin 
        declare cc CURSOR static for 
		select FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY, default) > @c; 

	    declare @f varchar(30)
	    open cc
        fetch cc into @f
	    while @@fetch_status = 0
	    begin
		insert @fr values(@f, dbo.COUNT_PULPIT(@f), 
							  dbo.COUNT_GROUP(@f), 
							  dbo.COUNT_STUDENTS(@f, default), 
							  dbo.COUNT_PROFESSION(@f))
	        fetch cc into @f
	    end
        return
end
go
alter function COUNT_PULPIT(@f varchar(20)) returns int as
begin
	declare @rc int = 0
	set @rc = (select count(PULPIT) from PULPIT where FACULTY = @f)
	return @rc
end
go
alter function COUNT_GROUP(@f varchar(20)) returns int as 
begin
	declare @rc int = 0
	set @rc = (select count(IDGROUP) from GROUPS where FACULTY like @f)
	return @rc
end
go
alter function COUNT_PROFESSION(@f varchar(20)) returns int as 
begin
	declare @rc int = 0
	set @rc = (select count(PROFESSION) from PROFESSION where FACULTY like @f)
	return @rc
end
go

select * from dbo.FACULTY_REPORT(10)
go
select * from dbo.FACULTY_REPORT(15)
go

-- Задание 7*
-- Рассмотреть хранимую процедуру с именем PRINT_REPORT из пункта 8 лабораторной работы № 14.
-- Создать новую версию этой процедуры с именем PRINT_REPORTX. 
-- Процедура PRINT_REPORTX должна работать аналогично процедуре PRINT_REPORT и иметь тот же набор 
-- параметров, но SELECT-запрос курсора в новой процедуре должен использовать функции FSUBJECTS, 
-- FFACPUL и FCTEACHER.
-- Сравнить результаты, полученные процедурами PRINT_REPORT и PRINT_REPORTX и убедиться в 
-- работоспособности новой функции. 

alter procedure PRINT_REPORTX @f char(10) = null, @p char(10) = null 
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
		select @f,
			dbo.FFACPUL(@f, @p), --возвращает кафедры на факультете
			dbo.FSUBJECTS(@p),   --дисциплины для кафедры
			dbo.FCTEACHER(@p)[Общее количество преподавателей] -- Количество преподавателей на кафдре
								
		--select faculty.faculty, pulpit.pulpit, subject.subject, count(TEACHER.TEACHER)
		--from faculty left join pulpit on pulpit.faculty = faculty.faculty 
		--			 left join subject on subject.pulpit = pulpit.pulpit 
		--			 left join teacher on teacher.pulpit = pulpit.pulpit
		--where faculty.faculty = isnull(@f, pulpit.faculty) and pulpit.pulpit = isnull(@p, pulpit.pulpit)
		--group by faculty.faculty, pulpit.pulpit, subject.subject;

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
