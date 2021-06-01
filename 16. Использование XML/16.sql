use Z_UNIVER;
go

-- Задание 1.
-- Разработать сценарий создания XML-документа в режиме PATH из таблицы TEACHER для преподавателей кафедры ИСиТ. 
select * from TEACHER where TEACHER.PULPIT = 'ИСиТ'
for xml PATH('TEACHER'), root('TEACHER_LIST');
go

-- Задание 2.
-- Разработать сценарий создания XML-документа в режиме AUTO на основе SELECT-запроса к таблицам AUDITORIUM и AUDITORIUM_TYPE, 
-- который содержит следующие столбцы: наименование аудитории, наименование типа аудитории и вместимость. 
-- Найти только лекционные аудитории. 
select auditorium.auditorium, auditorium_type.auditorium_type, auditorium.auditorium_capaгород
from auditorium inner join auditorium_type
	on auditorium.auditorium_type = auditorium_type.auditorium_type
	where auditorium.auditorium_type like '%ЛК%'
for xml AUTO, root('LECTURE_AUDITORIUMS'), elements;
go

-- Задание 3.
-- Разработать XML-документ, содержащий данные о трех новых учебных дисциплинах, которые следует добавить в таблицу SUBJECT. 
-- Разработать сценарий, извлекающий данные о дисциплинах из XML-документа и добавляющий их в таблицу SUBJECT. 
-- При этом применить системную функцию OPENXML и конструкцию INSERT… SELECT. 
declare @h int = 0, @text varchar(1000) =
	'<?xml version="1.0" encoding="windows-1251"?>
	<Предметы>
		<НовыеПредметы Id="Новый1" Full="Новый1" Pulpit="ИСиТ"/>
		<НовыеПредметы Id="Новый2" Full="Новый2" Pulpit="ИСиТ"/>
		<НовыеПредметы Id="Новый3" Full="Новый3" Pulpit="ИСиТ"/>
	</Предметы>';
exec sp_xml_preparedocument @h output, @text;
select * from openxml(@h, '/Предметы/НовыеПредметы',0)
	with([Id] nvarchar(10), [Full] nvarchar(70), [Pulpit] nvarchar(10))

insert SUBJECT select [Id], [Full], [Pulpit]
	from openxml(@h, '/Предметы/НовыеПредметы',0)
		with([Id] nvarchar(10), [Full] nvarchar(70), [Pulpit] nvarchar(10))

select * from SUBJECT
delete SUBJECT where SUBJECT in('Новый1', 'Новый2', 'Новый3')

exec sp_xml_removedocument @h;
go


-- Задание 4.
-- Используя таблицу STUDENT разработать XML-структуру, содержащую паспортные данные студента: серию и номер паспорта, личный номер, дата выдачи и адрес прописки. 
-- Разработать сценарий, в который включен оператор INSERT, добавляющий строку с XML-столбцом.
-- Включить в этот же сценарий оператор UPDATE, изменяющий столбец INFO у одной строки таблицы STUDENT и оператор SELECT, формирующий результирующий набор,
-- аналогичный представленному на рисунке. В SELECT-запросе использовать методы QUERY и VALUEXML-типа.
delete STUDENT where NAME = 'Зинович Елизавета Игоревна';
select * from STUDENT where NAME = 'Зинович Елизавета Игоревна';

