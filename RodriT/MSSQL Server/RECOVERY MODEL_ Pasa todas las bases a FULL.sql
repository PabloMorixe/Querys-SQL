set nocount on
go

if exists (
        select 1
        from sys.databases
        where recovery_model_desc = 'SIMPLE'
            and state_desc = 'ONLINE'
        )
begin
    print '-- You are setting up database to FULL recovery mode. '
    print '-- Make sure you take first full backup and then schedule LOG BACKUPS for proper transaction log maintenance !'

    select 'ALTER DATABASE ' + QUOTENAME(name) + ' SET RECOVERY FULL with ROLLBACK IMMEDIATE;'
    from sys.databases
    where recovery_model_desc = 'SIMPLE' -- since you only want SIMPLE recovery model databases to get changed to FULL recovery.
            and state_desc = 'ONLINE'
end
else
    select 'ALL the databases are in FULL RECOVERY MODE - Make sure you take proper LOG BACKUPS !!'