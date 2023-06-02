BACKUP DATABASE SmartOpen TO 
  DISK = N'\\Sspr17smo-01\bkp\SmartOpen01-06.bak',
  DISK = N'\\Sspr17smo-01\bkp\SmartOpen02-06.bak',
  DISK = N'\\Sspr17smo-01\bkp\SmartOpen03-06.bak',
  DISK = N'\\Sspr17smo-01\bkp1\SmartOpen04-06.bak',
  DISK = N'\\Sspr17smo-01\bkp1\SmartOpen05-06.bak',
  DISK = N'\\Sspr17smo-01\bkp1\SmartOpen06-06.bak'

WITH 
   COPY_ONLY,
   NOFORMAT, 
   INIT,NAME = N'SmartOpen-Full Database Backup', 
   SKIP, 
   NOREWIND, 
   NOUNLOAD, 
   COMPRESSION,
   CHECKSUM,
   STATS = 5
GO

