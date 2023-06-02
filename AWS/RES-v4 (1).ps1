 function create-sqldrive  
    {  
        param( 
            [string]$SqlDriveName, 
            [string]$login,            
            [string]$root,
            [string]$instance
        )  
    
        $AdminPwd = read-host -AsSecureString -Prompt "User Password RDS De '$login' Endpoint $instance" 

        # sysadmin credential
       
        $cred = new-object System.Management.Automation.PSCredential -argumentlist $login, $AdminPwd
    
        # Create sql server powershell drive
        New-PSDrive $SqlDriveName -PSProvider SqlServer -Root $root -Credential $cred -Scope 1  
    }  



#Script para restaurar BBDD en RDS

#$AdminPwd = read-host -AsSecureString -Prompt "User Password RDS Restore"  

Write-Host 'Ingrese Endpoint de la instancia y Base de datos' -ForegroundColor yellow 
Write-Host 'Separado [;] y separado por comma [,] las BBDD, Ej: appds-rds-ss17-02.amazonaws.com:Apolo' -ForegroundColor yellow 
#$userInput = Read-Host -Prompt "Ingrese Datos:" -ForegroundColor yellow 
$userInput =$(Write-Host "Ingrese Datos: " -ForegroundColor Yellow -NoNewline; Read-Host)


#$path_bkp= Read-Host -Prompt "Ingrese path de rds donde se tomaran los .bak y .sql, Ej: repo-rds-backup-dev/rds-backups" 
$path_bkp =$(Write-Host "Ingrese path de rds donde se tomaran los .bak, Ej: repo-rds-backup-dev/rds-backups:" -ForegroundColor Yellow -NoNewline; Read-Host)

#$path_bkp= Read-Host -Prompt "Ingrese path de rds donde se tomaran los .bak y .sql, Ej: repo-rds-backup-dev/rds-backups" 
$path_sql =$(Write-Host "Ingrese path de Onprem  donde se tomaran el file de grant .sql, Ej: \\dqgdt-01:" -ForegroundColor Yellow -NoNewline; Read-Host)

#$fecha_bkp_sql= Read-Host -Prompt "Ingrese fecha de los .bak y .sql, para restaurar. Formato: ddmmyyyy"
$fecha_bkp_sql =$(Write-Host "Ingrese fecha de los .bak y .sql, para restaurar. Formato: ddmmyyyy:" -ForegroundColor Yellow -NoNewline; Read-Host)

$instances = $userInput.split("; ")

#ssds17-01:api_transferencias,Apolo;ssds17-04:api_beneficios,ApiTarjetas

#PRIMERO SE HACE EL RESTORE

$arrDbRestore = @{}

