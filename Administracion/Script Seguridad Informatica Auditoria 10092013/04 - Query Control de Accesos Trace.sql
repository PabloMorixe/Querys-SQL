/*Consulta datos de la base TRACE
  Tabla Trazas para login fallido LEDESMA_SAP_PI
  Muestra la ultima semana
*/

SELECT EventClass, ApplicationName, HostName, LoginName, StartTime, TextData
FROM TRACE..TRAZAS
WHERE EventClass = 20
AND StartTime > GETDATE()-7
ORDER BY StartTime DESC
