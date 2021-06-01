--Задание 1
--объявить переменные типа char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5);
--первые две переменные проинициализировать в операторе объявления
DECLARE @V_CHAR CHAR = 'A',
		@V_VARCHAR VARCHAR = 'O',
		@V_DATETIME DATETIME,
		@V_TIME TIME,
		@V_INT INT,
		@V_SMALLINT SMALLINT,
		@V_TINYINT TINYINT,
		@V_NUMERIC NUMERIC(12,5)
--присвоить произвольные значения следующим двум переменным с помощью оператора SET, одной из этих переменных 
--присвоить значение, полученное в результате запроса SELECT; 
SET @V_DATETIME = GETDATE()
SET @V_TIME = (SELECT GETDATE())
--одну из переменных оставить без инициализации и не присваивать ей значения,
--оставшимся переменным присвоить некоторые значения с помощью оператора SELECT; 
SELECT @V_INT = 9, @V_SMALLINT = 11, @V_TINYINT = 100
SELECT @V_CHAR, @V_VARCHAR, @V_DATETIME, @V_TIME
--значения одной половины переменных вывести с помощью оператора SELECT, 
--значения другой половины переменных распечатать с помощью оператора PRINT. 
PRINT '@V_INT: ' + CAST(@V_INT AS VARCHAR(10)) + ', @V_SMALLINT:' + CAST(@V_SMALLINT AS VARCHAR(10)) + 
	  ' @V_TINYINT: ' +CAST(@V_TINYINT AS VARCHAR(10))

--Задание 2
--разработать скрипт, в котором определяется общая вместимость аудиторий. 
--Когда общая вместимость > 200, вывести ... Когда < 200, то вывести сообщение о размере общей вместимости.
USE Z_UNIVER;
DECLARE @CAPACITY int = (SELECT SUM(AUDITORIUM.AUDITORIUM_CAPACITY) FROM AUDITORIUM),
		@AVERAGECAPACITY int = (SELECT AVG(AUDITORIUM.AUDITORIUM_CAPACITY) FROM AUDITORIUM);
DECLARE	@TOTALCOUNT int = (SELECT COUNT(AUDITORIUM.AUDITORIUM) FROM AUDITORIUM);
DECLARE	@LESSTHANAVERAGE int = (SELECT COUNT(AUDITORIUM.AUDITORIUM) FROM  AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_CAPACITY < @AVERAGECAPACITY);
DECLARE @PERCENT float =  @LESSTHANAVERAGE*100 / @TOTALCOUNT;
IF @CAPACITY > 200
	BEGIN
	    SELECT DISTINCT @TOTALCOUNT [Количество аудиторий], 
			   @AVERAGECAPACITY [Средняя вместимость аудиторий],
			   @LESSTHANAVERAGE [Количество, где вместимость меньше средней],
			   @PERCENT [Процент аудиторий с вместимостью меньше средней]
        FROM AUDITORIUM
	END
ELSE
	BEGIN
		SELECT @CAPACITY [Размер общей вместимости]
	END

--Задание 3
--Разработать T-SQL-скрипт, который выводит на печать глобальные переменные
PRINT 'Число обработанных строк: '+ CAST(@@ROWCOUNT AS VARCHAR(12));
PRINT 'Версия SQL Server: ' + @@VERSION;
PRINT 'Системный идентификатор процесса, назначенный сервером текущему подключению:' + CAST(@@SPID AS VARCHAR(12)); 
PRINT 'Код последней ошибки: ' + CAST(@@ERROR AS VARCHAR(12));
PRINT 'Имя сервера: ' +  @@SERVERNAME;
PRINT 'Возвращает уровень вложенности транзакции: ' + CAST(@@TRANCOUNT AS VARCHAR(12));
PRINT 'Проверка результата считывания строк результирующего набора: ' + CAST(@@FETCH_STATUS AS VARCHAR(12));
PRINT 'Уровень вложенности текущей процедуры: ' + CAST(@@NESTLEVEL AS VARCHAR(12));

--Задание 4
--вычисление значений переменной z для различных значений исходных данных
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

--Преобразование полного ФИО студента в сокращенное
DECLARE @STUDENTNAME nvarchar(50) = (SELECT TOP(1) STUDENT.NAME FROM STUDENT);
DECLARE	@IDX int = CHARINDEX(' ', @STUDENTNAME);

SELECT @STUDENTNAME [Полное имя],
	   SUBSTRING(@STUDENTNAME, 1, @IDX) +
	   SUBSTRING(@STUDENTNAME, @IDX + 1, 1) + '.' + 
	   SUBSTRING(@STUDENTNAME, CHARINDEX(' ', @STUDENTNAME, @IDX + 1) + 1, 1)+'.'
	   AS [ФИО]

