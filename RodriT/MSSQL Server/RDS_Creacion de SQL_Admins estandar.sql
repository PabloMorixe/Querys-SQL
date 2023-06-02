/*Creacion del usuario SQL Admins*/
/*###############################*/

create login [gscorp\SQL_admins] from windows with default_database=[master],default_language=[us_english];
GO

/*Creacion de permisos a nivel de ROL-SERVER*/
/*##########################################*/

ALTER SERVER ROLE [processadmin] ADD MEMBER [gscorp\SQL_admins]
GO
ALTER SERVER ROLE [setupadmin] ADD MEMBER [gscorp\SQL_admins]
GO


/*Asignacion de Permisos estandar a nivel de instancia*/
/*####################################################*/

use [master]
GO
GRANT ADMINISTER BULK OPERATIONS TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT ALTER ANY CONNECTION TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT ALTER ANY CREDENTIAL TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT ALTER ANY EVENT SESSION TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT ALTER ANY LINKED SERVER TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT ALTER ANY LOGIN TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT ALTER ANY SERVER AUDIT TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT ALTER ANY SERVER ROLE TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT ALTER SERVER STATE TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT ALTER TRACE TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT CREATE ANY DATABASE TO [gscorp\SQL_admins]
GO
use [master]
GO
use [master]
GO
GRANT VIEW ANY DATABASE TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT VIEW ANY DEFINITION TO [gscorp\SQL_admins]
GO
use [master]
GO
GRANT VIEW SERVER STATE TO [gscorp\SQL_admins]
GO

/*Asignacion de permisos a las base de sistema*/
/*############################################*/

USE [msdb]
GO
CREATE USER [gscorp\SQL_admins] FOR LOGIN [gscorp\SQL_admins]
GO
ALTER ROLE [SQLAgentUserRole] ADD MEMBER [gscorp\SQL_admins]
GO
GRANT SELECT ON [dbo].[sysjobs] TO [gscorp\SQL_admins]
go
GRANT ALTER ON ROLE::[SQLAgentOperatorRole] to [gscorp\SQL_admins]
GO
USE [tempdb]
GO
CREATE USER [gscorp\SQL_admins] FOR LOGIN [gscorp\SQL_admins]
GO

/*Creacion del usuario Scriptexec*/
/*###############################*/

create login [scriptexec] WITH PASSWORD = 'Password.01'
GO

/*Creacion de permisos a nivel de ROL-SERVER*/
/*##########################################*/

ALTER SERVER ROLE [processadmin] ADD MEMBER [scriptexec]
GO
ALTER SERVER ROLE [setupadmin] ADD MEMBER [scriptexec]
GO


/*Asignacion de Permisos estandar a nivel de instancia*/
/*####################################################*/

use [master]
GO
GRANT ADMINISTER BULK OPERATIONS TO [scriptexec]
GO
use [master]
GO
GRANT ALTER ANY CONNECTION TO [scriptexec]
GO
use [master]
GO
GRANT ALTER ANY CREDENTIAL TO [scriptexec]
GO
use [master]
GO
GRANT ALTER ANY EVENT SESSION TO [scriptexec]
GO
use [master]
GO
GRANT ALTER ANY LINKED SERVER TO [scriptexec]
GO
use [master]
GO
GRANT ALTER ANY LOGIN TO [scriptexec]
GO
use [master]
GO
GRANT ALTER ANY SERVER AUDIT TO [scriptexec]
GO
use [master]
GO
GRANT ALTER ANY SERVER ROLE TO [scriptexec]
GO
use [master]
GO
GRANT ALTER SERVER STATE TO [scriptexec]
GO
use [master]
GO
GRANT ALTER TRACE TO [scriptexec]
GO
use [master]
GO
GRANT CREATE ANY DATABASE TO [scriptexec]
GO
use [master]
GO
use [master]
GO
GRANT VIEW ANY DATABASE TO [scriptexec]
GO
use [master]
GO
GRANT VIEW ANY DEFINITION TO [scriptexec]
GO
use [master]
GO
GRANT VIEW SERVER STATE TO [scriptexec]
GO

/*Asignacion de permisos a las base de sistema*/
/*############################################*/

USE [msdb]
GO
CREATE USER [scriptexec] FOR LOGIN [scriptexec]
GO
ALTER ROLE [SQLAgentUserRole] ADD MEMBER [scriptexec]
GO
GRANT SELECT ON [dbo].[sysjobs] TO [scriptexec]
go
GRANT ALTER ON ROLE::[SQLAgentOperatorRole] to [scriptexec]
GO
USE [tempdb]
GO
CREATE USER [scriptexec] FOR LOGIN [scriptexec]
GO
/*Creacion del usuario SQL Admins*/
/*###############################*/

create login [GSCORP\GGARE_AdminGSI] from windows 
GO

/*Creacion de permisos a nivel de ROL-SERVER*/
/*##########################################*/

ALTER SERVER ROLE [processadmin] ADD MEMBER [GSCORP\GGARE_AdminGSI]
GO
ALTER SERVER ROLE [setupadmin] ADD MEMBER [GSCORP\GGARE_AdminGSI]
GO


/*Asignacion de Permisos estandar a nivel de instancia*/
/*####################################################*/

use [master]
GO
GRANT ADMINISTER BULK OPERATIONS TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT ALTER ANY CONNECTION TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT ALTER ANY CREDENTIAL TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT ALTER ANY EVENT SESSION TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT ALTER ANY LINKED SERVER TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT ALTER ANY LOGIN TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT ALTER ANY SERVER AUDIT TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT ALTER ANY SERVER ROLE TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT ALTER SERVER STATE TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT ALTER TRACE TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT CREATE ANY DATABASE TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
use [master]
GO
GRANT VIEW ANY DATABASE TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT VIEW ANY DEFINITION TO [GSCORP\GGARE_AdminGSI]
GO
use [master]
GO
GRANT VIEW SERVER STATE TO [GSCORP\GGARE_AdminGSI]
GO

/*Asignacion de permisos a las base de sistema*/
/*############################################*/

USE [msdb]
GO
CREATE USER [GSCORP\GGARE_AdminGSI] FOR LOGIN [GSCORP\GGARE_AdminGSI]
GO
ALTER ROLE [SQLAgentUserRole] ADD MEMBER [GSCORP\GGARE_AdminGSI]
GO
GRANT SELECT ON [dbo].[sysjobs] TO [GSCORP\GGARE_AdminGSI]
go
GRANT ALTER ON ROLE::[SQLAgentOperatorRole] to [GSCORP\GGARE_AdminGSI]
GO
USE [tempdb]
GO
CREATE USER [GSCORP\GGARE_AdminGSI] FOR LOGIN [GSCORP\GGARE_AdminGSI]
GO


--AL RESTO DE LAS BASE DE DATOS DE USUARIO, DEBEMOS DARLE DB_OWNER AL LOGIN SQL_ADMINS