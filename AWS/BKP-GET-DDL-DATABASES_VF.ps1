#Script para realizar BACKUP en ONPREM
$AdminLogin = "scriptexec"
#$AdminLogin = "svcBBDDmigra"
$AdminPwd = read-host -AsSecureString -Prompt "User Password de '$AdminLogin' "  
$userInput = Read-Host -Prompt "Ingrese el nombre de la instancia y Base de datos, separado [;] y separado por comma [,] las database, Ej: pablo:db1,db2;pedro:db3,db4"
$path_bkp= Read-Host -Prompt "Ingrese path donde alojara los .bak, Ej: \\dqgdt-01\Backups\BKP-RDS"
$instances = $userInput.split("; ")
#ssds17-01:api_transferencias,Apolo;ssds17-04:api_beneficios,ApiTarjetas
foreach ($instance in $instances) {
	try {

 
    #Create and store message
    #$results += "Instancia que se hizo Bkp $_!"

   
    $firstref1 = $instance.IndexOf(":")
    $inst = $instance.Substring(0,$firstref1)
    #echo $inst

    $ServerInstance = "$inst\DEFAULT"
    Import-Module -Name SqlServer

    function create-sqldrive  
    {  
        param( 
            [string]$SqlDriveName, 
            [string]$login, 
            [string]$root 
        )  
    
        # sysadmin credential
       
        $cred = new-object System.Management.Automation.PSCredential -argumentlist $login, $AdminPwd
    
        # Create sql server powershell drive
        New-PSDrive $SqlDriveName -PSProvider SqlServer -Root $root -Credential $cred -Scope 1  
    }  

    $CurrentLocation = "SQLSERVER:\SQL\$ServerInstance"
    create-sqldrive SQLDRV $AdminLogin $CurrentLocation


    Push-Location
    Set-Location SQLDRV:

    $fecha= Get-Date -Format "ddMMyyyy"  

     Write-Output "Instancia:Bases -> $instance"

            $firstref = $instance.IndexOf(":")

            $alldbnames = $instance.Substring($firstref+1)
                        
            $dbnames = $alldbnames.split(",")

            foreach ($dbname in $dbnames) {

               # $dbname = 'api_terminos_condiciones'

$Query = @"
SET NOCOUNT ON
DECLARE @databases VARCHAR(400)
       ,@stm NVARCHAR(4000)
    ,@stm0 NVARCHAR(4000)
       ,@id VARCHAR(100)
       ,@cursor_db CURSOR
       ,@print NVARCHAR(4000);

/*****************************************************************************************/
/****************************** Indicar Base de datos a migrar ***************************/
/*****************************************************************************************/


PRINT '/*****************************************************************************************/'
PRINT '/* Usuarios de las siguientes Base de datos: ' + @databases + '  */'
PRINT '/*****************************************************************************************/'
PRINT CHAR(13)
PRINT '/*****************************************************************************************/'
PRINT '/*************************************** Create Logins ***********************************/'
PRINT '/*****************************************************************************************/'

BEGIN

  DECLARE @Results TABLE (ResultText VARCHAR(5000));
  
  SET @id='$dbname';	
    
    SET @stm = 'Use [' + @id + '];
select mp.[name]
FROM sys.database_role_members a
INNER JOIN sys.database_principals rp ON rp.principal_id = a.role_principal_id
INNER JOIN sys.database_principals AS mp ON mp.principal_id = a.member_principal_id'

             INSERT INTO @Results
             EXEC sp_executesql @stm
       END

       CREATE TABLE #RESULT_DIS (name_user VARCHAR(5000))

       INSERT INTO #RESULT_DIS
       SELECT DISTINCT ResultText
       FROM @Results
	   
       /*obtengo permisos en base a los usuarios de las BBDD */

       DECLARE @sql NVARCHAR(max)
             ,@Line INT = 1
             ,@max INT = 0
             ,@@CurDB NVARCHAR(100) = ''

       CREATE TABLE #SQL3 (
             Idx INT IDENTITY
             ,xSQL VARCHAR(max)
             )

		DECLARE @Login sysname;
		declare @output_sphelp varchar (max);
		declare @stm1 varchar (max);
	    CREATE TABLE #tmpLogins( createLoginScript NVARCHAR(4000))

		DECLARE cursLogins CURSOR FOR 
			SELECT * 
			FROM #RESULT_DIS

			OPEN cursLogins  
			FETCH NEXT FROM cursLogins INTO @Login  

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
			
				INSERT INTO #tmpLogins EXEC [master].[dbo].[sp_help_revlogin_migra] @Login

				FETCH NEXT FROM cursLogins INTO @Login;
			END
		CLOSE cursLogins;
		DEALLOCATE cursLogins;		

		CREATE TABLE #userslogin( userlogin NVARCHAR(4000),userloghash NVARCHAR(4000))

	    INSERT INTO #userslogin
		select  SUBSTRING(createLoginScript, CHARINDEX('[', createLoginScript, 1)+1,
		CHARINDEX(']', createLoginScript, 1)-CHARINDEX('[', createLoginScript, 1)-1	
		) ,* from #tmpLogins

		INSERT INTO #SQL3
		select N'IF  NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '''+ u.userlogin  + ''')' 
		+ char(13) + '  ' + userloghash + char(13)
		
		from #userslogin u
        where u.userlogin not like ('GSCORP%') and u.userlogin <> 'svcBBDDmigra'
		
       SET @line = 0

       SELECT @Max = MAX(idx)
       FROM #SQL3

       WHILE @Line <= @max
       BEGIN

             SELECT @sql = xSql
             FROM #SQL3 AS s
             WHERE idx = @Line

             SELECT @sql

             SET @line = @line + 1
       END

       DROP TABLE #SQL3
	   DROP TABLE #tmpLogins
	   DROP TABLE #userslogin

DROP TABLE #RESULT_DIS

--END
"@
                
                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 

                Write-Output "Instancia: $dbname"
    
                Write-Host "[INFO] $timestamp Start Backup-SQL-Database" -ForegroundColor green 
                Write-Host "[INFO] $timestamp Database: $dbName" -ForegroundColor green 
                
                $FileNameBkp = "$path_bkp\BKP-$($dbName)_full_$($fecha).bak"

                Backup-SqlDatabase -Database $dbName -BackupFile $FileNameBkp -CompressionOption On -BackupSetDescription  "Full Backup" 
                
                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss"
                              
                Write-Host "[INFO] $timestamp End of Backup-SQL-Database" -ForegroundColor green 
 
                Write-Host "[INFO] $timestamp Start get DDL grant + Role Database: $dbName" -ForegroundColor green 

                $stm=Invoke-Sqlcmd  -Query $Query
                $stm.Column1  | Out-File -FilePath  FileSystem::"$path_bkp\DDL-GRANT-$($dbName)_$($fecha).sql" 
                

                Write-Host "[INFO] $timestamp End get DDL" -ForegroundColor green 
                
                

            }

    Pop-Location
    Remove-PSDrive -Force SQLDRV
}
	catch {
		Write-Output "$instance - $($_.Exception.Message)"
	}
}