foreach ($instance in $instances) {
	try {

 
    #Create and store message   


    $firstref1 = $instance.IndexOf(":")
    $inst = $instance.Substring(0,$firstref1)
    #echo $inst

    #$AdminLogin = "admin"    
    $AdminLogin = "svcBBDDmigra"
    

    $ServerInstance = "$inst,1433\DEFAULT"
    Import-Module -Name SqlServer


    $CurrentLocation = "SQLSERVER:\SQL\$ServerInstance"
    create-sqldrive SQLDRV $AdminLogin $CurrentLocation $inst

    Push-Location
    Set-Location SQLDRV:

    $fecha= Get-Date -Format "ddmmyyyy"  
    

     Write-Output "Instancia: $instance"

            $firstref = $instance.IndexOf(":")

            $alldbnames = $instance.Substring($firstref+1)
                        
            $dbnames = $alldbnames.split(",")

            foreach ($dbname in $dbnames) {
            

            #echo $dbname

               # $dbname = 'api_terminos_condiciones'
 
                #File restore  BKP-Apolo_full_02392022.bak
                $FileNameBkp = "'arn:aws:s3:::$path_bkp/BKP-$($dbName)_full_$($fecha_bkp_sql).bak'"
                #File DDL Grant + Role
                #$FileNameSql = "arn:aws:s3:::$path_bkp/DDL-GRANT-$($dbName)_$($fecha_bkp_sql).sql"


                #Backup-SqlDatabase -Database $dbName -BackupFile $FileNameBkp -CompressionOption On -BackupSetDescription  "Full Backup" 
                #Invoke-Sqlcmd  -Query "select @@version"  | Format-Table
                #Invoke-Sqlcmd -Query "PRINT 'Hello World!'" > "$path_bkp\$($dbName)_scriptGrant_$($fecha).sql"
                #Invoke-Sqlcmd -Query "select @@version" |Out-File -FilePath  FileSystem::$path_bkp\$($dbName)_scriptGrant_$($fecha).sql
                # Invoke-Sqlcmd -Query "select @@version" |Export-Trace  $path_bkp\$($dbName)_scriptGrant_$($fecha).sql
                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
                Write-Host "[INFO] $timestamp Start Restore DB $dbname" -ForegroundColor green 

                #Generar Array, para guardar las task de las tareas de restore.

                $query = 'exec msdb.dbo.rds_restore_database @restore_db_name='+$dbname+', @s3_arn_to_restore_from='+$FileNameBkp

                
                $stm=Invoke-Sqlcmd  -Query $Query
                
                $task_id=$stm.task_id
                $task_dbname=$stm.database_name
                $status=$stm.lifecycle
                
                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
                Write-Host "[INFO] $timestamp TASK_ID: $task_id" -ForegroundColor green
                Write-Host "[INFO] $timestamp $task_dbname" -ForegroundColor green
                Write-Host "[INFO] $timestamp STATUS: $status" -ForegroundColor green

                $keyArray = $inst+':'+$task_dbname
                $valueArray=$task_id
                $arrDbRestore[$keyArray] = $valueArray

                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
                Write-Host "[INFO] $timestamp End exeution of Restore, please check this task " -ForegroundColor green


            }

    Pop-Location
    Remove-PSDrive -Force SQLDRV
}
	catch {
        $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
		Write-Output "[INFO] $timestamp $instance - $($_.Exception.Message)"
        Pop-Location
        Remove-PSDrive -Force SQLDRV
        
	}
}

##-------------------------------------------------------------------------------------------------------------------

##Aplicar While, hasta que se finalice los restores de todas las BBDD luego continua con la aplicacion de los grants.

#while status<>0 { cuando sea igual a 0, sale.

#{Dentro del while tengo que abrir conexion con sleep de 30seg entre while y while. para buclear en todos los endpoint. hasta que no termine todos los restore, no avanzara.

#}


#$AdminLogin = "scriptexec"
$AdminLogin = "svcBBDDmigra"
$AdminPass = read-host -AsSecureString -Prompt "User Password RDS De '$Adminlogin'" 

#echo 'Contenido de arrDbRestore' 
#echo $arrDbRestore
$arrDbRestoreErr = @{} #array para almacenar los restore con error o canel
$arrDbRestoreSuc = @{} #array para almacenar los restore success

$i=0 

#arrDbRestore[$keyArray] = $valueArray

