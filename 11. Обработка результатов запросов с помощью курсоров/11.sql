use Z_UNIVER

-- ������� 1. ������ ��������� �� ������� ����. � ����� ������ ���� �������� ������� �������� (���� SUBJECT) �� ������� SUBJECT � ���� ������ ����� �������. 
declare @subject nvarchar(20), @result varchar(300) = ''
declare cSubjSubject cursor for select SUBJECT from SUBJECT where SUBJECT.PULPIT = '����';

open cSubjSubject
fetch cSubjSubject into @subject
while @@fetch_status = 0
begin
    set @result = rtrim(@subject) + ', ' + @result
    fetch cSubjSubject into @subject
end
close cSubjSubject
set @result = substring(@result, 1, len(@result)-1) + '.';
print @result
deallocate cSubjSubject

-- ������� 2. ����������� ��������, ��������������� ������� ����������� ������� �� ����������
declare cLocal cursor local for select AUDITORIUM_TYPE, AUDITORIUM from AUDITORIUM;
declare @type nvarchar(10), @auditorium nvarchar(10); 

open cLocal;	  
fetch cLocal into @type, @auditorium;
print '1. '+ @type + @auditorium;  
go
declare @type nvarchar(10), @auditorium nvarchar(10);      	  
fetch cLocal into @type, @auditorium;
print '2. '+ @type + @auditorium;  
go  


declare cGlobal cursor global for select AUDITORIUM_TYPE, AUDITORIUM from AUDITORIUM;
declare @type nvarchar(10), @auditorium nvarchar(10);      

open cGlobal;	  
fetch cGlobal into @type, @auditorium;
print '1. '+ @type + @auditorium;  
go
declare @type nvarchar(10), @auditorium nvarchar(10);        
fetch cGlobal into @type, @auditorium;
print '2. '+ @type + @auditorium; 
close cGlobal
deallocate cGlobal 
go

-- ������� 3
-- ������� ����������� �������� �� ������������
set nocount on
declare @subj nvarchar(10), @id int, @pdate date, @note int;  
declare cProgress cursor local 
--static
dynamic
for select * from dbo.PROGRESS where SUBJECT = '��';				   

open cProgress;
print '���������� ����� : '+cast(@@cursor_rows as varchar(5)); 

insert into PROGRESS values('��', 1005, getdate(), 3), ('��', 1004, getdate(), 1), ('��', 1003, getdate(), 2)
--update PROGRESS set Note = 4 where Note = 5 and SUBJECT='��';
--delete PROGRESS where Note in(1,2,3) and SUBJECT='��';

fetch cProgress into @subj, @id, @pdate, @note;     
while @@fetch_status = 0                                    
    begin 
        print @subj + ' '+ cast(@id as varchar(15)) + ' '+ cast(@pdate as varchar(15)) + ' '+cast(@note as varchar(15));      
        fetch cProgress into @subj, @id, @pdate, @note; 
    end;          
close cProgress;


-- ������� 4. �������� ��������� � �������������� ������ ������� � ��������� SCROLL
declare  @num int, @s char(50);  
declare cscroll cursor local dynamic SCROLL                               
for select row_number() over (order by auditorium) a, auditorium from dbo.auditorium where auditorium_type in ('��-�', '��-�')

open cscroll;
fetch  first from  cscroll into @num, @s;				print '������ ������                   : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s);      
fetch  next from cscroll into  @num, @s;				print '��������� ������                : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s); 
fetch  relative 2 from  cscroll into @num, @s;			print '������ ������ ������ �� ������� : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s); 
fetch  prior from  cscroll into @num, @s;				print '���������� ������ �� �������    : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s); 
fetch  absolute -2 from  cscroll into @num, @s;			print '������ ������ �� �����          : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s);      
fetch  last from  cscroll into @num, @s;				print '��������� ������                : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s);      
close cscroll;


-- ������� 5. ���������� ����������� CURRENT OF � ������ WHERE � �������������� ���������� UPDATE � DELETE.
declare cProgressCurrentOf cursor local dynamic for select * from progress for update;	
declare @subj nvarchar(10), @id int, @pdate date, @note int;  

select * from Progress
open cProgressCurrentOf;

fetch cProgressCurrentOf into @subj, @id, @pdate, @note;
delete PROGRESS where CURRENT OF cProgressCurrentOf;

fetch cProgressCurrentOf into @subj, @id, @pdate, @note; 
update PROGRESS set Note = Note + 1 where CURRENT OF cProgressCurrentOf;

close cProgressCurrentOf;
select * from Progress


--INSERT INTO PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
--    VALUES ('����', 1000,  '01.10.2013',6),
--           ('����', 1001,  '01.10.2013',8),
--           ('����', 1002,  '01.10.2013',7),
--           ('����', 1003,  '01.10.2013',5),
--           ('����', 1005,  '01.10.2013',4),
--		   ('����', 1014,  '01.12.2013',5),
--           ('����', 1015,  '01.12.2013',9),
--           ('����', 1016,  '01.12.2013',5),
--           ('����', 1017,  '01.12.2013',4),
--		   ('��',   1018,  '06.5.2013', 4),
--           ('��',   1019,  '06.05.2013',7),
--           ('��',   1020,  '06.05.2013',7),
--           ('��',   1021,  '06.05.2013',9),
--           ('��',   1022,  '06.05.2013',5),
--           ('��',   1023,  '06.05.2013',6);

