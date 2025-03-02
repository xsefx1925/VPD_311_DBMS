USE master;
GO

-- Создание базы данных
CREATE DATABASE VPD_311_SQL_dz

GO



-- Создание таблицы направлений
CREATE TABLE Directions1
(
	direction_id  TINYINT  PRIMARY KEY,
	direction_name  NVARCHAR(150) NOT NULL
);

-- Создание таблицы групп
CREATE TABLE Groups1
(
	group_id   INT          PRIMARY KEY,
	group_name NVARCHAR(24) NOT NULL,
	direction  TINYINT      NOT NULL,
	CONSTRAINT FK_Groups_Directions FOREIGN KEY (direction) REFERENCES Directions1(direction_id)
);

-- Создание таблицы студентов
CREATE TABLE Students1
(
	student_id			INT PRIMARY KEY,
	last_name		NVARCHAR(50) NOT NULL,
	first_name		NVARCHAR(50) NOT NULL,
	middle_name		NVARCHAR(50) NULL,
	birth_date		DATE NOT NULL,
	[group]			INT NULL,
	CONSTRAINT FK_Students_Groups FOREIGN KEY ([group]) REFERENCES Groups1(group_id)
);

-- Создание таблицы преподавателей
CREATE TABLE Teachers1
(
	teacher_id INT PRIMARY KEY,
	last_name NVARCHAR(50) NOT NULL,
	first_name NVARCHAR(50) NOT NULL,
	middle_name NVARCHAR(50) NULL,
	birth_date DATE NOT NULL,
	work_since DATE NOT NULL
);

-- Создание таблицы дисциплин
CREATE TABLE Disciplines1
(
	discipline_id   SMALLINT    PRIMARY KEY,
	discipline_name NVARCHAR(150) NOT NULL,
	number_of_lessons  TINYINT NOT NULL
);

-- Создание связующей таблицы обязательных дисциплин
CREATE TABLE RequiredDisciplines1
(
	discipline          SMALLINT, 
	required_discipline SMALLINT,
	PRIMARY KEY (discipline, required_discipline),
	CONSTRAINT FK_RD_Discipline_2_Discipline FOREIGN KEY (discipline) REFERENCES Disciplines1(discipline_id), 
	CONSTRAINT FK_RD_Required_2_Discipline FOREIGN KEY (required_discipline) REFERENCES Disciplines1(discipline_id)
);

-- Создание связующей таблицы преподавателей и дисциплин
CREATE TABLE TeachersDisciplinesRelation1
(
	teacher INT,
	discipline SMALLINT,
	PRIMARY KEY(teacher, discipline),
	CONSTRAINT FK_TDR_Teachers FOREIGN KEY(teacher) REFERENCES Teachers1(teacher_id),
	CONSTRAINT FK_TDR_Disciplines FOREIGN KEY(discipline) REFERENCES Disciplines1(discipline_id)
);

-- Создание связующей таблицы дисциплин и направлений
CREATE TABLE DisciplinesDirectionRelation1
(
	discipline SMALLINT,
	direction TINYINT,
	PRIMARY KEY (discipline, direction),
	CONSTRAINT FK_DDR_Disciplines FOREIGN KEY (discipline) REFERENCES Disciplines1(discipline_id),
	CONSTRAINT FK_DDR_Directions FOREIGN KEY (direction) REFERENCES Directions1(direction_id)
);

-- Создание таблицы расписания
CREATE TABLE Schedule1
(
	lesson_id    BIGINT   PRIMARY KEY,
	[date]      DATE      NOT NULL,
	[time]      TIME      NOT NULL,
	[group]     INT       NOT NULL CONSTRAINT FK_Schedule_Groups FOREIGN KEY REFERENCES Groups1(group_id),
	discipline  SMALLINT  NOT NULL CONSTRAINT FK_Schedule_Disciplines FOREIGN KEY REFERENCES Disciplines1(discipline_id),
	teacher     INT       NOT NULL CONSTRAINT FK_Schedule_Teachers FOREIGN KEY REFERENCES Teachers1(teacher_id),
	[subject]   NVARCHAR(256) NULL,
	spent       BIT       NOT NULL
);

-- Создание таблицы оценок
CREATE TABLE Grades1
(
	student  INT CONSTRAINT FK_Grades_Students FOREIGN KEY REFERENCES Students1 (student_id),
	lesson   BIGINT CONSTRAINT FK_Grades_Schedule FOREIGN KEY REFERENCES Schedule1(lesson_id),
	present  BIT NOT NULL,
	grade_1  TINYINT CONSTRAINT CK_Grades_1 CHECK (grade_1 > 0 AND grade_1 <= 12),
	grade_2  TINYINT CONSTRAINT CK_Grades_2 CHECK (grade_2 > 0 AND grade_2 <= 12)
);

-- Создание таблицы экзаменов
CREATE TABLE Exams1
(
	student INT CONSTRAINT FK_Exams_Students FOREIGN KEY REFERENCES Students1 (student_id),
	discipline SMALLINT CONSTRAINT FK_Exams_Disciplines FOREIGN KEY REFERENCES Disciplines1 (discipline_id),
	grade TINYINT CONSTRAINT CK_Exams_Grade CHECK (grade > 0 AND grade <= 12),
	PRIMARY KEY (student, discipline)
);
GO