---	
--- Script para Agregar paso previo en todos los JObs, chequeo de Nodo Activo - AlwaysON
--- CAMBIAR EL NOMBRE DE AVAYLABILITY GROUP!!!!!!!!!!!!!!
---



--- Primer Parte a ejecutar (En cada nodo)

USE master;
GO
IF OBJECT_ID('dbo.is_primary_node_of_SSPR16BPMAG', 'FN') IS NOT NULL
  DROP FUNCTION dbo.is_primary_node_of_SSPR16BPMAG;
GO


CREATE FUNCTION dbo.is_primary_node_of_SSPR16BPMAG() 
RETURNS bit
AS
BEGIN;
  DECLARE @PrimaryReplica sysname; 

  SELECT
                @PrimaryReplica = hags.primary_replica
  FROM          sys.dm_hadr_availability_group_states hags
  INNER JOIN    sys.availability_groups ag 
                ON ag.group_id = hags.group_id
  WHERE 
            ag.name = 'SSPR16BPMAG';

  IF UPPER(@PrimaryReplica) =  UPPER(@@SERVERNAME)
    RETURN 1; -- primary

    RETURN 0; -- not primary
END; 

  select master.dbo.is_primary_node_of_SSPR16BPMAG()





--- Segunda Parte a ejecutar (En cada nodo)

-- Putting it all together. This code snippet bellow loops over all jobs and adds 
-- or prints a new job step called ‘get_availability_group_role’ with the above code. 
-- The new job step is the first step within each job with a step id of 1.


USE msdb;
SET NOCOUNT ON; 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

IF OBJECT_ID(N'tempdb.dbo.#data', N'U') IS NOT NULL DROP TABLE dbo.#data;
CREATE TABLE dbo.#data (id int IDENTITY PRIMARY KEY, name sysname);

-- Get all job names exclude jobs that already have a step named 'get_availability_group_role'
INSERT dbo.#data (name)
SELECT DISTINCT 
    j.name--, s.step_name 
FROM 
    dbo.sysjobs j
EXCEPT
SELECT DISTINCT j.name
FROM        dbo.sysjobs j
INNER JOIN  dbo.sysjobsteps s 
            ON j.job_id = s.job_id
WHERE 
        s.step_name = N'get_availability_group_role';

-- Remove jobs that need to run on any replica
DELETE FROM #data WHERE name LIKE 'SQL Sentry%';
DELETE FROM #data WHERE name LIKE 'syspolicy_purge_history';
DELETE FROM #data WHERE name LIKE 'DBA -%';
--SELECT * FROM #data ORDER BY 1;

DECLARE @command varchar(max), @min_id int, @max_id int, @job_name sysname, @availability_group sysname;
SELECT  
        @min_id = 1, 
        @max_id = (SELECT MAX(d.id) FROM #data AS d);
SELECT 
        @availability_group = (SELECT ag.name FROM sys.availability_groups ag);

-- If this is instance does not belong to HA exit here
IF @availability_group IS NULL 
BEGIN;
    PRINT 'This instance does not belong to AG. Terminating.';
    RETURN;
END;


-- Loop through the table and execute/print the command per each job
WHILE @min_id <= @max_id
BEGIN;
        SELECT @job_name = name FROM dbo.#data AS d WHERE d.id = @min_id;

        SELECT @command = 
        'BEGIN TRAN;
        DECLARE @ReturnCode INT;
        EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_name=''' + @job_name + ''', @step_name=N''get_availability_group_role'', 
                @step_id=1, 
                @cmdexec_success_code=0, 
                @on_success_action=3, 
                @on_success_step_id=0, 
                @on_fail_action=3, 
                @on_fail_step_id=0, 
                @retry_attempts=0, 
                @retry_interval=0, 
                @os_run_priority=0, @subsystem=N''TSQL'', 
                @command=
        N''-- Detect if this instance''''s role is a Primary Replica.
-- If this instance''''s role is NOT a Primary Replica stop the job so that it does not go on to the next job step
DECLARE @rc int; 
EXEC @rc = master.dbo.is_primary_node_of_SSPR16BPMAG;

IF @rc = 0
BEGIN;
    DECLARE @name sysname;
    SELECT  @name = (SELECT name FROM msdb.dbo.sysjobs WHERE job_id = CONVERT(uniqueidentifier, $(ESCAPE_NONE(JOBID))));
    
    EXEC msdb.dbo.sp_stop_job @job_name = @name;
    PRINT ''''Stopped the job since this is not a Primary Replica'''';
END;'', 
        @database_name=N''master'', 
        @flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) 
BEGIN; 
    PRINT ''-- Rollback: ''''' + @job_name + ''''''' ROLLBACK TRAN; 
END;
ELSE COMMIT TRAN;' + CHAR(10) + 'GO';

        PRINT @command;

    SELECT @min_id += 1;
END;