while ($arrDbRestore.count -gt 0 ){ 

try {

$arrDbRestoreLoop = $arrDbRestore.Clone()

        foreach($k in $arrDbRestoreLoop.GetEnumerator()){
                 
	        try {
		
	        $arrFirstref1 = $k.key.IndexOf(":")
            $arrInst = $k.key.Substring(0,$arrFirstref1)
            $arrDbname = $k.key.Substring($arrFirstref1+1)

            #write-host "Instance of array $arrInst "
            #write-host "Database of array $arrDbname "


	        $ServerInstance = "$arrInst,1433\DEFAULT"
            $CurrentLocation = "SQLSERVER:\SQL\$ServerInstance"

             function create-sqldrive-withoutSecure  
                {  
                    param( 
                        [string]$SqlDriveName, 
                        [string]$login,            
                        [string]$root
                    )  
    
        
                    # sysadmin credential
       
                    $cred = new-object System.Management.Automation.PSCredential -argumentlist $login, $AdminPass
    
                    # Create sql server powershell drive
                    New-PSDrive $SqlDriveName -PSProvider SqlServer -Root $root -Credential $cred -Scope 1  
                }  
    
	        create-sqldrive-withoutSecure SQLDRV $AdminLogin $CurrentLocation

            Push-Location
            Set-Location SQLDRV:
	
	        $taskQuery = 'exec msdb.dbo.rds_task_status @task_id='+$k.Value

            #echo $taskQuery
            #echo $query
            $taskStm=Invoke-Sqlcmd  -Query $taskQuery

            $task_id=$taskStm.task_id
            $task_dbname=$taskStm.database_name
            $taskStatus=$taskStm.lifecycle

            $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
            Write-Host "[INFO] $timestamp  Endpoint: $arrInst" -ForegroundColor green
            Write-Host "[INFO] $timestamp  DATABASE_NAME: $task_dbname" -ForegroundColor green
            Write-Host "[INFO] $timestamp  TASK_ID: $task_id" -ForegroundColor green           
            Write-Host "[INFO] $timestamp  STATUS: $taskStatus"  -ForegroundColor green          
    
	          if($taskStatus -eq 'SUCCESS'){
                
                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
                Write-Host "[INFO] $timestamp  Finalizo SUCCESS el Restore de $task_dbname" -ForegroundColor green
                $arrDbRestoreSuc[$k.Key] = $k.Value #Cargo array con Task SUCCESS                   
                $arrDbRestore.Remove($k.Key) 
       
                } 
                else
                {
                    if($taskStatus -eq 'ERROR' -Or $taskStatus -eq 'CANCEL_REQUESTED' -Or $taskStatus -eq 'CANCELLED') {

                          Write-Host 'Finalizo con ERROR o CANCEL el Restore de $task_exec msdb.dbo.rds_task_status @taskdbname Tarea $k.Value' -ForegroundColor red
                          $arrDbRestoreErr[$k.Key] = $k.Value #Cargo array con Task con errores                          
                          $arrDbRestore.Remove($k.Key) 

                     
                     }
                }

	        Pop-Location
            Remove-PSDrive -Force SQLDRV
	
	        }
	        catch {
                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
		        Write-Output "[INFO] $timestamp $instance - $($_.Exception.Message)" -ForegroundColor red
                break
	        }
        


        }

  $i++
  Write-Host 'Loop numero': $i -ForegroundColor Yellow 
  #write-host 'Longitud del array': $arrDbRestore.length
  Start-Sleep -s 20
}
	catch {
        $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
		Write-Output "[INFO] $timestamp $instance - $($_.Exception.Message)" -ForegroundColor red
        Pop-Location
        Remove-PSDrive -Force SQLDRV
        break
	}
}
$timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
write-host "[INFO] $timestamp  Resumen de tarea de RESTORE" -ForegroundColor green 

if ($arrDbRestoreSuc.count -gt 0){
$timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
write-host "[INFO] $timestamp  Restore que finalizaron SUCCESS" -ForegroundColor green 
echo $arrDbRestoreSuc
echo $arrDbRestoreSuc.key $arrDbRestoreSuc.value

}

if ($arrDbRestoreErr.count -gt 0){
$timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
write-host '$timestamp  Restore que finalizaron con ERROR o CANCEL' -ForegroundColor red 
echo $arrDbRestoreErr.key $arrDbRestoreErr.value

}



##-------------------------------------------------------------------------------------------------------------------

$instances = $userInput.split(";")

#ssds17-01:api_transferencias,Apolo;ssds17-04:api_beneficios,ApiTarjetas

