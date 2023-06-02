exec msdb.dbo.rds_backup_database
	@source_db_name='Jira', 
	@s3_arn_to_backup_to='arn:aws:s3:::atlassian-installation-files-tst/rds-backup/20210329_JiraTEST.bak',
	@type='FULL';


EXEC msdb.dbo.rds_task_status;

/*		DECLARE   @return_value int
	EXEC  @return_value = [dbo].[rds_task_status] @db_name ='confluence', @task_id =27*/