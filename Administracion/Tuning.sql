--Estadisticas
SET STATISTICS IO ON
SET STATISTICS TIME ON
SET STATISTICS PROFILE ON


-- Actualización de estadísticas
UPDATE STATISTICS [TABLA] WITH FULLSCAN


--Limpieza de cache (Buffer)
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE

--COLUMN STATISTICS para la tabla dada
sp_helpstats TRAZAS

--Indices para la tabla dada
sp_helpindex TRAZAS

--Space used por tabla
sp_spaceused TRAZAS, True


--Muestra estadísticas para todas las tablas de una BD
sp_msforeachtable 'sp_autostats ''?'''


--Checkpoint + limpieza de chaches
CHECKPOINT
GO
DBCC DROPCLEANBUFFERS