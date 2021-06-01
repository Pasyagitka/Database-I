USE Z_UNIVER;

--������� 1. ������ ������������ ������, ������� ��������� �� ����������, �������������� ���������� �� ������������, 
--� ������������ �������� ���������� ����� "����������" ��� "����������"
SELECT PULPIT.PULPIT_NAME �������, PROFESSION.PROFESSION_NAME �������������
FROM PULPIT, PROFESSION, FACULTY
WHERE FACULTY.FACULTY = PROFESSION.FACULTY AND 
	PULPIT.FACULTY = FACULTY.FACULTY AND 
	PROFESSION.PROFESSION_NAME in (SELECT PROFESSION_NAME FROM PROFESSION WHERE (PROFESSION.PROFESSION_NAME LIKE '%���������%'))

--������� 2
SELECT PULPIT.PULPIT_NAME �������, PROFESSION.PROFESSION_NAME �������������
FROM PULPIT INNER JOIN PROFESSION INNER JOIN FACULTY
ON FACULTY.FACULTY = PROFESSION.FACULTY ON  PULPIT.FACULTY = FACULTY.FACULTY 
WHERE PROFESSION.PROFESSION_NAME in
		(SELECT PROFESSION_NAME FROM PROFESSION WHERE (PROFESSION.PROFESSION_NAME LIKE '%���������%'))

--������� 3
SELECT PULPIT.PULPIT_NAME �������, PROFESSION.PROFESSION_NAME �������������
FROM PULPIT INNER JOIN FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY 
			INNER JOIN PROFESSION ON PULPIT.FACULTY = PROFESSION.FACULTY
				WHERE (PROFESSION.PROFESSION_NAME LIKE '%���������%')

--������� 4, ������������ ������ ��������� ����� ������� ������������ ��� ������� ���� ���������
SELECT * 
FROM AUDITORIUM  A1
WHERE A1.AUDITORIUM_CAPACITY = (SELECT TOP(1) A2.AUDITORIUM_CAPACITY FROM AUDITORIUM A2
	WHERE A2.AUDITORIUM_TYPE=A1.AUDITORIUM_TYPE
	ORDER BY AUDITORIUM_CAPACITY DESC)
	ORDER BY AUDITORIUM_CAPACITY DESC


--������� 5, ������ ����������� ��� ������
SELECT FACULTY.FACULTY_NAME
FROM FACULTY 
WHERE NOT EXISTS (SELECT * FROM PULPIT WHERE PULPIT.FACULTY = FACULTY.FACULTY)

--SELECT * FROM FACULTY FULL OUTER JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY

--������� 6, ������������ ������, ���������� ������� �������� ������, �� �����������, ������� ��������� ����: ����, �� � ����
SELECT TOP(1)
	(SELECT AVG(NOTE) FROM PROGRESS WHERE SUBJECT = '����') ����,
	(SELECT AVG(NOTE) FROM PROGRESS WHERE SUBJECT = '��') ��,
	(SELECT AVG(NOTE) FROM PROGRESS WHERE SUBJECT = '����') ����
FROM PROGRESS

--������� 7
SELECT  * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY > ALL(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM WHERE AUDITORIUM LIKE '3%')

--������� 8
SELECT  * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY > ANY(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM WHERE AUDITORIUM LIKE '3%')

--������� 9
USE Z_MyBase;

SELECT TOP(1)
	(SELECT SUM(�����_������) FROM �������� WHERE ������� = '����' OR ������� = '����������' OR ������� = '��' 	OR ������� = '����������' OR 
	������� = '���' OR ������� = '���' OR ������� = '��' OR ������� = '������' OR ������� = '���������' OR ������� = '���') [����� ����� ����� ������],
	(SELECT SUM(�����_������������) FROM �������� WHERE ������� = '����' OR ������� = '����������' OR ������� = '��' 	OR ������� = '����������' OR 
	������� = '���' OR ������� = '���' OR ������� = '��' OR ������� = '������' OR ������� = '���������' OR ������� = '���') [����� ����� ����� ������������],
	(SELECT SUM(�����_������������) FROM �������� WHERE ������� = '����' OR ������� = '����������' OR ������� = '��' 	OR ������� = '����������' OR 
	������� = '���' OR ������� = '���' OR ������� = '��' OR ������� = '������' OR ������� = '���������' OR ������� = '���') [����� ����� ����� ������������]
FROM ��������

SELECT  * FROM ������
WHERE ������.������ > ALL(SELECT ������ FROM ������ WHERE �������_����� = 100004)

SELECT  * FROM ������
WHERE ������.������ >= ANY(SELECT ������ FROM ������ WHERE �������_����� = 100001)

--������� 10
USE Z_UNIVER;

SELECT STUDENT1.BDAY [���� ��������], STUDENT1.NAME [��� �������� 1], STUDENT2.NAME [��� �������� 2]  
FROM STUDENT STUDENT1, STUDENT STUDENT2
WHERE (STUDENT1.IDSTUDENT <> STUDENT2.IDSTUDENT AND STUDENT1.BDAY = STUDENT2.BDAY)
ORDER BY [��� �������� 1] ASC
