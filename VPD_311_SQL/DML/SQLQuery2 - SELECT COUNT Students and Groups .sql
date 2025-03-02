USE VPD_311_Import;
GO

SELECT
	direction_name AS N'����������� ��������',
	COUNT(group_id) AS N'���������� �����'
FROM Groups, Directions
WHERE direction = direction_id
GROUP BY direction_name
ORDER BY N'���������� �����'
;

SELECT 
		[����������� ��������] = direction_name,
		[���������� ���������] = COUNT(stud_id)
FROM Students, Groups, Directions
WHERE [group] = group_id
AND direction = direction_id
GROUP BY direction_name
;
SELECT
		[����������� ��������] = direction_name,
		[���������� �����] = SUM(group_id),
		[���������� ���������] = COUNT(stud_id)
FROM	Students, Groups, Directions
WHERE	[group] = group_id
AND		direction = direction_id
GROUP BY direction_name, group_id
;