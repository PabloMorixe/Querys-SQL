--------------------------------------------------------------------------------------
--The hypothetical indexes created by the Index Tuning Wizard 
--start with a name of "hind_%" and should not exist after the tuning 
--has finished; they should all be removed. You can run the following 
--script from the SQL Server Query Analyzer to remove any such 
--indexes that may exist. You must log in by using an account that 
--has either sysadmin or db_owner permissions, or is the owner of 
--the object on which these statistics were created. For example: 
--------------------------------------------------------------------------------------
--Referencia: http://support.microsoft.com/kb/293177/en-us
--------------------------------------------------------------------------------------


DECLARE @strSQL nvarchar(1024) 
DECLARE @objid int 
DECLARE @indid tinyint 
DECLARE ITW_Stats CURSOR FOR SELECT id, indid FROM sysindexes WHERE name LIKE 'hind_%' ORDER BY name 
OPEN ITW_Stats 
FETCH NEXT FROM ITW_Stats INTO @objid, @indid 
WHILE (@@FETCH_STATUS <> -1) 
BEGIN 
SELECT @strSQL = (SELECT case when INDEXPROPERTY(i.id, i.name, 'IsStatistics') = 1 then 'drop statistics [' else 'drop index [' end + OBJECT_NAME(i.id) + '].[' + i.name + ']' 
FROM sysindexes i join sysobjects o on i.id = o.id 
WHERE i.id = @objid and i.indid = @indid AND 
(INDEXPROPERTY(i.id, i.name, 'IsHypothetical') = 1 OR
(INDEXPROPERTY(i.id, i.name, 'IsStatistics') = 1 AND 
INDEXPROPERTY(i.id, i.name, 'IsAutoStatistics') = 0))) 
EXEC(@strSQL) 
FETCH NEXT FROM ITW_Stats INTO @objid, @indid
END
CLOSE ITW_Stats 
DEALLOCATE ITW_Stats
