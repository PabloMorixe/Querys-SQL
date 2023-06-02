-----------------------------------------------------------------
--SYSTEM TABLES PARA MIRRORING
-----------------------------------------------------------------
SELECT * FROM SYS.database_mirroring
SELECT * FROM SYS.database_mirroring_endpoints
SELECT * FROM SYS.database_mirroring_witnesses



--------------------------
--MIRRORING STATES
--------------------------
/*
SYNCHRONIZING		The contents of the mirror database are lagging behind the contents of the principal database. The principal server is sending log records to the mirror server, which is applying the changes to the mirror database to roll it forward.
					At the start of a database mirroring session, the database is in the SYNCHRONIZING state. The principal server is serving the database, and the mirror is trying to catch up.
 
SYNCHRONIZED 		When the mirror server becomes sufficiently caught up to the principal server, the mirroring state changes to SYNCHRONIZED. The database remains in this state as long as the principal server continues to send changes to the mirror server and the mirror server continues to apply changes to the mirror database.
					If transaction safety is set to FULL, automatic failover and manual failover are both supported in the SYNCHRONIZED state, there is no data loss after a failover.
					If transaction safety is off, some data loss is always possible, even in the SYNCHRONIZED state. 
 
SUSPENDED			The mirror copy of the database is not available. The principal database is running without sending any logs to the mirror server, a condition known as running exposed. This is the state after a failover. 
					A session can also become SUSPENDED as a result of redo errors or if the administrator pauses the session.
					SUSPENDED is a persistent state that survives partner shutdowns and startups. 
 
PENDING_FAILOVER	This state is found only on the principal server after a failover has begun, but the server has not transitioned into the mirror role. 
					When the failover is initiated, the principal database goes into the PENDING_FAILOVER state, quickly terminates any user connections, and takes over the mirror role soon thereafter.
 
DISCONNECTED		The partner has lost communication with the other partner. 
 */




-----------------------------------------------------------------
--SUSPENDER LA SESIÓN DE MIRRORING PARA UNA BD
-----------------------------------------------------------------
--This statement places the database in a SUSPENDED state.
ALTER DATABASE <database_name> SET PARTNER SUSPEND



-----------------------------------------------------------------
--REINICIAR LA SESIÓN DE MIRRORING PARA UNA BD
-----------------------------------------------------------------
--Connect to either partner
ALTER DATABASE <database_name> SET PARTNER RESUME



------------------------------------------------------------------
--Cambiar el SAFETY MODE (Modo Sincrónico / Asincrónico)
------------------------------------------------------------------
--Synchronous Database Mirroring (High-Safety Mode) 
ALTER DATABASE <database> SET PARTNER SAFETY FULL

--Asynchronous Database Mirroring (High-Performance Mode) 
ALTER DATABASE <database> SET PARTNER SAFETY OFF



------------------------------------------------------------------
--MANUAL FAILOVER A DATABASE MIRRORING SESSION
------------------------------------------------------------------
--1) Connect to the principal server
--2) Set the database context to the master database
--3) In the principal server
ALTER DATABASE database_name SET PARTNER FAILOVER



----------------------------------------------------
--Force Service in a Database Mirroring Session
----------------------------------------------------
--Forcing service suspends the session and starts a new recovery fork. The effect of forcing service is similar to removing mirroring and recovering the former principal database. However, forcing service facilitates resynchronizing the databases (with possible data loss) when mirroring resumes
--Connect to the mirror server
ALTER DATABASE <database_name> SET PARTNER FORCE_SERVICE_ALLOW_DATA_LOSS



--------------------------------------------------------------
--Remove the Witness from a Database Mirroring Session
--------------------------------------------------------------
--Connect to either partner
ALTER DATABASE <database_name> SET WITNESS OFF



-------------------------------
--Remove Database Mirroring
-------------------------------
ALTER DATABASE <database_name> SET PARTNER OFF
