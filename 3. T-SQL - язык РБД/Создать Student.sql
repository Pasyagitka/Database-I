--������� 1.
USE master;
CREATE database ZINOVICHUNIVER;

USE ZINOVICHUNIVER1;
--������� 2.
CREATE TABLE STUDENT (
	Student_number int NOT NULL PRIMARY KEY,
	Surname nvarchar(15),
	GroupNumber tinyint NOT NULL CHECK (GroupNumber >=1 AND GroupNumber <=5)
	) ON G1;

--������� 3.
ALTER TABLE STUDENT ADD POL nchar(1) default 'M' check (POL in ('M', 'F')) NOT NULL; --������ ��������� � �������
--ALTER TABLE STUDENT DROP CONSTRAINT DF__STUDENT__POL__2A4B4B5E;
--ALTER TABLE STUDENT DROP CONSTRAINT CK__STUDENT__POL__2B3F6F97;
--ALTER TABLE STUDENT DROP Column POL;
ALTER TABLE STUDENT ADD ����_����������� date; 
ALTER TABLE STUDENT DROP Column ����_�����������;

--������� 4.
INSERT INTO STUDENT (Student_number, Surname, GroupNumber)
			   VALUES(193293, '�������', 4),
					 (193294, '�������', 4),
					 (193254, '�����������', 4),
					 (193266, '�����', 4);
INSERT INTO  STUDENT (Student_number, Surname, GroupNumber)
				VALUES (193254, '�����������', 4)

--������� 5.
SELECT * FROM STUDENT; 
SELECT Student_number, Surname FROM STUDENT;
SELECT COUNT(*) FROM STUDENT; 

SELECT Surname ������� FROM STUDENT WHERE (Surname = '�������' OR Surname = '�������');
SELECT DISTINCT TOP(2) Student_number, Surname FROM STUDENT ORDER BY Student_number ASC;

--������� 5.
UPDATE STUDENT  SET GroupNumber = 5;
--UPDATE STUDENT  SET GroupNumber = GroupNumber - 1 WHERE Surname = '�������';
DELETE FROM STUDENT WHERE Student_number = 193254; --53 - ��������� ����� 0
SELECT * FROM STUDENT; 

--������� 6.
SELECT Student_number, Surname FROM STUDENT WHERE Student_number BETWEEN 193266 AND 193294;
SELECT Surname FROM STUDENT WHERE Surname LIKE '�%' OR Surname LIKE '�%';
SELECT Surname, GroupNumber FROM STUDENT WHERE GroupNumber In(4,5);

--������� 7.
CREATE TABLE RESULTS(
		ID int IDENTITY(1,1) PRIMARY KEY, --������ �������� � ���
		STUDENT_NAME nvarchar(15) NOT NULL,
		MARK_OOP real,
		MARK_STP real,
		MARK_DB real,
		AVER_VALUE as (MARK_OOP+MARK_STP+MARK_DB)/3
)
INSERT INTO RESULTS(STUDENT_NAME, MARK_OOP, MARK_STP, MARK_DB)
					VALUES('�������', 8, 9, 9),
						  ('�������', 8, 9, 10),
						  ('�����', 8, 9, 10)
SELECT * From RESULTS; 

--������� 10.
CREATE TABLE STUDENT2 (
	�����_������� int NOT NULL PRIMARY KEY,
	��� nvarchar(30) NOT NULL,
	����_�������� date,
	��� nchar(1) default 'F' check (��� in ('M', 'F')) NOT NULL,
	����_����������� date default '01.09.2021')

INSERT INTO STUDENT2(�����_�������, ���, ����_��������, ���, ����_�����������)
	VALUES(121290, '�������', '2002-09-06', 'F', '2019-09-01'),
		(93482, '��������', '2000-03-25', 'F', '2016-09-01'),
		(234042, '�������', '1997-11-15', 'F', '2017-09-01'),
		(234044, '������', '2001-11-15', 'M', '2017-09-01')

INSERT INTO STUDENT2(�����_�������, ���, ����_��������, ���, ����_�����������)
		VALUES(17980, '�������', '2002-09-06', 'F', '2020-09-01')

SELECT  DATEPART(DAYOFYEAR, ����_��������) FROM STUDENT2 
SELECT  DATEPART(DAYOFYEAR, ����_�����������) FROM STUDENT2 
SELECT * FROM STUDENT2 
	WHERE ��� = 'F' AND 
		(DATEDIFF(YEAR, ����_��������, ����_�����������) -
		(CASE 
			WHEN DATEPART(DAYOFYEAR, ����_��������) > DATEPART(DAYOFYEAR, ����_�����������) THEN 1 
			ELSE 0 
		END)
		) >=18;