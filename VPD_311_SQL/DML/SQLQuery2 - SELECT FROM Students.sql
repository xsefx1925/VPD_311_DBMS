eleUSE VPD_311_Import;

SELECT 
	last_name	AS N'�������',
	first_name  AS N'���',
	middle_name  AS  N'��������',
	birth_date  AS  N'���� ��������',
	DATEDIFF(DAY, birth_date, GETDATE())/365 AS N'�������',
	group_name     AS  N'������',
	direction_name     AS  N'����������� ��������'
FROM Students, Groups, Directions

WHERE [group] = group_id
AND direction = direction_id
--AND direction_name LIKE  N'����������%'
--ORDER BY last_name
--ORDER BY birth_date DESC --Descending(�� ��������)
--ASC -- Ascending (�� �����������)
ORDER BY N'�������' DESC
;