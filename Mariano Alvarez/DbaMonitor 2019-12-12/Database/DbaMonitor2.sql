USE [master]
GO

ALTER DATABASE [DbaMonitor2] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

DROP DATABASE [DbaMonitor2]
go

CREATE DATABASE [DbaMonitor2]
GO
USE [DbaMonitor2]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monitor_Alerts](
	[ServerName] [nvarchar](128) NULL,
	[LocalCollectTime] [datetime] NOT NULL,
	[name] [sysname] NOT NULL,
	[event_source] [nvarchar](100) NOT NULL,
	[message_id] [int] NOT NULL,
	[severity] [int] NOT NULL,
	[enabled] [tinyint] NOT NULL,
	[has_notification] [int] NOT NULL,
	[delay_between_responses] [int] NOT NULL,
	[occurrence_count] [int] NOT NULL,
	[last_occurrence_date] [int] NOT NULL,
	[last_occurrence_time] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Monitor_BackupInfo]    Script Date: 12/12/2019 12:44:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monitor_BackupInfo](
	[ServerName] [nvarchar](128) NULL,
	[CollectTime] [datetime] NOT NULL,
	[DbName] [sysname] NOT NULL,
	[BackupMB] [bigint] NULL,
	[DurationSecs] [int] NULL,
	[LastBackup] [datetime] NULL,
	[ElapsedHours] [int] NULL,
	[DbRecoveryModel] [nvarchar](60) NULL,
	[DbState] [nvarchar](60) NULL,
	[BackupType] [varchar](21) NOT NULL,
	[PhysicalDeviceName] [nvarchar](260) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Monitor_DatabaseFiles]    Script Date: 12/12/2019 12:44:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monitor_DatabaseFiles](
	[ServerName] [nvarchar](128) NULL,
	[CollectTime] [datetime] NOT NULL,
	[DbName] [nvarchar](128) NULL,
	[FileId] [int] NOT NULL,
	[DbFileName] [sysname] NOT NULL,
	[FileType] [nvarchar](60) NULL,
	[StateDesc] [nvarchar](60) NULL,
	[SizeMB] [bigint] NULL,
	[UsedMB] [numeric](26, 6) NULL,
	[MaxSizeMB] [bigint] NULL,
	[IsPercentGrowth] [bit] NOT NULL,
	[GrowthPercent] [int] NULL,
	[GrowthMB] [bigint] NULL,
	[NextGrowMB] [numeric](37, 6) NULL,
	[FileIsReadOnly] [bit] NOT NULL,
	[FileIsSparse] [bit] NOT NULL,
	[PhysicalName] [nvarchar](260) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Monitor_DatabaseInfo]    Script Date: 12/12/2019 12:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monitor_DatabaseInfo](
	[ServerName] [nvarchar](128) NULL,
	[CollectTime] [datetime] NOT NULL,
	[dbName] [varchar](255) NULL,
	[ParentObject] [varchar](255) NULL,
	[Object] [varchar](255) NULL,
	[Field] [varchar](255) NULL,
	[Value] [varchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Monitor_Databases]    Script Date: 12/12/2019 12:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monitor_Databases](
	[ServerName] [nvarchar](128) NULL,
	[CollectTime] [datetime] NOT NULL,
	[DbName] [sysname] NOT NULL,
	[DbOwner] [nvarchar](128) NULL,
	[RecoveryModel] [nvarchar](60) NULL,
	[LogReuseWaitDescription] [nvarchar](60) NULL,
	[DbCompatibilityLevel] [tinyint] NOT NULL,
	[PageVerifyOption] [nvarchar](60) NULL,
	[is_auto_create_stats_on] [bit] NULL,
	[is_auto_update_stats_on] [bit] NULL,
	[is_auto_update_stats_async_on] [bit] NULL,
	[is_parameterization_forced] [bit] NULL,
	[snapshot_isolation_state_desc] [nvarchar](60) NULL,
	[is_read_committed_snapshot_on] [bit] NULL,
	[is_auto_close_on] [bit] NOT NULL,
	[is_auto_shrink_on] [bit] NULL,
	[is_published] [bit] NOT NULL,
	[is_distributor] [bit] NOT NULL,
	[is_trustworthy_on] [bit] NULL,
	[collation_name] [sysname] NULL,
	[create_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Monitor_DiskFree]    Script Date: 12/12/2019 12:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monitor_DiskFree](
	[ServerName] [nvarchar](128) NULL,
	[CollectTime] [datetime] NOT NULL,
	[DeviceID] [varchar](40) NOT NULL,
	[VolumeName] [varchar](40) NOT NULL,
	[TotalSize] [int] NOT NULL,
	[FreeSize] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Monitor_ServerProperties]    Script Date: 12/12/2019 12:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monitor_ServerProperties](
	[ServerName] [nvarchar](128) NULL,
	[CollectTime] [datetime] NOT NULL,
	[MachineName] [sql_variant] NULL,
	[Instance] [sql_variant] NULL,
	[SqlServerIp] [nvarchar](30) NULL,
	[InstanceRootDir] [nvarchar](500) NULL,
	[IsClustered] [sql_variant] NULL,
	[ComputerNamePhysicalNetBIOS] [sql_variant] NULL,
	[Edition] [sql_variant] NULL,
	[ProductLevel] [sql_variant] NULL,
	[ProductUpdateLevel] [sql_variant] NULL,
	[ProductVersion] [sql_variant] NULL,
	[ProductMajorVersion] [nvarchar](128) NULL,
	[ProductMinorVersion] [nvarchar](128) NULL,
	[ProductBuild] [sql_variant] NULL,
	[ProductBuildType] [sql_variant] NULL,
	[ProductUpdateReference] [sql_variant] NULL,
	[ProcessID] [sql_variant] NULL,
	[Collation] [sql_variant] NULL,
	[IsFullTextInstalled] [sql_variant] NULL,
	[IsIntegratedSecurityOnly] [sql_variant] NULL,
	[FilestreamConfiguredLevel] [sql_variant] NULL,
	[IsHadrEnabled] [sql_variant] NULL,
	[HadrManagerStatus] [sql_variant] NULL,
	[InstanceDefaultDataPath] [sql_variant] NULL,
	[InstanceDefaultLogPath] [sql_variant] NULL,
	[BuildCLRVersion] [sql_variant] NULL,
	[IsXTPSupported] [sql_variant] NULL,
	[IsPolybaseInstalled] [sql_variant] NULL,
	[IsRServicesInstalled] [sql_variant] NULL,
	[VersionDescrip] [nvarchar](300) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Monitor_SysConfigurations]    Script Date: 12/12/2019 12:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monitor_SysConfigurations](
	[ServerName] [nvarchar](128) NULL,
	[CollectTime] [datetime] NOT NULL,
	[ConfigName] [nvarchar](35) NOT NULL,
	[Value] [sql_variant] NULL,
	[ValueInUse] [sql_variant] NULL,
	[MinValue] [sql_variant] NULL,
	[MaxValue] [sql_variant] NULL,
	[description] [nvarchar](255) NOT NULL,
	[IsDynamic] [bit] NOT NULL,
	[IsAdvanced] [bit] NOT NULL
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [DbaMonitor2] SET  READ_WRITE 
GO

use DbaMonitor2
go


select 'truncate table ' + name  
from sys.tables
where name like 'Monitor%'


truncate table Monitor_Alerts
truncate table Monitor_BackupInfo
truncate table Monitor_DatabaseFiles
truncate table Monitor_DatabaseInfo
truncate table Monitor_Databases
truncate table Monitor_DiskFree
truncate table Monitor_ServerProperties
truncate table Monitor_SysConfigurations