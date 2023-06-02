EXECUTE sp_msforeachdb 
'USE [?];
IF DB_NAME() NOT IN(''master'',''msdb'',''tempdb'',''model'')
   begin 
        SELECT  ''CHECKING STATS FOR '' + DB_NAME() AS ''DATABASE NAME''
        SELECT   OBJECT_NAME(A.OBJECT_ID) AS ''TABLE NAME''
               , A.NAME AS ''INDEX NAME''
               , STATS_DATE(A.OBJECT_ID,A.INDEX_ID) AS ''STATS LAST UPDATED''
          FROM   SYS.INDEXES A
          JOIN   SYS.OBJECTS B
            ON   B.OBJECT_ID = A.OBJECT_ID 
         WHERE   B.IS_MS_SHIPPED = 0
         ORDER   BY OBJECT_NAME(A.OBJECT_ID),A.INDEX_ID
     end'
