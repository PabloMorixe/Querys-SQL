Restrictions

        * You must me a member of the sysadmin fixed server role to rename a database.
        * Ensure that you have no code that references the old database name. If so, change the code to reference the new database name.
        * The database being renamed must be in "single-user" mode.
        * Any database files and/or filegroup names will not be changed as a result of renaming the database.
        * You must be in the master database to execute the sp_renamedb system stored procedure. 


Example

        The following example will rename the 'DevelopmentDB' database to 'ProductionDB':

             USE master
             GO
             EXEC sp_dboption DevelopmentDB, 'Single User', True
             EXEC sp_renamedb 'DevelopmentDB', 'ProductionDB'
             EXEC sp_dboption ProductionDB, 'Single User', False

        To verify that the database was actually renamed, run the following:

        1> EXEC sp_helpdb