insert STUDENT(IDGROUP, NAME, BDAY, INFO) values
	(4, 'Зинович Елизавета Игоревна', '2002-09-06',
		'<студент>
		<паспорт series="MP" id="7327482" date="14.02.2016" />
		<телефон>5634337</телефон>
			<адрес>
				<страна>Беларусь</страна>
				<город>Минск</город>
				<улица>Свердлова</улица>
				<дом>13</дом>
				<квартира>204</квартира>
			</адрес>
		</студент>');					 												    

update STUDENT set INFO = 
	'<студент>
	<паспорт series="MP" id="7327482" date="01.09.2016" />
	<телефон>5634337</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Минск</город>
			<улица>Свердлова</улица>
			<дом>223</дом>
			<квартира>204</квартира>
		</адрес>
	</студент>'
where STUDENT.INFO.value('(/студент/адрес/дом)[1]','int') = 13;

select NAME, 
	INFO.value('(/студент/паспорт/@series)[1]', 'char(2)') 'паспорт series',
	INFO.value('(/студент/паспорт/@id)[1]', 'varchar(10)') 'паспорт id',
	INFO.query('/студент/адрес') 'адрес'
from  STUDENT where NAME =  'Зинович Елизавета Игоревна';
go

-- Задание 5.
-- Изменить (ALTER TABLE) таблицу STUDENT в базе данных UNIVER таким образом, чтобы значения типизированного столбца с именем INFO 
-- контролировались коллекцией XML-схем (XML SCHEMACOLLECTION), представленной в правой части.  Разработать сценарии, демонстрирующие ввод и 
-- корректировку данных (операторы IN-SERT и UPDATE) в столбец INFO таблицы STUDENT, как содержащие ошибки, так и правильные.
-- Разработать другую XML-схему и добавить ее в коллекцию XML-схем в БД UNIVER.
drop xml schema collection Student
go
create xml schema collection Student as 
'<?xml version="1.0" encoding="windows-1251" ?>
<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name="студент">  
		<xs:complexType>
			<xs:sequence>
				<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
					<xs:complexType>
						<xs:attribute name="series" type="xs:string" use="required" />
						<xs:attribute name="id" type="xs:unsignedInt" use="required"/>
						<xs:attribute name="date"  use="required" >  
							<xs:simpleType> 
								<xs:restriction base ="xs:string">
									<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
								</xs:restriction>
							</xs:simpleType>
						</xs:attribute>
					</xs:complexType> 
				</xs:element>
				<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
				<xs:element name="адрес">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="страна" type="xs:string" />
							<xs:element name="город" type="xs:string" />
							<xs:element name="улица" type="xs:string" />
							<xs:element name="дом" type="xs:string" />
							<xs:element name="квартира" type="xs:string" />
						</xs:sequence>
					</xs:complexType>
				</xs:element>
			</xs:sequence>
		</xs:complexType>
	</xs:element>
</xs:schema>';

alter table STUDENT alter column INFO xml(Student);
insert STUDENT(IDGROUP, NAME, BDAY, INFO) values
	(18,'Первый','01.01.2000',
		'<студент>
			<паспорт series="PM" id="6799765" date="25.10.2011"/>
			<телефон>0000000</телефон>
			<адрес>
				<страна>Беларусь</страна>
				<город>Минск</город>
				<улица>Улица</улица>
				<дом>19</дом>
				<квартира>416</квартира>
			</адрес>
		</студент>');

insert STUDENT(IDGROUP, NAME, BDAY, INFO) values
	(18,'Второй','01.01.2000',
		'<студент>
			<паспорт series="НB" id="6799765" date="25.10.2011"/>
			<телефон>2434353</телефон>
			<адрес>
				<страна>Беларусь</страна>
				<город>Минск</город>
				<улица>Улицаулица</улица>
				<дом>19</дом>
				<квартира>416</квартира>
			</адрес>
		</студент>');

delete STUDENT where NAME = 'Первый'
delete STUDENT where NAME = 'Второй'
select * from STUDENT
go

-- Задание 6.
-- Разработать сценарии, демонстрирующие использование XML для базы данных X_MyBASE. 
use Z_MyBase;
go

select * from Студенты
for xml PATH('Студенты'), root('Студенты');
go

select * from СТУДЕНТЫ;

insert СТУДЕНТЫ(Номер_студента, Фамилия, Имя, Отчество, Адрес, Телефон, Отчет) values
	(100009, 'Студент', 'Студент', 'Студент', 'Адрес' , '5634337',
		'<client>
		<паспорт series="MP" id="1234567" date="01.03.2016" />
		<телефон>1234567</телефон>
			<адрес>
				<страна>Беларусь</страна>
				<город>Минск</город>
				<улица>Улица</улица>
				<дом>11</дом>
				<квартира>12</квартира>
			</адрес>
		</client>');	
go

-- Задание 7*.
-- Разработать SELECT-запрос, формирующий XML-фрагмент такой же структуры, как фрагмент на рисунке ниже, содержащий описание структуры вуза,
-- включающей перечень факультетов, кафедр и преподавателей. Разработать сценарий, демонстрирующий работу SELECT-запроса. 
-- Примечание: использовать подзапросы, режим PATH и ключевое слово TYPE (TYPE указывает на то, что формируемый XML-фрагмент следует рассматривать как вложенный).
use Z_UNIVER;

select rtrim(FACULTY.FACULTY) as '@код',
	(select COUNT(*) from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY) as 'количество_кафедр',
	(select rtrim(PULPIT.PULPIT) as '@код',
	(select rtrim(TEACHER.TEACHER) as 'преподаватели/@код',TEACHER.TEACHER as 'преподаватель'
		from TEACHER where TEACHER.PULPIT = PULPIT.PULPIT
		for xml path(''),type, root('преподаватели'))
	from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY 
		for xml path('кафедра'), type, root('кафедра')) 
from FACULTY
for xml path('факультет'), type, root('университет')
go
