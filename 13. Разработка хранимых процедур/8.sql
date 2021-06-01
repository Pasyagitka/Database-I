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
		where FACULTY.FACULTY = isnull(@f, FACULTY.FACULTY) and PULPIT.PULPIT = isnull(@p, PULPIT.PULPIT)
		group by faculty.faculty, pulpit.pulpit, subject.subject;

		open cursor8;
		fetch cursor8 into @faculty, @pulpit, @subject, @teachercount;
		while @@fetch_status = 0
			begin 
				print '��������� ' + rtrim(@faculty);
				set @currentfaculty = @faculty;
				while (@faculty = @currentfaculty)
				begin
					print space(1)+'�������: ' + rtrim(@pulpit);
					print space(2)+'���������� ��������������: ' + rtrim(@teachercount);
					
					set @pulpitreportcount += 1;
					set @list = '����������: ';

					if(@subject is not null)
						begin
							if(@list = '����������: ')
								set @list += rtrim(@subject);
							else
								set @list += ', ' + rtrim(@subject);
								
						end;
					if (@subject is null) set @list = '����������: ���.';



					set @currentpulpit = @pulpit;
					fetch cursor8 into @faculty, @pulpit, @subject, @teachercount;

					while (@pulpit = @currentpulpit)
					begin
						if(@subject is not null)
							begin
								if(@list = '����������: ') set @list += rtrim(@subject);
								else set @list += ', ' + rtrim(@subject);
							end;
						fetch cursor8 into @faculty, @pulpit, @subject, @teachercount;
						if(@@fetch_status != 0) break;
					end;


					if(@list != '����������: ���.') set @list += '.';
					print '  '+ @list;


					if(@@fetch_status != 0) break;
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