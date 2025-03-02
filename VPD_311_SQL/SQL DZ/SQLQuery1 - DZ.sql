USE master;
GO

-- Создание базы данных
CREATE DATABASE VPD_311_SQL
ON 
(
	NAME		= VPD_311_SQL,
	FILENAME	= 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\VPD_311_SQL.MDF',
	SIZE        =  8MB,
	MAXSIZE     =  500MB,
	FILEGROWTH  = 8MB
)
LOG ON 
(
	NAME		= VPD_311_SQL_Log,
	FILENAME	= 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\VPD_311_SQL_Log.ldf',
	SIZE        =  8MB,
	MAXSIZE     =  500MB,
	FILEGROWTH  = 8MB
);
GO

USE VPD_311_SQL;
GO

-- Создание таблицы направлений
CREATE TABLE Directions
(
	direction_id  TINYINT  PRIMARY KEY,
	direction_name  NVARCHAR(150) NOT NULL
);

-- Создание таблицы групп
CREATE TABLE Groups
(
	group_id   INT          PRIMARY KEY,
	group_name NVARCHAR(24) NOT NULL,
	direction  TINYINT      NOT NULL,
	CONSTRAINT FK_Groups_Directions FOREIGN KEY (direction) REFERENCES Directions(direction_id)
);

-- Создание таблицы студентов
CREATE TABLE Students
(
	student_id			INT PRIMARY KEY,
	last_name		NVARCHAR(50) NOT NULL,
	first_name		NVARCHAR(50) NOT NULL,
	middle_name		NVARCHAR(50) NULL,
	birth_date		DATE NOT NULL,
	[group]			INT NULL,
	CONSTRAINT FK_Students_Groups FOREIGN KEY ([group]) REFERENCES Groups(group_id)
);

-- Создание таблицы преподавателей
CREATE TABLE Teachers
(
	teacher_id INT PRIMARY KEY,
	last_name NVARCHAR(50) NOT NULL,
	first_name NVARCHAR(50) NOT NULL,
	middle_name NVARCHAR(50) NULL,
	birth_date DATE NOT NULL,
	work_since DATE NOT NULL
);

-- Создание таблицы дисциплин
CREATE TABLE Disciplines
(
	discipline_id   SMALLINT    PRIMARY KEY,
	discipline_name NVARCHAR(150) NOT NULL,
	number_of_lessons  TINYINT NOT NULL
);

-- Создание связующей таблицы обязательных дисциплин
CREATE TABLE RequiredDisciplines
(
	discipline          SMALLINT, 
	required_discipline SMALLINT,
	PRIMARY KEY (discipline, required_discipline),
	CONSTRAINT FK_RD_Discipline_2_Discipline FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id), 
	CONSTRAINT FK_RD_Required_2_Discipline FOREIGN KEY (required_discipline) REFERENCES Disciplines(discipline_id)
);

-- Создание связующей таблицы преподавателей и дисциплин
CREATE TABLE TeachersDisciplinesRelation
(
	teacher INT,
	discipline SMALLINT,
	PRIMARY KEY(teacher, discipline),
	CONSTRAINT FK_TDR_Teachers FOREIGN KEY(teacher) REFERENCES Teachers(teacher_id),
	CONSTRAINT FK_TDR_Disciplines FOREIGN KEY(discipline) REFERENCES Disciplines(discipline_id)
);

-- Создание связующей таблицы дисциплин и направлений
CREATE TABLE DisciplinesDirectionRelation
(
	discipline SMALLINT,
	direction TINYINT,
	PRIMARY KEY (discipline, direction),
	CONSTRAINT FK_DDR_Disciplines FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_DDR_Directions FOREIGN KEY (direction) REFERENCES Directions(direction_id)
);

-- Создание таблицы расписания
CREATE TABLE Schedule
(
	lesson_id    BIGINT   PRIMARY KEY,
	[date]      DATE      NOT NULL,
	[time]      TIME      NOT NULL,
	[group]     INT       NOT NULL,
	discipline  SMALLINT  NOT NULL,
	teacher     INT       NOT NULL,
	[subject]   NVARCHAR(256) NULL,
	spent       BIT       NOT NULL,
	CONSTRAINT FK_Schedule_Groups FOREIGN KEY ([group]) REFERENCES Groups(group_id),
	CONSTRAINT FK_Schedule_Disciplines FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_Schedule_Teachers FOREIGN KEY (teacher) REFERENCES Teachers(teacher_id)
);

-- Создание таблицы оценок
CREATE TABLE Grades
(
	student  INT,
	lesson   BIGINT,
	present  BIT NOT NULL,
	grade_1  TINYINT CONSTRAINT CK_Grades_1 CHECK (grade_1 > 0 AND grade_1 <= 12),
	grade_2  TINYINT CONSTRAINT CK_Grades_2 CHECK (grade_2 > 0 AND grade_2 <= 12),
	PRIMARY KEY (student, lesson),
	CONSTRAINT FK_Grades_Students FOREIGN KEY (student) REFERENCES Students(student_id),
	CONSTRAINT FK_Grades_Schedule FOREIGN KEY (lesson) REFERENCES Schedule(lesson_id)
);

-- Создание таблицы экзаменов
CREATE TABLE Exams
(
	student     INT,
	discipline  SMALLINT,
	grade       TINYINT CONSTRAINT CK_Exams_Grade CHECK (grade > 0 AND grade <= 12),
	PRIMARY KEY (student, discipline),
	CONSTRAINT FK_Exams_Students FOREIGN KEY (student) REFERENCES Students(student_id),
	CONSTRAINT FK_Exams_Disciplines FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id)
);
GO

-- подсчитать количество преподавателей по каждой дисциплине
SELECT 
    d.discipline_name AS Discipline,
    COUNT(tdr.teacher) AS TeacherCount
FROM 
    TeachersDisciplinesRelation tdr
JOIN 
    Disciplines d ON tdr.discipline = d.discipline_id
GROUP BY 
    d.discipline_name;
-- для каждого преподавателя вывести количество дисциплин, которые он может читать
	SELECT 
    t.last_name + ' ' + t.first_name AS TeacherName,
    COUNT(tdr.discipline) AS DisciplineCount
FROM 
    TeachersDisciplinesRelation tdr
JOIN 
    Teachers t ON tdr.teacher = t.teacher_id
GROUP BY 
    t.last_name, t.first_name;