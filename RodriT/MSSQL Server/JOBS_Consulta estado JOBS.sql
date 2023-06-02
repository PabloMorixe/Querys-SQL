USE msdb ;
GO

EXEC dbo.sp_help_jobactivity ;
GO


This procedure provides a snapshot of the current state of the jobs. The results returned represent information at the time that the request is processed.
SQL Server Agent creates a session id each time that the Agent service starts. The session id is stored in the table msdb.dbo.syssessions.
When no session_id is provided, lists information about the most recent session.
When no job_name or job_id is provided, lists information for all jobs.

Permissions

By default, members of the sysadmin fixed server role can run this stored procedure. Other users must be granted one of the following SQL Server Agent fixed database roles in the msdb database:
SQLAgentUserRole
SQLAgentReaderRole
SQLAgentOperatorRole
For details about the permissions of these roles, see SQL Server Agent Fixed Database Roles.
Only members of sysadmin can view the activity for jobs owned by other users.


