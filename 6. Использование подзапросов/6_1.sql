USE Z_UNIVER;

--������� 1. ������ ������������ ������, ������� ��������� �� ����������, �������������� ���������� �� ������������, 
--� ������������ �������� ���������� ����� "����������" ��� "����������"
SELECT PULPIT.PULPIT_NAME �������, PROFESSION.PROFESSION_NAME �������������
FROM PULPIT, PROFESSION, FACULTY
WHERE FACULTY.FACULTY = PROFESSION.FACULTY AND 
	PULPIT.FACULTY = FACULTY.FACULTY AND 
	PROFESSION.PROFESSION_NAME in (SELECT PROFESSION_NAME FROM PROFESSION WHERE PROFESSION.PROFESSION_NAME LIKE '%���������[��]%')

--������� 2, ��� �� ��������� ��� ������� � ����������� INNER JOIN ������ FROM �������� �������.
SELECT PULPIT.PULPIT_NAME �������, PROFESSION.PROFESSION_NAME �������������
FROM PULPIT INNER JOIN PROFESSION INNER JOIN FACULTY
ON FACULTY.FACULTY = PROFESSION.FACULTY ON  PULPIT.FACULTY = FACULTY.FACULTY 
AND PROFESSION.PROFESSION_NAME in (SELECT PROFESSION_NAME FROM PROFESSION WHERE PROFESSION.PROFESSION_NAME LIKE '%��������[��]%')

--������� 3, ��� ������������� ����������
SELECT PULPIT.PULPIT_NAME �������, PROFESSION.PROFESSION_NAME �������������
FROM PULPIT INNER JOIN FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY 
			INNER JOIN PROFESSION ON PULPIT.FACULTY = PROFESSION.FACULTY
				WHERE PROFESSION.PROFESSION_NAME LIKE '%���������[��]%'

--������� 4, ������������ ������ ��������� ����� ������� ������������ ��� ������� ���� ���������
SELECT * 
FROM AUDITORIUM  A1
WHERE A1.AUDITORIUM_CAPACITY = (SELECT TOP(1) A2.AUDITORIUM_CAPACITY FROM AUDITORIUM A2
								WHERE A2.AUDITORIUM_TYPE=A1.AUDITORIUM_TYPE ORDER BY AUDITORIUM_CAPACITY DESC)
ORDER BY AUDITORIUM_CAPACITY DESC


--������� 5, ������ ����������� ��� ������
SELECT * FROM FACULTY
SELECT * FROM PULPIT

SELECT FACULTY.FACULTY_NAME
FROM FACULTY 
WHERE NOT EXISTS(SELECT * FROM PULPIT WHERE PULPIT.FACULTY = FACULTY.FACULTY)

--SELECT * FROM FACULTY FULL OUTER JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY

--������� 6, ������������ ������, ���������� ������� �������� ������, �� �����������, ������� ��������� ����: ����, �� � ����
SELECT TOP(1)
	(SELECT AVG(NOTE) FROM PROGRESS WHERE SUBJECT = '����') ����,
	(SELECT AVG(NOTE) FROM PROGRESS WHERE SUBJECT = '��') ��,
	(SELECT AVG(NOTE) FROM PROGRESS WHERE SUBJECT = '����') ����
FROM PROGRESS

--������� 7. ����������� SELECT-������, ��������������� ������� ���������� ALL ��������� � �����������
SELECT  * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY >= ALL(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM WHERE AUDITORIUM LIKE '3%')

--������� 8. ����������� SELECT-������, ��������������� ������� ���������� ANY ��������� � �����������
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

--������� 10. ����� � ������� STUDENT ���������, � ������� ���� �������� � ���� ����
USE Z_UNIVER;

SELECT STUDENT1.BDAY [���� ��������], STUDENT1.NAME [��� �������� 1], STUDENT2.NAME [��� �������� 2]  
FROM STUDENT STUDENT1 JOIN STUDENT STUDENT2
ON (STUDENT1.IDSTUDENT <> STUDENT2.IDSTUDENT AND STUDENT1.BDAY = STUDENT2.BDAY)
ORDER BY [��� �������� 1] ASC

SELECT ISNULL(STUDENT.BDAY, '') [���� ��������], ISNULL(STUDENT.NAME, '') [��� ��������] FROM STUDENT 
WHERE BDAY IN 
	(SELECT STUDENT.BDAY FROM STUDENT GROUP BY STUDENT.BDAY HAVING COUNT(BDAY)>1)
GROUP BY ROLLUP(STUDENT.BDAY, STUDENT.NAME)
