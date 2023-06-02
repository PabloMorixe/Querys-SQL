SELECT
    db.name AS DBName,
    type_desc AS FileType,
    Physical_Name AS Location,
	mf.size/1024 as SizeMB 
FROM
    sys.master_files mf
INNER JOIN 
    sys.databases db ON db.database_id = mf.database_id and db.database_id>5 and db.name <> 'SQLMant'