DECLARE @sql VARCHAR(8000)
DECLARE @objtype CHAR(2)
DECLARE @owner SYSNAME
DECLARE @objname SYSNAME
DECLARE @login SYSNAME

SET @login = 'LEDESMA_LAB'

DECLARE ROUTINES CURSOR LOCAL FAST_FORWARD FOR 
SELECT TYPE, USER_NAME(uid), name FROM SYSOBJECTS WHERE TYPE IN ('FN', 'IF', 'TF', 'P') AND NOT NAME LIKE 'DT_%'

OPEN ROUTINES
FETCH NEXT FROM ROUTINES INTO @objtype, @owner, @objname WHILE (@@FETCH_STATUS = 0) 
BEGIN
	IF @objtype In ('IF', 'TF')
		SET @sql = 'GRANT SELECT ON '
	ELSE
		SET @sql = 'GRANT EXECUTE ON '

	SET @sql = @sql + QUOTENAME(DB_NAME()) + '.' + QUOTENAME(@owner) + '.' + QUOTENAME(@objname) + ' TO ' + QUOTENAME(@login)
	EXECUTE(@sql)
	
	FETCH NEXT FROM ROUTINES INTO @objtype, @owner, @objname END

CLOSE ROUTINES
DEALLOCATE ROUTINES
GO