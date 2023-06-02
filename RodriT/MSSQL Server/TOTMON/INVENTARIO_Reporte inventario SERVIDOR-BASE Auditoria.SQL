/*EJECUTARLO EN EL SERVIDOR SSPR17MON-1*/

USE SqlToProd
GO
select distinct InvServ.Servidor,InvServ.IP,InvServ.Ambiente,InvServ.Collation, InvDB.nombre_base from sqltoprod.dbo.sqlserver InvServ
inner join totmon.dbo.dbfiles InvDB
on InvServ.Servidor = InvDB.servidor
where InvDB.nombre_base not in ('master','model','msdb','tempdb')