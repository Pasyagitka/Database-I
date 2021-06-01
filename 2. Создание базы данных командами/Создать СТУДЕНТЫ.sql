USE Z_MyBase;
CREATE TABLE СТУДЕНТЫ (
	Номер_студента int NOT NULL PRIMARY KEY,
	Фамилия nvarchar(15) NULL,
	Имя nvarchar(15) NULL,
	Отчество nvarchar(15) NULL,
	Адрес nvarchar(30) NULL,
	Телефон nvarchar(10) NULL
)