use SqlMant

CREATE TABLE dbo.sessions_alert(
[host_name] nvarchar(128) NULL,
[program_name] nvarchar(128) NULL,
login_name nvarchar(128) NULL,
DB varchar(100) NULL,
num_sessions int NULL,
capture_time datetime NULL
) ON [PRIMARY]
GO
