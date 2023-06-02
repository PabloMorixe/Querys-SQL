select 
	u.name as 'Role',
	o.name as 'Nombre Objeto',
	'Object Type'=
		case 	
			when o.xtype='FN' then 'Scalar function'
			when o.xtype='IF' then 'Inlined table-function'
			when o.xtype='P' then 'Stored procedure'
			when o.xtype='TF' then 'Table function'
			when o.xtype='TR' then 'Trigger'
			when o.xtype='U' then 'User table'
			when o.xtype='V' then 'View'
			when o.xtype='X' then 'Extended Stored Proc'
			when o.xtype='S' then 'System Table'
			else o.xtype	
			end,
	'Action' = 
		case
			when pr.action=26  then 'REFERENCES'
			when pr.action=178 then 'CREATE FUNCTION'
			when pr.action=193 then 'SELECT'
			when pr.action=195 then 'INSERT'
			when pr.action=196 then 'DELETE'
			when pr.action=197 then 'UPDATE'
			when pr.action=198 then 'CREATE TABLE'
			when pr.action=203 then 'CREATE DATABASE'
			when pr.action=207 then 'CREATE VIEW'
			when pr.action=222 then 'CREATE PROCEDURE'
			when pr.action=224 then 'EXECUTE'
			when pr.action=228 then 'BACKUP DATABASE'
			when pr.action=233 then 'CREATE DEFAULT'
			when pr.action=235 then 'BACKUP LOG'
			when pr.action=236 then 'CREATE RULE'
		end,
	'Permission'=
		case
			when pr.protecttype = 204 then 'GRANT_W_GRANT'
			when pr.protecttype = 205 then 'GRANT'
			when pr.protecttype = 206 then 'REVOKE'
		end
from sysprotects pr, sysobjects o, sysusers u
where pr.id = o.id
and pr.uid = u.uid
order by u.name, o.xtype
