----------------------------------------
-- Habilita Acceso readonly 
-- (ya lo tienen habilitado)
----------------------------------------

/*

ALTER AVAILABILITY GROUP [SSPR16BPMAG] 
MODIFY REPLICA ON N'SSPR16BPM-01' 
WITH
(
	SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL)
);

ALTER AVAILABILITY GROUP [SSPR16BPMAG] 
MODIFY REPLICA ON N'SSPR16BPM-02' 
WITH 
(
	SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL)
);

*/

 
----------------------------------------
-- Establece la URL de ruteo de readonly
----------------------------------------

 
ALTER AVAILABILITY GROUP [SSPR16BPMAG]
MODIFY REPLICA ON N'SSPR16BPM-01' 
WITH 
(
	SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'tcp://SSPR16BPM-01.GSCorp.AD:1433')
);


 
 
ALTER AVAILABILITY GROUP [SSPR16BPMAG] 
MODIFY REPLICA ON N'SSPR16BPM-02' 
WITH 
(
	SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'tcp://SSPR16BPM-02.GSCorp.AD:1433')
);



----------------------------------------
-- Establece el nodo de readonly cuando 
-- es primario
----------------------------------------

ALTER AVAILABILITY GROUP [SSPR16BPMAG] 
MODIFY REPLICA ON N'SSPR16BPM-01' 
WITH
(
	PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('SSPR16BPM-02'))
);

 
ALTER AVAILABILITY GROUP [SSPR16BPMAG] 
MODIFY REPLICA ON N'SSPR16BPM-02' 
WITH 
(
	PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('SSPR16BPM-01'))
);
GO
 
 

-- Crea linked Server
 
USE [master]
GO

EXEC master.dbo.sp_addlinkedserver 
	@server = N'lnk_SSPR16BPMAG_RO'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'SSPR16BPMAG'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=##########################;Data Source=SSPR16BPMAG;ApplicationIntent=ReadOnly'
    ,@catalog = N'##########################'
GO

-- Test
select * from openquery(lnk_SSPR16BPMAG_RO,'select @@servername')
