--Progreso de mis backups

SELECT
    dm_er.session_id id_Sesion,
    dm_er.command Comando,
    CONVERT(NUMERIC(6, 2), dm_er.percent_complete) AS [Porcentaje Completedo],
    CONVERT(VARCHAR(20), Dateadd(ms, dm_er.estimated_completion_time, Getdate()),20) AS [Tiempo Estimado Finalizacion],
    CONVERT(NUMERIC(6, 2), dm_er.estimated_completion_time / 1000.0 / 60.0) AS [Minutos pendientes]
FROM
    sys.dm_exec_requests dm_er
WHERE  
    dm_er.command IN ( 'RESTORE VERIFYON', 'RESTORE DATABASE','BACKUP DATABASE','RESTORE LOG','BACKUP LOG', 'RESTORE HEADERON' )


