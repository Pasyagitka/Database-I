USE [Z_UNIVER]
GO

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


