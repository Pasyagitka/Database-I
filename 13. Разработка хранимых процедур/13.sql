use Z_UNIVER;
go

-- ������� 1. ����������� �������� ��������� ��� ���������� � ������ PSUBJECT. 
-- ��������� �������������� ����� �� ������ ������� SUBJECT
-- � ����� ������ ��������� ������ ���������� ���������� �����, ���������� � �������������� �����.
alter procedure PSUBJECT 
as
begin
	select SUBJECT.SUBJECT [���], SUBJECT.SUBJECT_NAME [����������], SUBJECT.PULPIT [�������] from SUBJECT;
	return (select count(*) from SUBJECT);
end;

declare @sCount int = 0;
exec @sCount = PSUBJECT;
print '����������: ' +  cast(@sCount as varchar(3));


-- ������� 2. 
/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 21.05.2021 9:57:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--��������� ������, ��������������� ���� �������, ��������� ���������� @p.
--����������� �������� ��������� ��������� @�, ������ ���������� ����� � �������������� ������
--���������� �������� � ����� ������, ������ ������ ���������� ��������� (���������� ����� � ������� SUBJECT)
ALTER procedure [dbo].[PSUBJECT]  @p varchar(20), @c int output
as
begin
	select SUBJECT.SUBJECT [���], SUBJECT.SUBJECT_NAME [����������], SUBJECT.PULPIT [�������] from SUBJECT
		where SUBJECT.PULPIT = @p
	set @c = (select count(*) from SUBJECT where SUBJECT.PULPIT = @p);
	print '���������: @p = ' + @p + ', @c = ' + cast(@c as varchar(3)); 
	return (select count(*) from SUBJECT)
end;
GO

declare @sCount int = 0, @r int = 0;
exec @sCount = PSUBJECT @p = '����', @c = @r output;
print '����� ���������� ���������: ' +  cast(@sCount as varchar(4));
go

-- ������� 3. ������� ��������� ��������� ������� � ������ #SUBJECT. 
-- ������������ � ��� �������� ������� ������ ��������������� �������� ��������������� ������ ��������� PSUBJECT, ������������� � ������� 2. 
-- �������� ��������� PSUBJECT ����� �������, ����� ��� �� ��������� ��������� ���������.
-- �������� ����������� INSERT� EXECUTE � ���������������� ���������� PSUBJECT, �������� ������ � ������� #SUBJECT. 
create table #SUBJECT(
  SUBJECT  char(10), 
  SUBJECT_NAME varchar(100),
  PULPIT  char(20)
);
go

alter procedure PSUBJECT @p nvarchar(20)
as
begin
	select SUBJECT.SUBJECT [���], SUBJECT.SUBJECT_NAME [����������], SUBJECT.PULPIT [�������] from SUBJECT
		where SUBJECT.PULPIT = @p
	return (select count(*) from SUBJECT)
end
go

insert #SUBJECT exec PSUBJECT @p =  '����'
select * from #SUBJECT
go


-- ������� 4. ����������� ��������� � ������ PAUDITORIUM_INSERT. 
-- ��������� ��������� ������ ������� ���������: @a, @n, @c � @t. 
-- �������� @a ����� ��� CHAR(20), �������� @n ����� ��� VARCHAR(50), �������� @c ����� ��� INT � �������� �� ��������� 0, �������� @t ����� ��� CHAR(10).
 select * from AUDITORIUM
 go
-- 1) ��������� PAUDITORIUM_INSERT ������ ��������� �������� TRY/CATCH ��� ��������� ������.
-- 2) ��������� ��������� ������ � ������� AUDITORIUM. 
-- 3) �������� �������� AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY � AUDITORIUM_TYPE ����������� ������ �������� �������������� ����������� @a, @n, @c � @t.
-- 4) � ������ ������������� ������, ��������� ������ ����������� ���������, ���������� ��� ������, ������� ����������� � ����� ��������� � ����������� �������� �����. 
-- 5) ��������� ������ ���������� � ����� ������ �������� -1 � ��� ������, ���� ��������� ������ � 1, ���� ���������� �������. 
 create procedure PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10) as
 begin
	begin try
		insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values (@a, @n, @c, @t);
		return 1;
	end try
	begin catch
		print '��� ������: ' + cast(error_number() as varchar(6));
		print '������� �����������: ' + cast(error_severity() as varchar(6));
		print '����� ���������: ' + error_message();
		if error_procedure() is not null
			print '��� ���������: ' + error_procedure();
		return -1;
	end catch
 end
 go

declare @rc int;
exec @rc = PAUDITORIUM_INSERT @a = '200-3�', @n = '200-3�', @c = 60, @t = '��-�';
print '��� : ' + cast(@rc as varchar(3))
go

declare @rc int;
exec @rc = PAUDITORIUM_INSERT @a = '200-3�', @n = '200-3�', @c = 60, @t = '��-�';
print '��� : ' + cast(@rc as varchar(3))
go

select * from AUDITORIUM
go

-- ������� 5. SUBJECT_REPORT, � ����������� �������� ����� ����� �� ������� ��������� �� ���������� �������. 
-- � ����� ������ ���� �������� ������� �������� (���� SUBJECT) �� ������� SUBJECT � ���� ������ ����� ������� (������������ ���������� ������� RTRIM). 
-- ��������� ����� ������� �������� � ������ @p ���� CHAR(10), ������� ������������ ��� �������� ���� �������.
-- � ��� ������, ���� �� ��������� �������� @p ���������� ���������� ��� �������, ��������� ������ ������������ ������ � ���������� ������ � ����������. 
create procedure SUBJECT_REPORT @p char(10) as
begin try
	if not exists(select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = @p)
		raiserror('������ � ����������', 11, 1)
	else
		begin
		declare @s nchar(10), @result nvarchar(200) = ''
		declare Subjects cursor local for select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = @p;
		open subjects
		fetch subjects into @s
		print '����� �� ������� ��������� �� ������� ' + @p
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
	print '������!' 
	print '������� �����������: ' + cast(error_severity() as varchar(6));
	print '����� ���������: ' + error_message();
	if error_procedure() is not null  print '��� ���������: ' + error_procedure()
