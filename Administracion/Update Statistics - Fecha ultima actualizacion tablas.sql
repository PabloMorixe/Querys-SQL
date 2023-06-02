--Muestra la fecha de �ltima actualizaci�n de estad�sticas de todas las tablas de una BD
SELECT  t.name AS Table_Name, 
		i.name AS Index_Name,
		i.type_desc AS Index_Type,
		STATS_DATE(i.object_id,i.index_id) AS Date_Updated
FROM    sys.indexes i
		JOIN sys.tables t
		ON t.object_id = i.object_id
WHERE   i.type > 0
		AND STATS_DATE(i.object_id,i.index_id) < GETDATE()-15
ORDER BY t.name ASC,
		i.type_desc ASC,
		i.name ASC 