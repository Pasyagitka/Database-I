--������� 1
--�������� ���������� ���� char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5);
--������ ��� ���������� ������������������� � ��������� ����������
DECLARE @V_CHAR CHAR = 'A',
		@V_VARCHAR VARCHAR = 'O',
		@V_DATETIME DATETIME,
		@V_TIME TIME,
		@V_INT INT,
		@V_SMALLINT SMALLINT,
		@V_TINYINT TINYINT,
		@V_NUMERIC NUMERIC(12,5)
--��������� ������������ �������� ��������� ���� ���������� � ������� ��������� SET, ����� �� ���� ���������� 
--��������� ��������, ���������� � ���������� ������� SELECT; 
SET @V_DATETIME = GETDATE()
SET @V_TIME = (SELECT GETDATE())
--���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������,
--���������� ���������� ��������� ��������� �������� � ������� ��������� SELECT; 
SELECT @V_INT = 9, @V_SMALLINT = 11, @V_TINYINT = 100
SELECT @V_CHAR, @V_VARCHAR, @V_DATETIME, @V_TIME
--�������� ����� �������� ���������� ������� � ������� ��������� SELECT, 
--�������� ������ �������� ���������� ����������� � ������� ��������� PRINT. 
PRINT '@V_INT: ' + CAST(@V_INT AS VARCHAR(10)) + ', @V_SMALLINT:' + CAST(@V_SMALLINT AS VARCHAR(10)) + 
	  ' @V_TINYINT: ' +CAST(@V_TINYINT AS VARCHAR(10))

--������� 2
--����������� ������, � ������� ������������ ����� ����������� ���������. 
--����� ����� ����������� > 200, ������� ... ����� < 200, �� ������� ��������� � ������� ����� �����������.
USE Z_UNIVER;
DECLARE @CAPACITY int = (SELECT SUM(AUDITORIUM.AUDITORIUM_CAPACITY) FROM AUDITORIUM),
		@AVERAGECAPACITY int = (SELECT AVG(AUDITORIUM.AUDITORIUM_CAPACITY) FROM AUDITORIUM);
DECLARE	@TOTALCOUNT int = (SELECT COUNT(AUDITORIUM.AUDITORIUM) FROM AUDITORIUM);
DECLARE	@LESSTHANAVERAGE int = (SELECT COUNT(AUDITORIUM.AUDITORIUM) FROM  AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_CAPACITY < @AVERAGECAPACITY);
DECLARE @PERCENT float =  @LESSTHANAVERAGE*100 / @TOTALCOUNT;
IF @CAPACITY > 200
	BEGIN
	    SELECT DISTINCT @TOTALCOUNT [���������� ���������], 
			   @AVERAGECAPACITY [������� ����������� ���������],
			   @LESSTHANAVERAGE [����������, ��� ����������� ������ �������],
			   @PERCENT [������� ��������� � ������������ ������ �������]
        FROM AUDITORIUM
	END
ELSE
	BEGIN
		SELECT @CAPACITY [������ ����� �����������]
	END

--������� 3
--����������� T-SQL-������, ������� ������� �� ������ ���������� ����������
PRINT '����� ������������ �����: '+ CAST(@@ROWCOUNT AS VARCHAR(12));
PRINT '������ SQL Server: ' + @@VERSION;
PRINT '��������� ������������� ��������, ����������� �������� �������� �����������:' + CAST(@@SPID AS VARCHAR(12)); 
PRINT '��� ��������� ������: ' + CAST(@@ERROR AS VARCHAR(12));
PRINT '��� �������: ' +  @@SERVERNAME;
PRINT '���������� ������� ����������� ����������: ' + CAST(@@TRANCOUNT AS VARCHAR(12));
PRINT '�������� ���������� ���������� ����� ��������������� ������: ' + CAST(@@FETCH_STATUS AS VARCHAR(12));
PRINT '������� ����������� ������� ���������: ' + CAST(@@NESTLEVEL AS VARCHAR(12));

--������� 4
--���������� �������� ���������� z ��� ��������� �������� �������� ������
DECLARE @z FLOAT = 0;
DECLARE @t FLOAT = 7, @x FLOAT = 19
SET @t = 11; SET @x = 8;
--SET @t = 5;	 SET @x = 5;
	IF @t > @x
		SET @z = POWER(SIN(@t), 2)
	ELSE IF @t < @x
		SET @z = 4*(@t + @x)
	ELSE
		SET @t = 1 - EXP(@x - 2)
	PRINT 'z=' + CAST(@z as varchar(10))

--�������������� ������� ��� �������� � �����������
DECLARE @STUDENTNAME nvarchar(50) = (SELECT TOP(1) STUDENT.NAME FROM STUDENT);
DECLARE	@IDX int = CHARINDEX(' ', @STUDENTNAME);

SELECT @STUDENTNAME [������ ���],
	   SUBSTRING(@STUDENTNAME, 1, @IDX) +
	   SUBSTRING(@STUDENTNAME, @IDX + 1, 1) + '.' + 
	   SUBSTRING(@STUDENTNAME, CHARINDEX(' ', @STUDENTNAME, @IDX + 1) + 1, 1)+'.'
	   AS [���]

