use Z_UNIVER
go
-- ������� 1.
-- ����������� ��������� ������� � ������ COUNT_STUDENTS, ������� ��������� ���������� 
--��������� �� ����������, ��� �������� �������� ���������� ���� VARCHAR(20) � ������ @faculty. 
--������������ ���������� ���������� ������ FACULTY, GROUPS, STU-DENT. ���������� ������ �������.
alter function COUNT_STUDENTS(@faculty varchar(20)) returns int
as begin declare @rc int = 0;
	set @rc = (select count(IDSTUDENT) 
		from FACULTY join GROUPS on  GROUPS.FACULTY = FACULTY.FACULTY 
					 join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
		where FACULTY.FACULTY = @faculty);
	return @rc;
	end;
go

declare @n int = dbo.COUNT_STUDENTS('��');
print '���������� ���������: ' + cast(@n as varchar(4));
go

select FACULTY.FACULTY, dbo.COUNT_STUDENTS(FACULTY.FACULTY) [���������� ���������] from FACULTY;
go


--������ ���������, ����� ������� ��������� ������ �������� (�������������), ��� ���������� �������� �� ��������� null
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

select FACULTY.FACULTY, dbo.COUNT_STUDENTS(FACULTY.FACULTY, default) [���������� ���������] from FACULTY;
go

--select * from student join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP where FACULTY = '��'
declare @n int = dbo.COUNT_STUDENTS('��', '1-36 06 01');
print '���������� ���������: ' + cast(@n as varchar(4));
go
declare @n int = dbo.COUNT_STUDENTS('��', default);
print '���������� ���������: ' + cast(@n as varchar(4));
go

-- ������� 2.
-- ����������� ��������� ������� � ������ FSUBJECTS, ����������� �������� @p ���� 
-- VARCHAR(20), �������� �������� ������ ��� ������� (������� SUBJECT.PULPIT). 
-- ������� ������ ���������� ������ ���� VARCHAR(300) � �������� ��������� � ������.
alter function FSUBJECTS(@p varchar(20)) returns varchar(300)
as begin
	declare @subject varchar(10), @result varchar(100) = '����������. '
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

select PULPIT, dbo.FSUBJECTS(PULPIT) [�������� ���������] from PULPIT;
go

-- ������� 3.
-- ����������� ��������� ������� FFACPUL, ���������� ������ ������� ������������������ �� ������� ����. 
-- ������� ��������� ��� ���������, �������� ��� ��-�������� (������� FACULTY.FACULTY) � ��� 
-- ������� (������� PULPIT.PULPIT). ���������� SELECT-������ c ����� ������� ����������� ����� 
-- ��������� FACULTY � PULPIT. 
alter function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY 
	   left join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
	   where FACULTY.FACULTY = ISNULL(@f, FACULTY.FACULTY) and PULPIT.PULPIT = ISNULL(@p, PULPIT.PULPIT);
go
--select * from FACULTY left join pulpit on FACULTY.FACULTY = PULPIT.FACULTY
select * from dbo.FFACPUL(null, null); --������ ���� ������ �� ���� �����������
select * from dbo.FFACPUL('���', null); --������ ���� ������ ��������� ����������
select * from dbo.FFACPUL(null, '�����'); -- �������� �������
select * from dbo.FFACPUL('����', '�����'); -- �������� ������� �� �������� ����������
select * from dbo.FFACPUL('��', '�����'); --���� �� �������� ��������� ���������� ���������� ������������ ������, ������� ���������� ������ �������������� �����


--������� 4. ������� ��������� ���� ��������, �������� ��� �������. ������� ���������� ���������� �������������� �� 
--�������� ���������� �������. 
--���� �������� ����� NULL, �� ������������ ����� ���������� ��������������. 
alter function FCTEACHER(@p varchar(20)) returns int
as begin
	declare @rc int = (select count(*) from TEACHER where PULPIT = ISNULL(@p, PULPIT))
	return @rc
