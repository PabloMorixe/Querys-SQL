--Count de logs anteriores a los últimos 6 meses de ejecuciones
SELECT D.name, PL.id, PL.versionid, COUNT(*)
FROM msdb.dbo.sysdtspackagelog PL
INNER JOIN msdb.dbo.sysdtspackages D
ON PL.id=D.id
AND PL.versionid=D.versionid
WHERE starttime < getdate()-180
GROUP BY D.name, PL.id, PL.versionid
ORDER BY COUNT(*) DESC




--DELETE de logs anteriores a los últimos 6 meses de ejecuciones
BEGIN TRAN

--PRIMER TABLA A DEPURAR
DELETE FROM msdb.dbo.sysdtspackagelog
WHERE starttime < getdate()-950 --HASTA LLEGAR A DEJAR 180 DIAS

--SEGUNDA
DELETE FROM msdb.dbo.sysdtssteplog
WHERE starttime < getdate()-950 --HASTA LLEGAR A DEJAR 180 DIAS


COMMIT
