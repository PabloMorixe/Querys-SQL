USE [TRACE]
GO
/****** Object:  StoredProcedure [dbo].[sp_Traza_UsoDeBases]    Script Date: 11/08/2017 03:20:56 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_Traza_UsoDeBases]
                        @archivodetraza  nvarchar(300),
                        @ciclar          bit = 1

AS

BEGIN

/*
AUTOR: Pablo Morixe - pablo.morixe@gmail.com
DESCRIPCION: Crea y renueva una traza de accesos a bases de dudosa actividad
PARAMETROS: @archivodetraza = Path + nombre de archivo de traza (.trc) - Colocar CON extension
            @ciclar         = Indica si el ciclo se repite (default) o si luego del volcado no se recrea
FECHA CREACION: 06/07/2015
*/

/* ------------------------------------------------------ */
/*                   SERVIDOR: CLSQL06                    */
/* ------------------------------------------------------ */

/***** 1 - DECLARACION DE VARIABLES DE ALCANCE DE SP *****/

  DECLARE @TraceID           int
  DECLARE @SQLcommand        varchar(MAX)

/***** 2 - DETECCION DE LA TRAZA *****/

  -- Busca e ingresa el ID de la traza en @IDTraza
  
  SELECT @TraceID = tr.[id]
  FROM sys.traces AS tr
  WHERE tr.[path] = @archivodetraza
  
  IF (@TraceID IS NOT NULL)  --> Si la traza existe previamente...
    GOTO VOLCADO             --  ...vuelca los datos a tabla
  ELSE                       --  y si no existe tal traza...
    GOTO CREACION            --  ...la crea desde cero

