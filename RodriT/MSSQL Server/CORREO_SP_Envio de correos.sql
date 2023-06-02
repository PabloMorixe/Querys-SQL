ALTER PROCEDURE Enviar_Correo
(
    @Asunto varchar(max),
    @Cuerpo varchar(max)
)
WITH EXECUTE AS 'GSCORP\servicetec', ENCRYPTION AS
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'servicetec',
    @recipients = 'DZapata.ITRESOURCES@supervielle.com.ar',
    @body = @Cuerpo,
    @subject = @Asunto;
GO