--Поиск студентов, у которых день рождения в следующем месяце, и определение их возраста
SELECT STUDENT.NAME [ФИО], STUDENT.BDAY [ДР] FROM STUDENT

SELECT STUDENT.NAME [ФИО], DATEDIFF(YEAR, STUDENT.BDAY, GETDATE()) [Возраст] 
	FROM STUDENT WHERE MONTH(STUDENT.BDAY) = MONTH(DATEADD(m, 1, GETDATE()));

--Поиск дня недели, в который студенты некоторой группы сдавали экзамен по СУБД
DECLARE @GROUPID int = 4;

SET LANGUAGE RUSSIAN;
SELECT DISTINCT STUDENT.IDGROUP [Группа],  DATENAME(dw, PROGRESS.PDATE) [День недели]
		FROM STUDENT INNER JOIN PROGRESS ON STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT 
		WHERE PROGRESS.SUBJECT = 'СУБД' AND STUDENT.IDGROUP = @GROUPID;

--Задание 5
--Продемонстрировать конструкцию IF… ELSE на примере анализа данных таблиц базы данных Z_UNIVER.
DECLARE @STCOUNT int = (SELECT COUNT(*) FROM STUDENT),
		@TRCOUNT int = (SELECT COUNT(*) FROM TEACHER);
SET @STCOUNT = 1; SET @TRCOUNT = 33;
SET @STCOUNT = 6; SET @TRCOUNT = 6;
		IF (@STCOUNT > @TRCOUNT)
			PRINT 'Студентов больше, чем учителей : ('  + CAST(@STCOUNT AS nvarchar(4)) + ' > ' + CAST(@TRCOUNT AS nvarchar(4)) + ')'
		ELSE IF (@STCOUNT < @TRCOUNT)
			PRINT 'Учителей больше, чем студентов : ('  + CAST(@TRCOUNT AS nvarchar(4)) + ' > ' + CAST(@STCOUNT AS nvarchar(4)) + ')'
		ELSE PRINT 'Количество студентов и учителей в университете равно';


--Задание 6
--Разработать сценарий, в котором с помощью CASE анализируются оценки, полученные студентами некоторого факультета при сдаче экзаменов.
DECLARE @FACULTY char(2) = 'ИТ';

SELECT STUDENT.NAME [ФИО студента], AVG(PROGRESS.NOTE) [Средняя оценка], 
	CASE
		WHEN AVG(PROGRESS.NOTE) BETWEEN 0 AND 3.9 THEN 'Не удовлетворительно'
		WHEN AVG(PROGRESS.NOTE) BETWEEN 4 AND 4.9 THEN 'Коэффициент стипендии 0'
		WHEN AVG(PROGRESS.NOTE) BETWEEN 5 AND 5.9 THEN 'Коэффициент стипендии 1,0'
		WHEN AVG(PROGRESS.NOTE) BETWEEN 6 AND 7.9 THEN 'Коэффициент стипендии 1,2'
		WHEN AVG(PROGRESS.NOTE) BETWEEN 8 AND 8.9 THEN 'Коэффициент стипендии 1,4'
		ELSE 'Коэффициент стипендии 1,6'
	END [Коэффициент]
FROM STUDENT INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
			 INNER JOIN GROUPS  ON STUDENT.IDGROUP = GROUPS.IDGROUP 
			 WHERE FACULTY = @FACULTY
GROUP BY STUDENT.NAME

--Задание 7
--Создать временную локальную таблицу из трех столбцов и 10 строк, заполнить ее и вывести содержимое. Использовать оператор WHILE.
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

--Задание 8
--Разработать скрипт, демонстрирующий использование оператора RETURN. 
PRINT 123
PRINT 456
RETURN
PRINT 789
GO

--Задание 9
BEGIN TRY
	UPDATE dbo.AUDITORIUM 
	SET AUDITORIUM_CAPACITY = 'ёмкость' 
	WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE 'ЛК'
END TRY
BEGIN CATCH
	PRINT 'ERROR_NUMBER()=' + CAST(ERROR_NUMBER() AS VARCHAR)
	PRINT 'ERROR_MESSAGE()=' +ERROR_MESSAGE()
	PRINT 'ERROR_LINE()=' +  CAST(ERROR_LINE() AS VARCHAR)
	PRINT 'ERROR_PROCEDURE()=' +ERROR_PROCEDURE()
	PRINT 'ERROR_SEVERITY()=' +CAST(ERROR_SEVERITY() AS VARCHAR)
	PRINT 'ERROR_STATE()=' + +CAST(ERROR_STATE()AS VARCHAR)
END CATCH