/***** 3 - VOLCADO DE DATOS (si corresponde) *****/

  VOLCADO:
  
  BEGIN
  
    /*-- 3.1 - DETENCION Y BORRADO DE LA TRAZA --*/
    
    EXEC sp_trace_setstatus @TraceID, 0
    EXEC sp_trace_setstatus @TraceID, 2

    /*-- 3.2 - CREACION Y VOLCADO DE LA TRAZA EN TABLA TEMPORAL --*/
    
    CREATE TABLE #Traza_UsoDeBases_TEMP ( [Base] sysname null )
    
    INSERT INTO #Traza_UsoDeBases_TEMP
    SELECT DISTINCT [DatabaseName]
    FROM ::fn_trace_gettable(@archivodetraza, DEFAULT)
    WHERE [DatabaseName] IS NOT NULL  --> Ver columnas registradas por la traza
      AND [Success] = 1
      AND [LoginName] not like 'CENTRAL\PMORIXE'
      AND [LoginName] not like 'CENTRAL\gmantei'


    /*-- 3.3 - REGISTRO DE RESULTADOS DEL TRAZADO --*/

    UPDATE [Trace].[dbo].[tb_psTraza_BasesActivas]
    SET [DetecAcceso] = 1,
        [UltimoAcceso] = GETDATE()
    WHERE [BaseDeDatos] IN (select [Base] from #Traza_UsoDeBases_TEMP)

    /*-- 3.4 - BORRADO DE TABLA TEMPORAL Y ARCHIVO TRC --*/
    
    DROP TABLE #Traza_UsoDeBases_TEMP
    
    SET @SQLcommand = 'master..xp_cmdshell ''DEL "' + @archivodetraza + '"'''
    EXECUTE(@SQLcommand)
    
    /*-- 3.5 - CREACION DE LA NUEVA TRAZA (según parámetro) --*/
    
    IF (@ciclar = 1)
      GOTO CREACION
    ELSE
      GOTO FINAL
  
  END

/***** 4 - CREACION DE UNA NUEVA TRAZA *****/

  CREACION:
  
  BEGIN
 
    /*-- 4.1 - DECLARACION DE VARIABLES DE BLOQUE --*/
 
    DECLARE @rc              int
    DECLARE @on              bit = 1
    DECLARE @maxfilesize     bigint = 2048 --> MB - Modificar si fuera necesario

    /*-- 4.2 - CREACION DE LA NUEVA TRAZA --*/
    
    SET @archivodetraza = REPLACE(@archivodetraza,'.trc','')
    EXEC @rc = sp_trace_create @TraceID OUTPUT, 0, @archivodetraza, @maxfilesize, NULL

    /*-- 4.3 - SETEO DE EVENTOS Y FILTROS --*/

    IF (@rc = 0)  --> Si no hubo un error en la creacion de la traza
  
    BEGIN
    
      -- EVENTOS:
    
      -- DATABASE OBJECT ACCESS
      EXEC sp_trace_setevent @TraceID, 114, 11, @on --> LoginName
      EXEC sp_trace_setevent @TraceID, 114, 35, @on --> DatabaseName
      EXEC sp_trace_setevent @TraceID, 114, 23, @on --> Success


      -- FILTROS:
      
      -- Se indican los Logins que NO se registraran  --> AND LoginName NOT LIKE (0,7)
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'LedesmaSystemAdministrator'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'public'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'sysadmin'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'securityadmin'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'serveradmin'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'setupadmin'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'processadmin'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'diskadmin'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'dbcreator'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'bulkadmin'
      
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'##MS_SQLResourceSigningCertificate##'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'##MS_SQLReplicationSigningCertificate##'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'##MS_SQLAuthenticatorCertificate##'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'##MS_PolicySigningCertificate##'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'##MS_SmoExtendedSigningCertificate##'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'##MS_PolicyTsqlExecutionLogin##'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'##MS_PolicyEventProcessingLogin##'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'##MS_AgentSigningCertificate##'
      
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'NT AUTHORITY\SYSTEM'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'NT SERVICE\MSSQLSERVER'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'NT SERVICE\ClusSvc'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'NT SERVICE\SQLSERVERAGENT'
      
      -- Accesos que no sean del SQLAgent
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'CENTRAL\SQL_CLSQL06_SqlSrv'
      EXEC sp_trace_setfilter @TraceID, 11, 0, 7, N'CENTRAL\SQL_CLSQL06_SqlAgent'
      
      -- Se indican las DBs que NO se registraran  --> AND DatabaseName NOT LIKE (0,7)
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'master'
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'model'
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'msdb'
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'tempdb'
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'distribution'
      
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'DBA_TOOLS'
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'TRACE'
      
      -- COMENTAR LAS BASES QUE SE VAN A TRAZAR (V: Verificado con traza / NT: Nunca trazado)
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'AFIP_CAE' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'AFIP_CAE_MI' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'AGROGESTOR' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'AquilesmasterDB' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'ARIS' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'ARIS_PUBLISHER' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'BasculaGlucovil' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'BIRCOS' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'BPM_DATA' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'CENCERRO' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'CencerroSAP' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'CHECKBANK' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'CHECKBANK_DIARIA' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'CMLEDESMA' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'COMMI' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'COMPRA_PC' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'ComprasAzucar' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'ControlarEmpresa' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'ControlarHistoric' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'D_STG_CTR' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'DOCUMENTOS_DIGITALES' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'EFACTURA_V2' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'EFRAMEWORK' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'EFRAMEWORK_CLSQL05' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'eFramework2IG' --> NT
      --EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'EM_DATAWAREHOUSE'
      --EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'EM_METADATA'
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'EPM_Auditoria' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'EPM_Memos' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Epm_RRHH' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'EPM_Sistemas' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'EVDESEMPENIO' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Exportaciones' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'FEEDLOT_BIZNAGA' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'FEEDLOT_CENTELLA' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'HARAS' --> NV
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'HARAS_POST' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'IADB' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'IAS' --> NV
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'IG_COMPRA_PC' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Importaciones' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Informes_Gestion' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Informes_Gestion_Balances' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Informes_Gestion_Ccp' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Informes_Gestion_Proveedores' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Informes_Gestion_Vm' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Integracion' --> NV
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'InterfacesMAP' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'INTERFASE_BIZNAGA' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'INTERFASE_CENTELLA' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'InventarioAplicaciones' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'LEDE_BIZNAGA' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Levicom_FacturaElectronica' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'LOGISTICA' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'LOGISTICA_BIZNAGA' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'MAT' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'MCCDB' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'MOLINETES' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'MPX' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'MPXDATPROD' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'MUF' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'NotasCD' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'ORDENES_RETENIDAS' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'P_DW_METADATA' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'PasajesAereos' --> V
      --EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Piryp'
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'pptocomercial' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'PROD_GLUCOVIL' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'QYR' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Rendiciones' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'REQ_SERVICIO' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SALC' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SAMPI' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SAMPI_HIST' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SG1_MPX' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SG2_MPX' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Siclar' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SIPRELIB' --> V
      --EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SOPORTECA'
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SPCP_ENCAPADO' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SPF' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SPF_BIZNAGA' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SPF_GLUCOVIL' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SSRS_ACNT47' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'SSRS_ACNT47TempDB' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'StagingSAP' --> NT
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'Suia' --> V
      EXEC sp_trace_setfilter @TraceID, 35, 0, 7, N'VentaCuadernos' --> V
           
      --> AND Success EQUAL (0,0)
      EXEC sp_trace_setfilter @TraceID, 23, 0, 0, 1 --> Solo los accesos exitosos a las DBs
    
    /*-- 4.4 - INICIO DE LA TRAZA CREADA --*/
    
      EXEC sp_trace_setstatus @TraceID, 1
    
    END
    
    GOTO FINAL
  
  END
  
  FINAL:

END




























GO