end
go
select distinct PULPIT, dbo.FCTEACHER(PULPIT)[���������� ��������������] from TEACHER
select dbo.FCTEACHER(null)[����� ���������� ��������������]
go

--������� 5. Z_MyBase
use Z_MyBase
select * from ��������
select * from ��������
select * from ������

alter function COUNT_MARK(@mark int) returns int
as begin 
	declare @rc int = 0;
	set @rc = (select count(�������_�����)from ������ where ������ < @mark)
	return @rc
	end
go
declare @n int = dbo.COUNT_MARK(8);
print '���������� ������ ���� ��������: ' + cast(@n as varchar(4));
go

select * from ������
go
alter function FSUBJECTS_Z(@mark int) returns varchar(300)
as begin
	declare @subject varchar(10), @result varchar(100) = '����������. '
	declare cSubjects cursor local static for 
		select ���������������_������� from ������ where ������ = @mark
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
select distinct dbo.FSUBJECTS_Z(5) from ������;
go


--������� 6.
use Z_UNIVER

alter function FACULTY_REPORT(@c int) returns @fr table
	          ([���������] varchar(50), [���������� ������] int, [���������� �����] int,  [���������� ���������] int, [���������� ��������������] int )
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

-- ������� 7*
-- ����������� �������� ��������� � ������ PRINT_REPORT �� ������ 8 ������������ ������ � 14.
-- ������� ����� ������ ���� ��������� � ������ PRINT_REPORTX. 
-- ��������� PRINT_REPORTX ������ �������� ���������� ��������� PRINT_REPORT � ����� ��� �� ����� 
-- ����������, �� SELECT-������ ������� � ����� ��������� ������ ������������ ������� FSUBJECTS, 
-- FFACPUL � FCTEACHER.
-- �������� ����������, ���������� ����������� PRINT_REPORT � PRINT_REPORTX � ��������� � 
-- ����������������� ����� �������. 

alter procedure PRINT_REPORTX @f char(10) = null, @p char(10) = null 
as 
	declare @faculty char(50), @pulpit char(10), @subject char(10), @teachercount int;
	declare @currentfaculty char(50), 
			@currentpulpit char(10), 
			@list varchar(100), 
			@subjects nvarchar(300) = ''

	begin try
		if (@p is not null and not exists (select FACULTY from PULPIT where PULPIT = @p))
			raiserror('������ � ����������', 11, 1);

		declare @pulpitreportcount int = 0;

		declare cursor8 cursor local static for
		select @f,
			dbo.FFACPUL(@f, @p), --���������� ������� �� ����������
			dbo.FSUBJECTS(@p),   --���������� ��� �������
			dbo.FCTEACHER(@p)[����� ���������� ��������������] -- ���������� �������������� �� ������
								
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
				print '���������: ' + rtrim(@faculty);
				set @currentfaculty = @faculty;
				while (@faculty = @currentfaculty and  @@fetch_status = 0)
				begin
					print space(1)+'�������: ' + rtrim(@pulpit);
					print space(2)+'���������� ��������������: ' + rtrim(@teachercount);
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
						print space(2) + '����������: ' + substring(@subjects, 1, len(@subjects)-1) + '.';
						set @subjects = '';
					end
					else print space(2) +'����������: ���.' ;
				end
			end
		close cursor8;
		return @pulpitreportcount;
	end try
	begin catch
		print '���������: ' + error_message();
		print '�������: ' + convert(varchar, error_severity());
		print '�����: ' + convert(varchar, error_state());
		print '����� ������: ' + convert(varchar, error_line());
		if error_procedure() is not null
			print '��� ���������: ' + error_procedure();
		return -1;
	end catch;
go

declare @k1 int;
exec @k1 = PRINT_REPORT '���', null;
select @k1;
go

declare @k2 int;
exec @k2 = PRINT_REPORT null, '��';
select @k2;
go

declare @k3 int;
exec @k3 = PRINT_REPORT null, '������';
select @k3;
go

declare @k4 int;
exec @k4 = PRINT_REPORT '��', '��';
select @k4;
go
