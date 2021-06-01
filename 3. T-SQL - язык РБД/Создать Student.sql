--Задание 1.
USE master;
CREATE database ZINOVICHUNIVER;

USE ZINOVICHUNIVER1;
--Задание 2.
CREATE TABLE STUDENT (
	Student_number int NOT NULL PRIMARY KEY,
	Surname nvarchar(15),
	GroupNumber tinyint NOT NULL CHECK (GroupNumber >=1 AND GroupNumber <=5)
	) ON G1;

--Задание 3.
ALTER TABLE STUDENT ADD POL nchar(1) default 'M' check (POL in ('M', 'F')) NOT NULL; --внести изменения в таблицы
--ALTER TABLE STUDENT DROP CONSTRAINT DF__STUDENT__POL__2A4B4B5E;
--ALTER TABLE STUDENT DROP CONSTRAINT CK__STUDENT__POL__2B3F6F97;
--ALTER TABLE STUDENT DROP Column POL;
ALTER TABLE STUDENT ADD Дата_поступления date; 
ALTER TABLE STUDENT DROP Column Дата_поступления;

--Задание 4.
INSERT INTO STUDENT (Student_number, Surname, GroupNumber)
			   VALUES(193293, 'Зинович', 4),
					 (193294, 'Перкаль', 4),
					 (193254, 'Малиновский', 4),
					 (193266, 'Сычёв', 4);
INSERT INTO  STUDENT (Student_number, Surname, GroupNumber)
				VALUES (193254, 'Малиновский', 4)

--Задание 5.
SELECT * FROM STUDENT; 
SELECT Student_number, Surname FROM STUDENT;
SELECT COUNT(*) FROM STUDENT; 

SELECT Surname ФАМИЛИИ FROM STUDENT WHERE (Surname = 'Зинович' OR Surname = 'Перкаль');
SELECT DISTINCT TOP(2) Student_number, Surname FROM STUDENT ORDER BY Student_number ASC;

--Задание 5.
UPDATE STUDENT  SET GroupNumber = 5;
--UPDATE STUDENT  SET GroupNumber = GroupNumber - 1 WHERE Surname = 'Зинович';
DELETE FROM STUDENT WHERE Student_number = 193254; --53 - затронуто строк 0
SELECT * FROM STUDENT; 

--Задание 6.
SELECT Student_number, Surname FROM STUDENT WHERE Student_number BETWEEN 193266 AND 193294;
SELECT Surname FROM STUDENT WHERE Surname LIKE 'С%' OR Surname LIKE 'П%';
SELECT Surname, GroupNumber FROM STUDENT WHERE GroupNumber In(4,5);

--Задание 7.
CREATE TABLE RESULTS(
		ID int IDENTITY(1,1) PRIMARY KEY, --первое значение и шаг
		STUDENT_NAME nvarchar(15) NOT NULL,
		MARK_OOP real,
		MARK_STP real,
		MARK_DB real,
		AVER_VALUE as (MARK_OOP+MARK_STP+MARK_DB)/3
)
INSERT INTO RESULTS(STUDENT_NAME, MARK_OOP, MARK_STP, MARK_DB)
					VALUES('Зинович', 8, 9, 9),
						  ('Перкаль', 8, 9, 10),
						  ('Сычёв', 8, 9, 10)
SELECT * From RESULTS; 

--Задание 10.
CREATE TABLE STUDENT2 (
	Номер_зачётки int NOT NULL PRIMARY KEY,
	ФИО nvarchar(30) NOT NULL,
	Дата_рождения date,
	Пол nchar(1) default 'F' check (Пол in ('M', 'F')) NOT NULL,
	Дата_поступления date default '01.09.2021')

INSERT INTO STUDENT2(Номер_зачётки, ФИО, Дата_рождения, Пол, Дата_поступления)
	VALUES(121290, 'Зинович', '2002-09-06', 'F', '2019-09-01'),
		(93482, 'Селицкая', '2000-03-25', 'F', '2016-09-01'),
		(234042, 'Зайцева', '1997-11-15', 'F', '2017-09-01'),
		(234044, 'Зайцев', '2001-11-15', 'M', '2017-09-01')

INSERT INTO STUDENT2(Номер_зачётки, ФИО, Дата_рождения, Пол, Дата_поступления)
		VALUES(17980, 'Перкаль', '2002-09-06', 'F', '2020-09-01')

SELECT  DATEPART(DAYOFYEAR, Дата_рождения) FROM STUDENT2 
SELECT  DATEPART(DAYOFYEAR, Дата_поступления) FROM STUDENT2 
SELECT * FROM STUDENT2 
	WHERE Пол = 'F' AND 
		(DATEDIFF(YEAR, Дата_рождения, Дата_поступления) -
		(CASE 
			WHEN DATEPART(DAYOFYEAR, Дата_рождения) > DATEPART(DAYOFYEAR, Дата_поступления) THEN 1 
			ELSE 0 
		END)
		) >=18;