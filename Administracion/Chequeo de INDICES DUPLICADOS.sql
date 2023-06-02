USE base_de_datos
GO

------------------------------------------------------------------------
--  Name   :  FindDuplicateIndexes.sql  
--  Author :  Jeff Weisbecker  December 4, 2003
--  RDBMS  :  SQL Server 2000 and 7.0
--  Desc   :  This SQL statement will find duplicate indexes on tables.
--            
------------------------------------------------------------------------
SELECT  OBJECT_NAME(i1.id)     AS  'Table',
        i1.name                AS  'Index',
        i2.name                AS  'Duplicate Index'
FROM sysindexes    i1,
     sysindexes    i2
WHERE i1.indid NOT IN (0,255)
  AND i2.indid NOT IN (0,255)
  AND INDEXPROPERTY(i1.id, i1.name, 'IsStatistics') = 0
  AND INDEXPROPERTY(i2.id, i2.name, 'IsStatistics') = 0
  AND i1.id    = i2.id
  AND i1.indid < i2.indid
  AND NOT EXISTS (SELECT '1'
                  FROM sysindexkeys  ik1,
                       sysindexkeys  ik2
                  WHERE ik1.id     = i1.id
                    AND ik1.id     = ik2.id
                    AND ik1.indid  = i1.indid
                    AND ik2.indid  = i2.indid
                    AND ik1.keyno  = ik2.keyno
                    AND ik1.colid != ik2.colid)
  ----------------------------------------------------------------------
  --  Comment out the following condition if you would like to consider
  --  indexes with a different number of columns as duplicates as long
  --  as the larger index shares the same starting sequence as the other
  --  index.
  ----------------------------------------------------------------------
  AND 0 =        (SELECT  MAX(ik1.keyno) - MAX(ik2.keyno)
                  FROM sysindexkeys  ik1,
                       sysindexkeys  ik2
                  WHERE ik1.id     = i1.id
                    AND ik1.id     = ik2.id
                    AND ik1.indid  = i1.indid
                    AND ik2.indid  = i2.indid)