USE [AR_Supervielle_Individuos_ICHB]
GO

/****** Object:  StoredProcedure [dbo].[CopySwitchToCCI]    Script Date: 6/6/2023 09:09:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CopySwitchToCCI]
AS
BEGIN
	INSERT INTO [dbo].[BETransactionLogs_CCI] (
		[BETransactionLogId],
   		[RequestDate],
   		[ResponseDate],
   		[UserId],
   		[BETransactionStatusId],
   		[MessegeRequest],
   		[MessageResponse],
   		[BETransactionId]
	)
	SELECT
		[BETransactionLogId],
   		[RequestDate],
   		[ResponseDate],
   		[UserId],
   		[BETransactionStatusId],
   		CONVERT(nvarchar(max), [MessegeRequest]) AS [MessegeRequest],
   		CONVERT(nvarchar(max), [MessageResponse]) AS [MessageResponse],
   		[BETransactionId]
	FROM [dbo].[BETransactionLogs_switch]
END
GO