-- ������� 6.
-- ����������� SELECT-������, � ������� �������� �� ������� PROGRESS ��������� ������, ���������� ���������� � ���������, 
-- ���������� ������ ���� 4 (������������ ����������� ������ PROGRESS, STUDENT, GROUPS).
insert into progress values ('��', 1025, getdate(), 2),
							('��', 1024, getdate(), 2),
							('��', 1023, getdate(), 2),
							('��', 1022, getdate(), 2);
							go
select * from progress
go
declare @subj6 nvarchar(10), @studentid6 int, @pdate6 date, @note6 int;  
declare cProgressNote cursor local dynamic for 
select PROGRESS.subject, PROGRESS.idstudent, PROGRESS.pdate, PROGRESS.note 
		from PROGRESS inner join STUDENT on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
for update;

open cProgressNote;
fetch cProgressNote into @subj6, @studentid6, @pdate6, @note6;
while @@fetch_status = 0
	begin
		if @note6 < 4 delete PROGRESS where current of cProgressNote
		fetch cProgressNote into @subj6, @studentid6, @pdate6, @note6;
	end
close cProgressNote
go
select * from progress
go


-- � ������� PROGRESS ��� �������� � ���������� ������� IDSTUDENT �������������� ������ (������������� �� �������).
select IDSTUDENT, NOTE from progress
declare @studentnote int, @studentid int, @concreteid int = 1005;  
declare cProgressNote61 cursor local dynamic for select IDSTUDENT, NOTE from progress for update;

open cProgressNote61;
fetch cProgressNote61 into @studentid, @studentnote;
while @@fetch_status = 0
	begin
		fetch cProgressNote61 into @studentid, @studentnote;
		if @studentid = @concreteid update PROGRESS set Note = Note + 1 where current of cProgressNote61
	end
close cProgressNote61
deallocate cProgressNote61
select IDSTUDENT, NOTE from progress


-- ������� 7. Z_MyBase
use Z_MyBase

select * from ��������
select * from ������
select * from ��������

declare @subject nvarchar(20), @result varchar(300) = ''
declare cSubjectsMyBase cursor for select ������� from ��������;
open cSubjectsMyBase
fetch cSubjectsMyBase into @subject
while @@fetch_status = 0
begin
    set @result = rtrim(@subject) + ', ' + @result
    fetch cSubjectsMyBase into @subject
end
close cSubjectsMyBase
set @result = substring(@result, 1, len(@result)-1) + '.';
print @result
deallocate cSubjectsMyBase


declare  @num int, @s char(50);  
declare cscroll cursor local dynamic SCROLL                               
for select row_number() over (order by �������) a, ������� from dbo.��������
open cscroll;
fetch  first from  cscroll into @num, @s;				print '������ ������                   : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s);      
fetch  next from cscroll into  @num, @s;				print '��������� ������                : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s); 
fetch  relative 2 from  cscroll into @num, @s;			print '������ ������ ������ �� ������� : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s); 
fetch  prior from  cscroll into @num, @s;				print '���������� ������ �� �������    : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s); 
fetch  absolute -2 from  cscroll into @num, @s;			print '������ ������ �� �����          : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s);      
fetch  last from  cscroll into @num, @s;				print '��������� ������                : ' + cast(@num as varchar(3))+ ' ' + rtrim(@s);      
close cscroll;


-- ������� 8*
declare @faculty nvarchar(150), @pulpit nvarchar(200), @currentsubject nvarchar(10),
		@subjects nvarchar(300) = '', 
		@teachercount nvarchar(2), 
		@currentfaculty nvarchar(7), 
		@currentpulpit nvarchar(60);
declare cursor8 cursor local static for
select faculty.faculty, pulpit.pulpit_name, subject.subject, count(TEACHER.TEACHER)
from faculty left join pulpit on pulpit.faculty = faculty.faculty 
			 left join subject on subject.pulpit = pulpit.pulpit 
			 left join teacher on teacher.pulpit = pulpit.pulpit
group by faculty.faculty, pulpit.pulpit_name, subject.subject;

open cursor8
fetch cursor8 into @faculty, @pulpit, @currentsubject, @teachercount
while @@fetch_status = 0
begin
	print '���������: ' + rtrim(@faculty);
	set @currentfaculty = @faculty;
	while (@faculty = @currentfaculty and  @@fetch_status = 0)
	begin
		print space(1)+'�������: ' + rtrim(@pulpit);
		print space(2)+'���������� ��������������: ' + rtrim(@teachercount);
		set @currentpulpit = @pulpit;
		while (1=1)
		begin
			if(@currentsubject != '') set @subjects = @subjects  + rtrim(@currentsubject) + ', ';
			fetch cursor8 into @faculty, @pulpit, @currentsubject, @teachercount;
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
close cursor8