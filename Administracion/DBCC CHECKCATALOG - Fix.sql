USE DESARROLLO
GO


------------------------------------------------------------
--DBCC CHECKCATALOG (2000)
------------------------------------------------------------
SELECT ID, COLID, NAME
FROM SYSCOLUMNS
WHERE ID IN (125256247, 277016168, 341732420, 474745044, 895498419, 911498476)
ORDER BY 1,2

select *
from sysindexes
WHERE ID IN (262552269, 1373508222, 1758889583)

------------------------------------------------------------
sp_configure 'allow_updates', 1

reconfigure with override

sp_configure
------------------------------------------------------------
begin tran
delete from SYSCOLUMNS
WHERE ID IN (262552269, 1373508222, 1758889583)
--commit
--rollback

begin tran
delete from sysindexes
WHERE ID IN (262552269, 1373508222, 1758889583)
--commit
--rollback

------------------------------------------------------------
sp_configure 'allow_updates', 0

reconfigure with override

sp_configure

------------------------------------------------------------
DBCC CHECKCATALOG
------------------------------------------------------------