USE Z_MyBase;
CREATE TABLE ОЦЕНКИ (
	Студент_номер int NOT NULL,
	Экзаменационный_предмет nvarchar(12) NOT NULL,
	Оценка tinyint NULL,
	ID_Оценки int NOT NULL PRIMARY KEY
) 