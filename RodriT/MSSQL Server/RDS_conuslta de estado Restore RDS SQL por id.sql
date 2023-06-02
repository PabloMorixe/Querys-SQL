declare @tarea_id int
declare @task_id int
declare @completado int
declare @status varchar(30)
DECLARE @q nvarchar(4000)
declare @tempTableTask table (
	task_id int,
	task_type varchar(100),
	datasbase_name varchar(100),
	[% complete] int,
	[duration(mins)] int,
	lifecycle varchar(100),
	task_info nvarchar(4000),
	last_updated datetime,
	created datetime,
	s3_object_arn nvarchar(4000),
	overwrite_s3_backup_file int,
	kms_master_key_arn varchar(100),
	filepath varchar(100),
	overwrite_file varchar(100)
	)

select @task_id=23

set @q = 'EXEC msdb.dbo.rds_task_status'

print @q

insert into @tempTableTask
	exec (@q)

--select * from @tempTableTask where task_id=@task_id

set @tarea_id = (select task_id from @tempTableTask where task_id=@task_id)
set @completado = (select [% complete] from @tempTableTask where task_id=@task_id)
set @status = (select lifecycle from @tempTableTask where task_id=@task_id)

delete @tempTableTask

select @tarea_id,@completado,@status




