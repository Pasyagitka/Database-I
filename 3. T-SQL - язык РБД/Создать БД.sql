USE master;
CREATE database ZINOVICHUNIVER1
ON PRIMARY
	(name = N'ZINOVICHUNIVER_mdf', filename = N'E:\4 �������\��\3. T-SQL - ���� ���\ZINOVICHUNIVER.mdf', 
	size = 5MB, maxsize=10MB, filegrowth=1MB),
FILEGROUP G1 
	(name = N'ZINOVICHUNIVER_ndf', filename = N'E:\4 �������\��\3. T-SQL - ���� ���\ZINOVICHUNIVER.ndf', 
	size = 5MB, maxsize=10MB, filegrowth=1MB)
LOG ON 
	(name = N'Z_UNIVER_log', filename = N'E:\4 �������\��\3. T-SQL - ���� ���\ZINOVICHUNIVER.ldf',       
	size=5MB,  maxsize=UNLIMITED, filegrowth=1MB)