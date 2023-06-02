USE EFRAMEWORK
go


--1) Sobre las tablas más grandes
--2)	Eliminar indices sin uso
--3) Solucionar missing indexes


--1) 
SELECT	o.name, i.[rows]
FROM	sysobjects o 
	INNER JOIN
        sysindexes i 
ON 	o.id = i.id
WHERE	(o.type = 'u') AND (i.indid = 1)
ORDER BY I.ROWS DESC

/*

SESIONES						291447
AUD_TRANSACCIONES_REALIZADAS	204002
PARAMETROS_VALORES				166121
MENSAJES_RECIPIENTES			161350
PARAMETROS_USUARIO				158628
MENSAJES_DETALLE				140805

*/


--2) Indices sin uso
SELECT   OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
         I.name, S.user_seeks, S.user_scans, S.user_lookups, S.user_updates,
         'DROP INDEX ' + I.name + ' ON ' + OBJECT_NAME(S.[OBJECT_ID])
FROM     SYS.DM_DB_INDEX_USAGE_STATS AS S 
INNER JOIN SYS.indexes AS I
ON S.object_id = I.object_id
AND S.index_id = I.index_id
WHERE    OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1 
--AND S.object_id = OBJECT_ID('MENSAJES_DETALLE')
AND S.database_id = DB_ID()
AND I.type > 1
ORDER BY user_seeks + user_scans + user_lookups ASC


sp_help AUD_TRANSACCIONES_REALIZADAS



--3) Missing indexes
SELECT user_seeks * avg_total_user_cost * ( avg_user_impact * 0.01 )
 AS [index_advantage] ,
 migs.last_user_seek ,
 mid.[statement] AS [Database.Schema.Table] ,
 mid.equality_columns ,
 mid.inequality_columns ,
 mid.included_columns ,
 migs.unique_compiles ,
 migs.user_seeks ,
 migs.avg_total_user_cost ,
 migs.avg_user_impact
FROM sys.dm_db_missing_index_group_stats AS migs WITH ( NOLOCK )
 INNER JOIN sys.dm_db_missing_index_groups AS mig WITH ( NOLOCK )
 ON migs.group_handle = mig.index_group_handle
 INNER JOIN sys.dm_db_missing_index_details AS mid WITH ( NOLOCK )
 ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID()
ORDER BY index_advantage DESC ;













SELECT *
FROM SYS.sql_modules
WHERE definition LIKE '%with%index%'




SELECT *
FROM USUARIOS