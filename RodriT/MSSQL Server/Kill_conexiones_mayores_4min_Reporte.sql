
--
-- Genera lista para kill de sesiones > 4 min.
--

DECLARE @user_spid INT
DECLARE CurSPID CURSOR FAST_FORWARD
FOR
SELECT SPID
FROM master.dbo.sysprocesses (NOLOCK)
WHERE spid>50
AND status='sleeping'
AND DATEDIFF(MINUTE,last_batch,GETDATE())>4 --minutos se puede modificar
AND spid<>@@spid
OPEN CurSPID
FETCH NEXT FROM CurSPID INTO @user_spid
WHILE (@@FETCH_STATUS=0)
BEGIN
PRINT 'Killing '+CONVERT(VARCHAR,@user_spid)
EXEC('KILL '+@user_spid)
FETCH NEXT FROM CurSPID INTO @user_spid
END
CLOSE CurSPID
DEALLOCATE CurSPID
GO