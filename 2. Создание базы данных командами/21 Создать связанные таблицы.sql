USE Z_MyBase;

CREATE TABLE �������� (
	�����_�������� int NOT NULL PRIMARY KEY,
	������� nvarchar(15) NULL,
	��� nvarchar(15) NULL,
	�������� nvarchar(15) NULL,
	����� nvarchar(30) NULL,
	������� nvarchar(10) NULL
)
CREATE TABLE �������� (
	������� nvarchar(12) NOT NULL PRIMARY KEY,
	�����_������ tinyint NULL,
	�����_������������ tinyint NULL,
	�����_������������ tinyint NULL,
)
CREATE TABLE ������ (
	�������_����� int NOT NULL,
	���������������_������� nvarchar(12) NOT NULL,
	������ tinyint NULL,
	ID_������ int NOT NULL PRIMARY KEY,
	CONSTRAINT FK_�������� FOREIGN KEY (�������_�����) REFERENCES ��������(�����_��������),
	CONSTRAINT FK_�������� FOREIGN KEY (���������������_�������) REFERENCES ��������(�������)
)