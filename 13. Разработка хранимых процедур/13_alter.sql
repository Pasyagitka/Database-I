USE [Z_UNIVER]
GO

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


