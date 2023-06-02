----------------------------------------------
--Muestra Fragmentacion en todos los indices de la BD
----------------------------------------------
USE EFRAMEWORK
DBCC SHOWCONTIG WITH TABLERESULTS, ALL_INDEXES




----------------------------------------------
--REINDEXACION
----------------------------------------------
DBCC DBREINDEX ('NONMBRE_TABLA', '[NOMBE_INDICE]', 80)




----------------------------------------------
--DEFRAGMENTACION
----------------------------------------------
DBCC INDEXDEFRAG('NOMBRE_BASE', 'NOMBRE_TABLA', 'NOMBRE_INDICE')




----------------------------------------------
--REINDEXACION PARA TODAS LAS TABLAS
--DE LA BD CON FRAGMENTACION > 30%
----------------------------------------------
SET NOCOUNT ON
DECLARE @tablename VARCHAR (128)
DECLARE @execstr   VARCHAR (255)
DECLARE @objectid  INT
DECLARE @indexid   INT
DECLARE @indexname   VARCHAR (255)
DECLARE @frag      DECIMAL
DECLARE @maxfrag   DECIMAL

-- Decide on the maximum fragmentation to allow
SELECT @maxfrag = 30.0

-- Declare cursor
DECLARE tables CURSOR FOR
   SELECT TABLE_NAME
   FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_TYPE = 'BASE TABLE'

-- Create the table
CREATE TABLE #fraglist (
   ObjectName CHAR (255),
   ObjectId INT,
   IndexName CHAR (255),
   IndexId INT,
   Lvl INT,
   CountPages INT,
   CountRows INT,
   MinRecSize INT,
   MaxRecSize INT,
   AvgRecSize INT,
   ForRecCount INT,
   Extents INT,
   ExtentSwitches INT,
   AvgFreeBytes INT,
   AvgPageDensity INT,
   ScanDensity DECIMAL,
   BestCount INT,
   ActualCount INT,
   LogicalFrag DECIMAL,
   ExtentFrag DECIMAL)

-- Open the cursor
OPEN tables

-- Loop through all the tables in the database
FETCH NEXT
   FROM tables
   INTO @tablename

WHILE @@FETCH_STATUS = 0
BEGIN
-- Do the showcontig of all indexes of the table
   INSERT INTO #fraglist 
   EXEC ('DBCC SHOWCONTIG (''' + @tablename + ''') 
      WITH FAST, TABLERESULTS, ALL_INDEXES, NO_INFOMSGS')
   FETCH NEXT
      FROM tables
      INTO @tablename
END



-- Close and deallocate the cursor
CLOSE tables
DEALLOCATE tables

-- Declare cursor for list of indexes to be defragged
DECLARE indexes CURSOR FOR
   SELECT ObjectName, ObjectId,IndexName,IndexId,LogicalFrag
   FROM #fraglist
   WHERE LogicalFrag >= 30.0
     -- AND INDEXPROPERTY (ObjectId, IndexId, 'IndexDepth') > 0

-- Open the cursor
OPEN indexes

-- loop through the indexes
FETCH NEXT
   FROM indexes
   INTO @tablename, @objectid, @indexname,@indexid, @frag

WHILE @@FETCH_STATUS = 0
BEGIN
  PRINT 'Executing DBCC DBREINDEX '+'(' + RTRIM(@tablename)+')' 
	
EXEC ('DBCC DBREINDEX (''' + @tablename + ''')')

--   SELECT @execstr = 'DBCC DBREINDEX('+'@tablename)'
--   EXEC (@execstr)


   FETCH NEXT
      FROM indexes
   INTO @tablename, @objectid, @indexname,@indexid, @frag

END	

-- Close and deallocate the cursor
CLOSE indexes
DEALLOCATE indexes

-- Delete the temporary table
--DROP TABLE #fraglist
SELECT ObjectName, ObjectId, Indexname,IndexId,LogicalFrag  FROM #fraglist
WHERE LogicalFrag >= 30.0 --AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0


GO


DROP TABLE #fraglist