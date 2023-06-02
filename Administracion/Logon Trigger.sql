USE master;
GO


CREATE TRIGGER TR_LOGIN
ON ALL SERVER
FOR LOGON
AS
BEGIN
	
	IF APP_NAME() = 'Visual Basic'
	BEGIN
		ROLLBACK;
	END
	
END;



DROP TRIGGER TR_LOGIN ON ALL SERVER