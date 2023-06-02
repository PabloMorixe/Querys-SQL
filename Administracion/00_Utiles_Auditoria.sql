 
 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Consulta de Logins de la instancia
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT status,updatedate,accdate,name,password,denylogin,hasaccess,isntname,isntgroup,isntuser,sysadmin,securityadmin,serveradmin,setupadmin,processadmin,diskadmin,dbcreator,bulkadmin,loginname  FROM syslogins

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listado de usuarios con permisos sobre la base de datos master
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT name FROM sysusers WHERE islogin=1 AND hasdbaccess=1

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar caracteristicas del motor 
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT @@servername

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Buscar version del motor
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT @@version

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listado Bases de datos 
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT sysdatabases.name dbname,filename FROM sysdatabases sysdatabases LEFT JOIN syslogins syslogins ON sysdatabases.sid=syslogins.sid

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Configuraciones del sistema 
 ------------------------------------------------------------------------------------------------------------------------------------------------------

exec sp_configure 'show advanced options','1'"
RECONFIGURE"
exec sp_configure " -s "|" -w 65000 -h -O -o Results_MSSQL_%COMPUTERNAME%\09_%COMPUTERNAME%_parameters.txt

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Null Passwords 
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT name  FROM syslogins WHERE password  is NULL

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar permisos en tablas
 ------------------------------------------------------------------------------------------------------------------------------------------------------

exec sp_table_privileges 'BAJADAS_REMITOS'

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar linked servers
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT SRV_NAME = srvname,SRV_PROVIDERNAME = providername FROM sysservers

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar jobs del agente sql
 ------------------------------------------------------------------------------------------------------------------------------------------------------

exec msdb.dbo.sp_help_job

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar atributos del agente sql
 ------------------------------------------------------------------------------------------------------------------------------------------------------

exec msdb.dbo.sp_get_sqlagent_properties

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar usuarios de la base msdb
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT name FROM msdb.dbo.sysusers WHERE islogin=1 AND hasdbaccess=1

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar roles asignados a usuarios de la base msdb
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DbRole = g.name,MemberName = u.name FROM msdb.dbo.sysusers u, msdb.dbo.sysusers g, msdb.dbo.sysmembers m WHERE g.uid = m.groupuid AND g.issqlrole = 1 AND u.uid = m.memberuid ORDER BY 1, 2

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Categoria: Captura de datos de bases a analizar (incluyendo las bases
 --
 -------------------------------------------------------------------------------------------------------------------------------

 ----------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listado de usuarios con permisos sobre la base de datos analizada
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT name FROM LOGISTICA.dbo.sysusers WHERE islogin=1 AND hasdbaccess=1

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Consulta de Roles de base de datos asociados a los usuarios
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DbRole = g.name,MemberName = u.name FROM LOGISTICA.dbo.sysusers u, LOGISTICA.dbo.sysusers g, LOGISTICA.dbo.sysmembers m WHERE g.uid = m.groupuid AND g.issqlrole = 1 AND u.uid = m.memberuid ORDER BY 1, 2

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar permisos en tablas
 ------------------------------------------------------------------------------------------------------------------------------------------------------

exec sp_table_privileges 'dbo.ATRIBUTOS_UNIDAD'

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar permisos en objetos
 ------------------------------------------------------------------------------------------------------------------------------------------------------

exec sp_helprotect

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar solo cuentas de mssql y politica de password
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT name,is_disabled,create_date,modify_date,credential_id,is_policy_checked,is_expiration_checked FROM sys.sql_logins

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Objetivo : Listar configuraci�n de auditor�a
 ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM sys.server_audits AS a JOIN sys.database_audit_specifications AS s ON a.audit_guid = s.audit_guid JOIN sys.database_audit_specification_details AS d ON s.database_specification_id = d.database_specification_id WHERE a.is_state_enabled = 1 AND s.is_state_enabled = 1






































































































































































































































































































