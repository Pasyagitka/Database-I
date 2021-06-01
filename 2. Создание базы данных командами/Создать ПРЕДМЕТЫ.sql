USE Z_MyBase;
CREATE TABLE ПРЕДМЕТЫ (
	Предмет nvarchar(12) NOT NULL PRIMARY KEY,
	Объём_лекций tinyint NULL,
	Объём_лабораторных tinyint NULL,
	Объём_практических tinyint NULL,
)