end catch


-- ��������� SUBJECT_REPORT ������ ���������� ���������� ���������, ������������ � ������. 
declare @k int = 0;
exec @k = SUBJECT_REPORT @p =  '����'
print '���������� ���������, ������������ � ������: ' + cast(@k as varchar(4))
go

declare @k int = 0;
exec @k = SUBJECT_REPORT @p =  '���'
print '���������� ���������, ������������ � ������: ' + cast(@k as varchar(4))
go


-- ������� 6. ����������� ��������� � ������ PAUDITORIUM_INSERTX. 
-- ��������� ��������� ���� ������� ����������: @a, @n, @c, @t � @tn. 
-- �������������� �������� @tn �������� �������, ����� ��� VARCHAR(50), ������������ ��� ����� �������� � ������� AUDITORIUM_TYPE.AUDITORIUM_TYPENAME.
select * from AUDITORIUM_TYPE
go
-- 1) ���������� ������ � ������� AUDITORIUM_TYPE � ����� ��������� PAUDITORIUM_INSERT ������ ����������� � ������ ����� ����� ���������� � ������� ��������������� SERIALIZABLE. 
-- 2) ��������� ��������� ��� ������
create procedure PAUDITORIUM_INSERTX @a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(50) as
begin
	begin try
		set transaction isolation level SERIALIZABLE
		begin tran
			-- ������ ������ ����������� � ������� AUDITORIUM_TYPE. �������� �������� AUDITORIUM_TYPE � AUDITORIUM_TYPENAME ����������� ������ �������� �������������� ����������� @t � @tn. 
			insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values (@t, @tn);
			-- ������ ������ ����������� ����� ������ ��������� PAUDITORIUM_INSERT.
			declare @rc int;
			exec @rc = PAUDITORIUM_INSERT @a = @a, @n = @n, @c = @c, @t = @t;		
		commit
		return @rc;
	end try
	begin catch
		if @@trancount > 0 rollback;
		print '��� ������: ' + cast(error_number() as varchar(6));
		print '����� ���������: ' + error_message();
		print '������� �����������: ' + cast(error_severity() as varchar(6));
		print '�����: ' + cast(error_state()   as varchar(8));
		print '����� ������: ' + cast(error_line()  as varchar(8));
		if error_procedure() is not null
			print '��� ���������: ' + error_procedure();
		return -1;
	end catch
end
go

declare @rc int;
exec @rc = PAUDITORIUM_INSERTX  @a = '200-3�', @n = '200-3�', @c = 80, @t = '��-�', @tn = '��������� � �������';
print @rc;
go

declare @rc int;
exec @rc = PAUDITORIUM_INSERTX  @a = '200-3�', @n = '200-3�', @c = 60, @t = '��-�', @tn = '��������� ��� ������';
print @rc;
go

select * from AUDITORIUM;
select * from AUDITORIUM_TYPE
go

delete AUDITORIUM where AUDITORIUM.AUDITORIUM_TYPE = '��-�';
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = '��������� � �������';
go


-- ������� 7. ����������� �������� ��������� ��� ���� ������ X_MyBASE � ������������������ �� ������. 
use Z_MyBase;
go

create procedure PSUBJECT
as
begin
	select ��������.������� [�������], ��������.�����_������������ [����] from ��������;
	return (select count(*) from ��������);
end;

declare @sCount int = 0;
exec @sCount = PSUBJECT;
print '����������: ' +  cast(@sCount as varchar(3));


 create procedure PINSERT @i int, @s nvarchar(15), @f nvarchar(15), @p nvarchar(15), @a nvarchar(30), @t nvarchar(10) as
 begin
	begin try
		insert into �������� values (@i, @s, @f, @p, @a, @t);
		return 1;
	end try
	begin catch
		print '��� ������: ' + cast(error_number() as varchar(6));
		print '������� �����������: ' + cast(error_severity() as varchar(6));
		print '����� ���������: ' + error_message();
		if error_procedure() is not null
			print '��� ���������: ' + error_procedure();
		return -1;
	end catch
 end
 go

declare @rc int;
exec @rc = PINSERT @i = 100007, @s = '�������', @f = '���', @p = '��������', @a = '�����', @t = '4456342536';
print '��� : ' + cast(@rc as varchar(3))
go



-- ������� 8*. ����������: ��� ���������� ��������� ������������ �������� ������ 1 � ��������� �������� TRY/CATCH.
-- ����������� ��������� � ������ PRINT_REPORT, ����������� � ����������� �������� ����� �����, ����������� ������, ��������������� �� ������� � ������� 8 ������������ ������ � 11. 
use Z_UNIVER;
go 
-- 1) f != null, p = null  => ������ ��� f
-- 2) f != null, p != null => ������ ��� p �� f
-- 3) f = null,  p != null => p, pulpit.faculty (�� ������ � ����������)
-- 4) ���������� � ����� ������ ���������� ������ � ������
alter procedure PRINT_REPORT @f char(10) = null, @p char(10) = null 
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

select * from FACULTY left join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
