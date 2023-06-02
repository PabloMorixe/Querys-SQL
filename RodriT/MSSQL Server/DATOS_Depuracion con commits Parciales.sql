/*depuracion*/      
       use <Base de datos>
       SET QUOTED_IDENTIFIER ON
       DECLARE @selected_Rows INT
       declare @waitfor varchar(5)
       SET @selected_Rows = 1;
       --set @waitfor='00:00:05';
       WHILE (@selected_Rows > 0)
       BEGIN
             BEGIN TRAN   
             
                    delete top (5000)  FROM [Tableros].[portal].[portal_mart_alertas_crediticas_operacion] where cta_fec_carga >= 20180101

             select @selected_Rows = @@ROWCOUNT
             COMMIT TRAN         
             --WAITFOR DELAY @waitfor
       END
