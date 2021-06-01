USE MASTER;
GO 
CREATE DATABASE Z_UNIVER
ON PRIMARY( 
	name = N'Z_UNIVER_mdf', 
	filename = N'H:\4 семестр\БД\4. Настройка БД\UNIVER\Z_UNIVER.mdf', 
	size = 5MB, maxsize=10MB, filegrowth=1MB),
	( 
	name = N'Z_UNIVER_ndf', 
	filename = N'H:\4 семестр\БД\4. Настройка БД\UNIVER\Z_UNIVER.ndf', 
    size = 5MB, maxsize=10MB, filegrowth=10%
),
filegroup G1( 
	name = N'Z_UNIVER11_ndf', 
	filename = N'H:\4 семестр\БД\4. Настройка БД\UNIVER\Z_UNIVER11.ndf', 
	size = 10MB, maxsize=15MB, filegrowth=1MB), 
	(
	name = N'Z_UNIVE12_ndf', 
	filename = N'H:\4 семестр\БД\4. Настройка БД\UNIVER\Z_UNIVER12.ndf', 
	size = 2MB, maxsize=5MB, filegrowth=1MB
),
filegroup G2( 
	name = N'Z_UNIVER21_ndf', 
	filename = N'H:\4 семестр\БД\4. Настройка БД\UNIVER\Z_UNIVER21.ndf', 
    size = 5MB, maxsize=10MB, filegrowth=1MB), 
	(	
	name = N'Z_UNIVER22_ndf', 
	filename = N'H:\4 семестр\БД\4. Настройка БД\UNIVER\Z_UNIVER22.ndf', 
    size = 2MB, maxsize=5MB, filegrowth=1MB
)
LOG ON ( 
	name = N'Z_UNIVER_log', 
	filename = N'H:\4 семестр\БД\4. Настройка БД\UNIVER\Z_UNIVER.ldf',       
    size=5MB,  maxsize=UNLIMITED, filegrowth=1MB
)