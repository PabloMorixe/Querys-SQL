Use [master]
RESTORE DATABASE [SmartOpen]
FROM  DISK = N'M:\BKP\SmartOpen01-06.bak',
                  DISK = N'M:\BKP\SmartOpen02-06.bak',
                  DISK = N'M:\BKP\SmartOpen03-06.bak',
                  DISK = N'H:\bkp1\SmartOpen04-06.bak',
                  DISK = N'H:\bkp1\SmartOpen05-06.bak',
                  DISK = N'H:\bkp1\SmartOpen06-06.bak'

WITH  FILE = 1,  
                  MOVE N'SmartOpen_Data' TO N'I:\MSSQL2K17\MSSQL14.MSSQLSERVER\MSSQL\Data\SmartOpen.mdf', 
                  MOVE N'SMO_1' TO N'I:\MSSQL2K17\MSSQL14.MSSQLSERVER\MSSQL\Data\SMO_1.ndf',  
                  MOVE N'SMO_2' TO N'J:\MSSQL2K17\MSSQL14.MSSQLSERVER\MSSQL\Data\SMO_2.ndf',  
                  MOVE N'SMO_3' TO N'K:\MSSQL2K17\MSSQL14.MSSQLSERVER\MSSQL\Data\SMO_3.ndf',  
                  MOVE N'SMO_4' TO N'L:\MSSQL2K17\MSSQL14.MSSQLSERVER\MSSQL\Data\SMO_4.ndf',  
                  MOVE N'SmartOpen_Log' TO N'H:\MSSQL2K17\MSSQL14.MSSQLSERVER\MSSQL\Data\SmartOpen_log.ldf',  
                 NOUNLOAD,  
                 REPLACE,  
                 STATS = 5,
                 BLOCKSIZE = 65536
Go