foreach ($instance in $instances) {
	try {

 
    #Create and store message
    
    $firstref1 = $instance.IndexOf(":")
    $inst = $instance.Substring(0,$firstref1)
    #echo $inst

    $ServerInstance = "$inst,1433\DEFAULT"
    Import-Module -Name SqlServer

    #$AdminLogin = "admin"    
    #$AdminLogin = "scriptexec"
    $AdminLogin = "svcBBDDmigra"

    $AdminPass = read-host -AsSecureString -Prompt "User Password RDS De '$Adminlogin' del EndPoint $inst " 

    function create-sqldrive  
    {  
        param( 
            [string]$SqlDriveName, 
            [string]$login, 
            [string]$root 
        )  
    
        # sysadmin credential
       
        $cred = new-object System.Management.Automation.PSCredential -argumentlist $login, $AdminPass
    
        # Create sql server powershell drive
        New-PSDrive $SqlDriveName -PSProvider SqlServer -Root $root -Credential $cred -Scope 1  
    }  


    $CurrentLocation = "SQLSERVER:\SQL\$ServerInstance"
    create-sqldrive SQLDRV $AdminLogin $CurrentLocation

    Push-Location
    Set-Location SQLDRV:

    $fecha= Get-Date -Format "ddMMyyyy"  

     #Write-Output "$instance - OK"

            $firstref = $instance.IndexOf(":")

            $alldbnames = $instance.Substring($firstref+1)
                        
            $dbnames = $alldbnames.split(",")

            foreach ($dbname in $dbnames) {

               # $dbname = 'api_terminos_condiciones'
 
                #File DDL Grant + Role
                #$FileNameSql = "$path_bkp/DDL-GRANT-$($dbName)_$($fecha_bkp_sql).sql"
                $FileNameSql = "$path_sql\DDL-GRANT-$($dbName)_$($fecha_bkp_sql).sql"
                
                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss"               
                Write-Host "[INFO] $timestamp Start Apply DDL grant + Role Database: $dbName" -ForegroundColor green   
                               
                $stm=Invoke-Sqlcmd -Database $dbname -InputFile $FileNameSql
                $stm.Column1  | Out-File -FilePath  FileSystem::"$path_sql\LOG-DDL-GRANT-$($dbName)_$($fecha).txt" 

                #Backup-SqlDatabase -Database $dbName -BackupFile $FileNameBkp -CompressionOption On -BackupSetDescription  "Full Backup" 
                #Invoke-Sqlcmd  -Query "select @@version"  | Format-Table
                #Invoke-Sqlcmd -Query "PRINT 'Hello World!'" > "$path_bkp\$($dbName)_scriptGrant_$($fecha).sql"
                #Invoke-Sqlcmd -Query "select @@version" |Out-File -FilePath  FileSystem::$path_bkp\$($dbName)_scriptGrant_$($fecha).sql
                # Invoke-Sqlcmd -Query "select @@version" |Export-Trace  $path_bkp\$($dbName)_scriptGrant_$($fecha).sql
                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
                Write-Host "[INFO] $timestamp End get DDL"  -ForegroundColor green       
                
                #REGuLARIZACION DE PERMISOS PARA EL ADMIN       
                $query = @"
                USE $dbname
CREATE USER [admin] FOR LOGIN [admin]
CREATE USER scriptexec FOR LOGIN scriptexec
ALTER ROLE [db_owner] ADD MEMBER [admin]
ALTER ROLE [db_owner] ADD MEMBER scriptexec
CREATE USER [gscorp\SQL_admins]  FOR LOGIN [gscorp\SQL_admins]
ALTER ROLE [db_owner] ADD MEMBER [gscorp\SQL_admins]
"@
                $stm=Invoke-Sqlcmd  -Query $query
                $timestamp= Get-Date -Format "ddMMyyy HH:mm:ss" 
                Write-Host "[INFO] $timestamp End Assign Permissions to Admin Group"  -ForegroundColor green
            }

    Pop-Location
    Remove-PSDrive -Force SQLDRV
}
	catch {
		Write-Output "$instance - $($_.Exception.Message)"
        Pop-Location
        Remove-PSDrive -Force SQLDRV
	}
}