USE Z_UNIVER;
GO

--������� 1
CREATE VIEW [�������������] 
AS SELECT TEACHER ���, TEACHER_NAME [��� �������������], GENDER ���, PULPIT [��� �������] FROM TEACHER;
GO

SELECT * FROM �������������;
GO

--������� 2 �������� ������������� ���������� INSERT
CREATE VIEW [���������� ������]
AS SELECT FACULTY.FACULTY_NAME ���������, COUNT(*) [���������� ������]
FROM FACULTY INNER JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
GROUP BY FACULTY.FACULTY_NAME
GO

SELECT * FROM [���������� ������];
GO

--������� 3, ������ ���������� ������ ���������� ���������, ��������� ���������� ��������� INSERT, UPDATE � DELETE.
CREATE VIEW [���������]
AS SELECT AUDITORIUM.AUDITORIUM ���, AUDITORIUM.AUDITORIUM_TYPE [��� ���������]
FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE '��%';
GO

INSERT [���������] 	VALUES('200-3�', '��');
SELECT * FROM [���������]
GO

--������� 4, ���������� ������ ���������� ���������
CREATE VIEW [���������� ���������]
AS SELECT AUDITORIUM.AUDITORIUM ���, AUDITORIUM.AUDITORIUM_TYPE	[��� ���������]
FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE '��' WITH CHECK OPTION;
GO

INSERT [���������� ���������] 	VALUES('200-3a', '��');
INSERT [���������� ���������] 	VALUES('310a-1', '��-�');

SELECT * FROM [���������� ���������]
GO

--������� 5
--���������� ��� ���������� � ���������� �������, ������������ TOP, ORDER
CREATE VIEW [����������]
AS SELECT TOP(30) SUBJECT[���], SUBJECT_NAME[������������ ����������], PULPIT[��� �������]
FROM SUBJECT 
ORDER BY SUBJECT;
GO

SELECT * FROM [����������]
GO

--������� 6
--�������� ������������� ����������_������, ��������� � ������� 2 ���, ����� ��� ���� ��������� � ������� ��������. 
--������������������ �������� ������������� ������������� � ������� ��������
ALTER VIEW dbo.[���������� ������] WITH SCHEMABINDING
AS SELECT FACULTY_NAME ���������, COUNT(*) [���������� ������]
FROM dbo.FACULTY fk JOIN dbo.PULPIT pt ON fk.FACULTY = pt.FACULTY
GROUP BY fk.FACULTY_NAME;
GO
SELECT * FROM [���������� ������];
GO
DROP TABLE dbo.FACULTY
GO

CREATE TABLE dbo.Table1 (ID INT, Col1 VARCHAR(100))
GO
CREATE VIEW dbo.FirstView WITH SCHEMABINDING
AS SELECT ID FROM dbo.Table1
GO
DROP TABLE dbo.Table1
GO

--������� 8
SELECT * FROM TIMETABLE

SELECT TEACHER, LESSON AS ����, isnull(��, '')�����������, isnull(��, '')�������, isnull(��, '')�����, isnull(��, '')�������, isnull(��, '')�������
FROM 
(SELECT SUBJECT+'������ '+CAST(IDGROUP AS nvarchar)+'   '+AUDITORIUM [�������], WEEKSDAY, TEACHER, LESSON FROM TIMETABLE) s
PIVOT(MAX(�������) FOR WEEKSDAY IN (��, ��, ��, ��, ��)) d
GROUP BY TEACHER, LESSON, ��, ��, ��, ��, �� 
GO

--������� 7
USE Z_MyBase;
GO

CREATE VIEW [���������� � ���������] 
AS SELECT �������+' '+���+' '+�������� [���], �����, �������[���������� �������] FROM ��������;
GO
SELECT * FROM [���������� � ���������]
GO

CREATE VIEW [���������� �� �������]
AS
SELECT TOP(10) ������.���������������_������� [�������],
	MAX(������) [������������],
	MIN(������) [�����������],
	AVG(������) [�������],
	COUNT(*) [����� ����������]
FROM ������ 
	GROUP BY ������.���������������_�������
	ORDER BY ������.���������������_������� ASC
GO

SELECT * FROM [���������� �� �������]
GO

CREATE VIEW [������������]
AS
SELECT isnull(��������.�������, '�����') �������, isnull(������.���������������_�������, '�����') ����������, ROUND(AVG(CAST(������.������ AS FLOAT(4))), 2) [������� ������]
FROM ������ INNER JOIN �������� ON ������.�������_����� = ��������.�����_��������
GROUP BY ROLLUP(��������.�������, ������.���������������_�������)
GO

SELECT * FROM [������������];
GO

SELECT * FROM [���������� � ���������];
SELECT * FROM [���������� �� �������];
SELECT * FROM [������������];
GO
