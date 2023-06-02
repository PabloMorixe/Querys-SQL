exec msdb.dbo.rds_restore_database @restore_db_name=Jira, 
@s3_arn_to_restore_from='arn:aws:s3:::atlassian-installation-files-dev/rds-backups/SSDS17-04_JIRA_FULL_20201211_000157.bak';

EXEC msdb.dbo.rds_task_status;