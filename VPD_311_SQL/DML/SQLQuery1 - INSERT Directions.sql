USE VPD_311_SQL;
GO

INSERT Directions
		(direction_id, direction_name)
VALUES  (1,		N'���������� ������������ �����������'),
		(2,		N'������� ���������� � ��������� �����������������'),
		(3,		N'������������ ������� � ������')
;
GO

SELECT * FROM Directions;