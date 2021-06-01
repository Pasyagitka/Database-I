USE Z_UNIVER;
GO

--Задание 1
CREATE VIEW [Преподаватель] 
AS SELECT TEACHER Код, TEACHER_NAME [Имя преподавателя], GENDER Пол, PULPIT [Код кафедры] FROM TEACHER;
GO

SELECT * FROM Преподаватель;
GO

--Задание 2 объяснть невозможность выполнения INSERT
CREATE VIEW [Количество кафедр]
AS SELECT FACULTY.FACULTY_NAME Факультет, COUNT(*) [Количество кафедр]
FROM FACULTY INNER JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
GROUP BY FACULTY.FACULTY_NAME
GO

SELECT * FROM [Количество кафедр];
GO

--Задание 3, должно отображать только лекционные аудитории, допускать выполнение оператора INSERT, UPDATE и DELETE.
CREATE VIEW [Аудитории]
AS SELECT AUDITORIUM.AUDITORIUM Код, AUDITORIUM.AUDITORIUM_TYPE [Тип аудитории]
FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE 'ЛК%';
GO

INSERT [Аудитории] 	VALUES('200-3в', 'ЛК');
SELECT * FROM [Аудитории]
GO

--Задание 4, отображать только лекционные аудитории
CREATE VIEW [Лекционные аудитории]
AS SELECT AUDITORIUM.AUDITORIUM Код, AUDITORIUM.AUDITORIUM_TYPE	[Тип аудитории]
FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE 'ЛК' WITH CHECK OPTION;
GO

INSERT [Лекционные аудитории] 	VALUES('200-3a', 'ЛК');
INSERT [Лекционные аудитории] 	VALUES('310a-1', 'ЛБ-К');

SELECT * FROM [Лекционные аудитории]
GO

--Задание 5
--отображать все дисциплины в алфавитном порядке, использовать TOP, ORDER
CREATE VIEW [Дисциплины]
AS SELECT TOP(30) SUBJECT[Код], SUBJECT_NAME[Наименование дисциплины], PULPIT[Код кафедры]
FROM SUBJECT 
ORDER BY SUBJECT;
GO

SELECT * FROM [Дисциплины]
GO

--Задание 6
--заменить представление Количество_кафедр, созданное в задании 2 так, чтобы оно было привязано к базовым таблицам. 
--продемонстрировать свойство привязанности представления к базовым таблицам
ALTER VIEW dbo.[Количество кафедр] WITH SCHEMABINDING
AS SELECT FACULTY_NAME Факультет, COUNT(*) [Количество кафедр]
FROM dbo.FACULTY fk JOIN dbo.PULPIT pt ON fk.FACULTY = pt.FACULTY
GROUP BY fk.FACULTY_NAME;
GO
SELECT * FROM [Количество кафедр];
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

--Задание 8
SELECT * FROM TIMETABLE

SELECT TEACHER, LESSON AS Пара, isnull(пн, '')Понедельник, isnull(вт, '')Вторник, isnull(ср, '')Среда, isnull(чт, '')Четверг, isnull(пт, '')Пятница
FROM 
(SELECT SUBJECT+'группа '+CAST(IDGROUP AS nvarchar)+'   '+AUDITORIUM [Предмет], WEEKSDAY, TEACHER, LESSON FROM TIMETABLE) s
PIVOT(MAX(Предмет) FOR WEEKSDAY IN (пн, вт, ср, чт, пт)) d
GROUP BY TEACHER, LESSON, пн, вт, ср, чт, пт 
GO

--Задание 7
USE Z_MyBase;
GO

CREATE VIEW [Информация о студентах] 
AS SELECT Фамилия+' '+Имя+' '+Отчество [ФИО], Адрес, Телефон[Контактный телефон] FROM СТУДЕНТЫ;
GO
SELECT * FROM [Информация о студентах]
GO

CREATE VIEW [Информация об оценках]
AS
SELECT TOP(10) ОЦЕНКИ.Экзаменационный_предмет [Предмет],
	MAX(Оценка) [Максимальная],
	MIN(Оценка) [Минимальная],
	AVG(Оценка) [Средняя],
	COUNT(*) [Общее количество]
FROM ОЦЕНКИ 
	GROUP BY ОЦЕНКИ.Экзаменационный_предмет
	ORDER BY ОЦЕНКИ.Экзаменационный_предмет ASC
GO

SELECT * FROM [Информация об оценках]
GO

CREATE VIEW [Успеваемость]
AS
SELECT isnull(СТУДЕНТЫ.Фамилия, 'Итого') Фамилия, isnull(ОЦЕНКИ.Экзаменационный_предмет, 'Итого') Дисциплина, ROUND(AVG(CAST(ОЦЕНКИ.Оценка AS FLOAT(4))), 2) [Средняя оценка]
FROM ОЦЕНКИ INNER JOIN СТУДЕНТЫ ON ОЦЕНКИ.Студент_номер = СТУДЕНТЫ.Номер_студента
GROUP BY ROLLUP(СТУДЕНТЫ.Фамилия, ОЦЕНКИ.Экзаменационный_предмет)
GO

SELECT * FROM [Успеваемость];
GO

SELECT * FROM [Информация о студентах];
SELECT * FROM [Информация об оценках];
SELECT * FROM [Успеваемость];
GO
