USE Z_UNIVER;

--Задание 1. Список наименований кафедр, которые находятся на факультете, обеспечивающем подготовку по специальноти, 
--в наименовании которого содержится слово "технология" или "технологии"
SELECT PULPIT.PULPIT_NAME Кафедры, PROFESSION.PROFESSION_NAME Специальность
FROM PULPIT, PROFESSION, FACULTY
WHERE FACULTY.FACULTY = PROFESSION.FACULTY AND 
	PULPIT.FACULTY = FACULTY.FACULTY AND 
	PROFESSION.PROFESSION_NAME in (SELECT PROFESSION_NAME FROM PROFESSION WHERE PROFESSION.PROFESSION_NAME LIKE '%технологи[яи]%')

--Задание 2, тот же подзапрос был записан в конструкции INNER JOIN секции FROM внешнего запроса.
SELECT PULPIT.PULPIT_NAME Кафедры, PROFESSION.PROFESSION_NAME Специальность
FROM PULPIT INNER JOIN PROFESSION INNER JOIN FACULTY
ON FACULTY.FACULTY = PROFESSION.FACULTY ON  PULPIT.FACULTY = FACULTY.FACULTY 
AND PROFESSION.PROFESSION_NAME in (SELECT PROFESSION_NAME FROM PROFESSION WHERE PROFESSION.PROFESSION_NAME LIKE '%технолог[яи]%')

--Задание 3, без использования подзапроса
SELECT PULPIT.PULPIT_NAME Кафедры, PROFESSION.PROFESSION_NAME Специальность
FROM PULPIT INNER JOIN FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY 
			INNER JOIN PROFESSION ON PULPIT.FACULTY = PROFESSION.FACULTY
				WHERE PROFESSION.PROFESSION_NAME LIKE '%технологи[яи]%'

--Задание 4, сформировать список аудиторий самых больших вместимостей для каждого типа аудитории
SELECT * 
FROM AUDITORIUM  A1
WHERE A1.AUDITORIUM_CAPACITY = (SELECT TOP(1) A2.AUDITORIUM_CAPACITY FROM AUDITORIUM A2
								WHERE A2.AUDITORIUM_TYPE=A1.AUDITORIUM_TYPE ORDER BY AUDITORIUM_CAPACITY DESC)
ORDER BY AUDITORIUM_CAPACITY DESC


--Задание 5, список факультетов без кафедр
SELECT * FROM FACULTY
SELECT * FROM PULPIT

SELECT FACULTY.FACULTY_NAME
FROM FACULTY 
WHERE NOT EXISTS(SELECT * FROM PULPIT WHERE PULPIT.FACULTY = FACULTY.FACULTY)

--SELECT * FROM FACULTY FULL OUTER JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY

--Задание 6, сформировать строку, содержащую средние значения оценок, по дисциплинам, имеющим следующие коды: ОАиП, БД и СУБД
SELECT TOP(1)
	(SELECT AVG(NOTE) FROM PROGRESS WHERE SUBJECT = 'ОАиП') ОАиП,
	(SELECT AVG(NOTE) FROM PROGRESS WHERE SUBJECT = 'БД') БД,
	(SELECT AVG(NOTE) FROM PROGRESS WHERE SUBJECT = 'СУБД') СУБД
FROM PROGRESS

--Задание 7. Разработать SELECT-запрос, демонстрирующий принцип применения ALL совместно с подзапросом
SELECT  * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY >= ALL(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM WHERE AUDITORIUM LIKE '3%')

--Задание 8. Разработать SELECT-запрос, демонстрирующий принцип применения ANY совместно с подзапросом
SELECT  * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY > ANY(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM WHERE AUDITORIUM LIKE '3%')

--Задание 9
USE Z_MyBase;

SELECT TOP(1)
	(SELECT SUM(Объём_лекций) FROM ПРЕДМЕТЫ WHERE Предмет = 'КГИГ' OR Предмет = 'Математика' OR Предмет = 'БД' 	OR Предмет = 'Английский' OR 
	Предмет = 'ООП' OR Предмет = 'СТП' OR Предмет = 'МП' OR Предмет = 'Физика' OR Предмет = 'Экономика' OR Предмет = 'ОАП') [Общее число часов лекций],
	(SELECT SUM(Объём_лабораторных) FROM ПРЕДМЕТЫ WHERE Предмет = 'КГИГ' OR Предмет = 'Математика' OR Предмет = 'БД' 	OR Предмет = 'Английский' OR 
	Предмет = 'ООП' OR Предмет = 'СТП' OR Предмет = 'МП' OR Предмет = 'Физика' OR Предмет = 'Экономика' OR Предмет = 'ОАП') [Общее число часов лабораторных],
	(SELECT SUM(Объём_практических) FROM ПРЕДМЕТЫ WHERE Предмет = 'КГИГ' OR Предмет = 'Математика' OR Предмет = 'БД' 	OR Предмет = 'Английский' OR 
	Предмет = 'ООП' OR Предмет = 'СТП' OR Предмет = 'МП' OR Предмет = 'Физика' OR Предмет = 'Экономика' OR Предмет = 'ОАП') [Общее число часов практических]
FROM ПРЕДМЕТЫ

SELECT  * FROM ОЦЕНКИ
WHERE ОЦЕНКИ.Оценка > ALL(SELECT Оценка FROM ОЦЕНКИ WHERE Студент_номер = 100004)

SELECT  * FROM ОЦЕНКИ
WHERE ОЦЕНКИ.Оценка >= ANY(SELECT Оценка FROM ОЦЕНКИ WHERE Студент_номер = 100001)

--Задание 10. Найти в таблице STUDENT студентов, у которых день рождения в один день
USE Z_UNIVER;

SELECT STUDENT1.BDAY [Дата рождения], STUDENT1.NAME [Имя студента 1], STUDENT2.NAME [Имя студента 2]  
FROM STUDENT STUDENT1 JOIN STUDENT STUDENT2
ON (STUDENT1.IDSTUDENT <> STUDENT2.IDSTUDENT AND STUDENT1.BDAY = STUDENT2.BDAY)
ORDER BY [Имя студента 1] ASC

SELECT ISNULL(STUDENT.BDAY, '') [Дата рождения], ISNULL(STUDENT.NAME, '') [Имя студента] FROM STUDENT 
WHERE BDAY IN 
	(SELECT STUDENT.BDAY FROM STUDENT GROUP BY STUDENT.BDAY HAVING COUNT(BDAY)>1)
GROUP BY ROLLUP(STUDENT.BDAY, STUDENT.NAME)