--����� ���������, � ������� ���� �������� � ��������� ������, � ����������� �� ��������
SELECT STUDENT.NAME [���], STUDENT.BDAY [��] FROM STUDENT

SELECT STUDENT.NAME [���], DATEDIFF(YEAR, STUDENT.BDAY, GETDATE()) [�������] 
	FROM STUDENT WHERE MONTH(STUDENT.BDAY) = MONTH(DATEADD(m, 1, GETDATE()));

--����� ��� ������, � ������� �������� ��������� ������ ������� ������� �� ����
DECLARE @GROUPID int = 4;

SET LANGUAGE RUSSIAN;
SELECT DISTINCT STUDENT.IDGROUP [������],  DATENAME(dw, PROGRESS.PDATE) [���� ������]
		FROM STUDENT INNER JOIN PROGRESS ON STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT 
		WHERE PROGRESS.SUBJECT = '����' AND STUDENT.IDGROUP = @GROUPID;

--������� 5
--������������������ ����������� IF� ELSE �� ������� ������� ������ ������ ���� ������ Z_UNIVER.
DECLARE @STCOUNT int = (SELECT COUNT(*) FROM STUDENT),
		@TRCOUNT int = (SELECT COUNT(*) FROM TEACHER);
SET @STCOUNT = 1; SET @TRCOUNT = 33;
SET @STCOUNT = 6; SET @TRCOUNT = 6;
		IF (@STCOUNT > @TRCOUNT)
			PRINT '��������� ������, ��� �������� : ('  + CAST(@STCOUNT AS nvarchar(4)) + ' > ' + CAST(@TRCOUNT AS nvarchar(4)) + ')'
		ELSE IF (@STCOUNT < @TRCOUNT)
			PRINT '�������� ������, ��� ��������� : ('  + CAST(@TRCOUNT AS nvarchar(4)) + ' > ' + CAST(@STCOUNT AS nvarchar(4)) + ')'
		ELSE PRINT '���������� ��������� � �������� � ������������ �����';


--������� 6
--����������� ��������, � ������� � ������� CASE ������������� ������, ���������� ���������� ���������� ���������� ��� ����� ���������.
DECLARE @FACULTY char(2) = '��';

SELECT STUDENT.NAME [��� ��������], AVG(PROGRESS.NOTE) [������� ������], 
	CASE
		WHEN AVG(PROGRESS.NOTE) BETWEEN 0 AND 3.9 THEN '�� �����������������'
		WHEN AVG(PROGRESS.NOTE) BETWEEN 4 AND 4.9 THEN '����������� ��������� 0'
		WHEN AVG(PROGRESS.NOTE) BETWEEN 5 AND 5.9 THEN '����������� ��������� 1,0'
		WHEN AVG(PROGRESS.NOTE) BETWEEN 6 AND 7.9 THEN '����������� ��������� 1,2'
		WHEN AVG(PROGRESS.NOTE) BETWEEN 8 AND 8.9 THEN '����������� ��������� 1,4'
		ELSE '����������� ��������� 1,6'
	END [�����������]
FROM STUDENT INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
			 INNER JOIN GROUPS  ON STUDENT.IDGROUP = GROUPS.IDGROUP 
			 WHERE FACULTY = @FACULTY
GROUP BY STUDENT.NAME

--������� 7
--������� ��������� ��������� ������� �� ���� �������� � 10 �����, ��������� �� � ������� ����������. ������������ �������� WHILE.
CREATE TABLE #TEMPLOCALTABLE(
	ID int,
	NAME nvarchar(20),
	POL nvarchar(10)
)
SET nocount on;
DECLARE @i int = 0
WHILE @i < 10
	BEGIN
		INSERT #TEMPLOCALTABLE(ID, NAME, POL) VALUES (10*rand(),'stroka', 'm')
		SET @i += 1
	END
SELECT * FROM #TEMPLOCALTABLE

--������� 8
--����������� ������, ��������������� ������������� ��������� RETURN. 
PRINT 123
PRINT 456
RETURN
PRINT 789
GO

--������� 9
BEGIN TRY
	UPDATE dbo.AUDITORIUM 
	SET AUDITORIUM_CAPACITY = '�������' 
	WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE '��'
END TRY
BEGIN CATCH
	PRINT 'ERROR_NUMBER()=' + CAST(ERROR_NUMBER() AS VARCHAR)
	PRINT 'ERROR_MESSAGE()=' +ERROR_MESSAGE()
	PRINT 'ERROR_LINE()=' +  CAST(ERROR_LINE() AS VARCHAR)
	PRINT 'ERROR_PROCEDURE()=' +ERROR_PROCEDURE()
	PRINT 'ERROR_SEVERITY()=' +CAST(ERROR_SEVERITY() AS VARCHAR)
	PRINT 'ERROR_STATE()=' + +CAST(ERROR_STATE()AS VARCHAR)
END CATCH
