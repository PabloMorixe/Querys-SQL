-----------------------------------------------------------------
--SETUP DE MIRRORING CON WITNESS SERVER
-----------------------------------------------------------------

--PREREQUISITO: BD en FULL RECOVERY MODEL
USE master;
GO
ALTER DATABASE AdventureWorks2008R2 
SET RECOVERY FULL;
GO



---------------------------------------------------------------------------------------------------
--Create an endpoint on the principal server instance (default instance on PARTNERHOST1)
---------------------------------------------------------------------------------------------------
CREATE ENDPOINT Endpoint_Mirroring
    STATE=STARTED 
    AS TCP (LISTENER_PORT=7022) 
    FOR DATABASE_MIRRORING (ROLE=PARTNER);
GO
--Partners under same domain user; login already exists in master.
--Create a login for the witness server instance,
--which is running as Somedomain\witnessuser:
USE master ;
GO
CREATE LOGIN [Somedomain\witnessuser] FROM WINDOWS ;
GO
-- Grant connect permissions on endpoint to login account of witness.
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [Somedomain\witnessuser];
GO



---------------------------------------------------------------------------------------------------
--Create an endpoint on the mirror server instance (default instance on PARTNERHOST5)
---------------------------------------------------------------------------------------------------
CREATE ENDPOINT Endpoint_Mirroring
    STATE=STARTED 
    AS TCP (LISTENER_PORT=7022) 
    FOR DATABASE_MIRRORING (ROLE=ALL);
GO
--Partners under same domain user; login already exists in master.
--Create a login for the witness server instance,
--which is running as Somedomain\witnessuser:
USE master ;
GO
CREATE LOGIN [Somedomain\witnessuser] FROM WINDOWS ;
GO
--Grant connect permissions on endpoint to login account of witness.
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [Somedomain\witnessuser];
GO




---------------------------------------------------------------------------------------------------
--Create an endpoint on the witness server instance (default instance on WITNESSHOST4)
---------------------------------------------------------------------------------------------------
CREATE ENDPOINT Endpoint_Mirroring
    STATE=STARTED 
    AS TCP (LISTENER_PORT=7022) 
    FOR DATABASE_MIRRORING (ROLE=WITNESS)
GO
--Create a login for the partner server instances,
--which are both running as Mydomain\dbousername:
USE master ;
GO
CREATE LOGIN [Mydomain\dbousername] FROM WINDOWS ;
GO
--Grant connect permissions on endpoint to login account of partners.
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [Mydomain\dbousername];
GO



---------------------------------------------------------------------------------------------------
--Create the mirror database
---------------------------------------------------------------------------------------------------
--RESTORE de la BD Principal en el servidor de mirroring en RESTORING STATE



---------------------------------------------------------------------------------------------------
--On the mirror server instance on PARTNERHOST5, set the server instance on PARTNERHOST1 as the partner (making it the initial principal server instance)
---------------------------------------------------------------------------------------------------
LTER DATABASE AdventureWorks2008R2 
    SET PARTNER = 
    'TCP://PARTNERHOST1.COM:7022';
GO



---------------------------------------------------------------------------------------------------
--On the principal server instance on PARTNERHOST1, set the server instance on PARTNERHOST5 as the partner (making it the initial mirror server instance)
---------------------------------------------------------------------------------------------------
ALTER DATABASE AdventureWorks2008R2 
    SET PARTNER = 'TCP://PARTNERHOST5.COM:7022';
GO



---------------------------------------------------------------------------------------------------
--On the principal server, set the witness (which is on WITNESSHOST4)
---------------------------------------------------------------------------------------------------
ALTER DATABASE AdventureWorks2008R2 
    SET WITNESS = 
    'TCP://WITNESSHOST4.COM:7022';
GO