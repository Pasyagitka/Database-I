USE Z_MyBase;

CREATE TABLE СТУДЕНТЫ (
	Номер_студента int NOT NULL PRIMARY KEY,
	Фамилия nvarchar(15) NULL,
	Имя nvarchar(15) NULL,
	Отчество nvarchar(15) NULL,
	Адрес nvarchar(30) NULL,
	Телефон nvarchar(10) NULL
)
CREATE TABLE ПРЕДМЕТЫ (
	Предмет nvarchar(12) NOT NULL PRIMARY KEY,
	Объём_лекций tinyint NULL,
	Объём_лабораторных tinyint NULL,
	Объём_практических tinyint NULL,
)
CREATE TABLE ОЦЕНКИ (
	Студент_номер int NOT NULL,
	Экзаменационный_предмет nvarchar(12) NOT NULL,
	Оценка tinyint NULL,
	ID_Оценки int NOT NULL PRIMARY KEY,
	CONSTRAINT FK_СТУДЕНТЫ FOREIGN KEY (Студент_номер) REFERENCES СТУДЕНТЫ(Номер_студента),
	CONSTRAINT FK_ПРЕДМЕТЫ FOREIGN KEY (Экзаменационный_предмет) REFERENCES ПРЕДМЕТЫ(Предмет)
)