-- Muestra el nombre del servidor
select @@servername as Servidor

-- Lista los logins y los miembros de cada rol para cada base de datos
use master
select loginname,
CASE isntuser
         WHEN 0 THEN 'NO'
         WHEN 1 THEN 'SI'
      END es_Usuario_Windows,
sysadmin,securityadmin,serveradmin,setupadmin,processadmin,diskadmin,dbcreator,bulkadmin
from syslogins


-- Lista los roles y los miembros de cada rol para cada base de datos
exec sp_msforeachdb '
use [?]
select ''Base de datos:''+ ''[?]'' as BD
select roles.name as Rol,usuarios.name as miembro
from
(select * from sysusers where issqlrole=1) roles,
(select * from sysusers where issqlrole<>1) usuarios,
sysmembers membresia
where roles.uid=membresia.groupuid and usuarios.uid=memberuid
order by roles.name
'
-- Lista los permisos asignados a cada usuario o rol para cada base de datos
exec sp_msforeachdb '
use [?]
select ''Base de datos:''+ ''[?]'' as BD
select usu.name as usuario,
CASE issqlrole
         WHEN 0 THEN ''Usuario''
         WHEN 1 THEN ''Rol''
      END Tipo_principal,
obj.name as objeto
from 
sysusers usu,
sysobjects obj,
syspermissions permi
where 
permi.grantee=usu.uid and permi.id=obj.id
order by usu.name
'