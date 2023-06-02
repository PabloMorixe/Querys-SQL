SELECT	o.name, i.[rows]
FROM	sysobjects o 
	INNER JOIN
        sysindexes i 
ON 	o.id = i.id
WHERE	(o.type = 'u') AND (i.indid = 1)
ORDER BY o.name
