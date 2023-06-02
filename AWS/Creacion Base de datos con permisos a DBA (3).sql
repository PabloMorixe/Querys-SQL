declare @databases varchar (400),
@stm varchar (4000),
@id varchar(100),
@cursor_db cursor,
@charSpliter CHAR;

--Definir las BBDD a migrar, separado por ' , '
SET @charSpliter = ',';
set @databases = 'api_cuentas_integral'+ @charSpliter;

--set @cursor_db = cursor static for 
--select value from STRING_SPLIT(@databases,',')


--open @cursor_db
WHILE CHARINDEX(@charSpliter, @databases) > 0
BEGIN
 -- fetch next from @cursor_db into @id
 -- if @@fetch_status <> 0 break
 SET @id  = SUBSTRING(@databases, 0, CHARINDEX(@charSpliter, @databases));
 SET @databases = SUBSTRING(@databases, CHARINDEX(@charSpliter, @databases) + 1, LEN(@databases)); 

set @stm = (select '
CREATE DATABASE [' + @id +'] CONTAINMENT = NONE ON
 PRIMARY 
( NAME = N'''+ @id +''', FILENAME = N''D:\rdsdbdata\DATA\'+ @id + '.mdf'' , SIZE = 65536KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'''+ @id + '_log'', FILENAME = N''D:\rdsdbdata\DATA\'+ @id + '_log.ldf'' , SIZE = 65536KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB)' + CHAR(13) + CHAR(10) +
' GO'+ CHAR(13) + CHAR(10) +
'
 IF (1 = FULLTEXTSERVICEPROPERTY(''IsFullTextInstalled''))
begin
EXEC [' + @id +'].[dbo].[sp_fulltext_database] @action = ''enable''
end ' + (CHAR(13)) + (CHAR(10)) +
'GO' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET ANSI_NULL_DEFAULT OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET ANSI_NULLS OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET ANSI_PADDING OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET ANSI_WARNINGS OFF 
GO ' + CHAR(13) + CHAR(10) + ' 
ALTER DATABASE [' + @id +'] SET ARITHABORT OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET AUTO_CLOSE OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET AUTO_SHRINK OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET AUTO_UPDATE_STATISTICS ON 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET CURSOR_DEFAULT  GLOBAL 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET CONCAT_NULL_YIELDS_NULL OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET NUMERIC_ROUNDABORT OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET QUOTED_IDENTIFIER OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET RECURSIVE_TRIGGERS OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET  DISABLE_BROKER 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET PARAMETERIZATION SIMPLE 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET READ_COMMITTED_SNAPSHOT OFF 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET RECOVERY SIMPLE 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET  MULTI_USER 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET PAGE_VERIFY CHECKSUM  
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET DELAYED_DURABILITY = DISABLED 
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET QUERY_STORE = OFF
GO ' + CHAR(13) + CHAR(10) + '
ALTER DATABASE [' + @id +'] SET  READ_WRITE 
GO ' + CHAR(13) + CHAR(10) + 
+ CHAR(13) + CHAR(10) + 
'/*********************************************************************/'+ CHAR(13) + CHAR(10) +
'--			PERMISOS OWNER AL GRUPO DBA PARA ADMINISTRACION'+ CHAR(13) + CHAR(10) +
'/*********************************************************************/'+ CHAR(13) + CHAR(10) +
+ CHAR(13) + CHAR(10) + 
'USE [' + @id +']
GO ' + CHAR(13) + CHAR(10) + '
CREATE USER [gscorp\SQL_admins] FOR LOGIN [gscorp\SQL_admins]
GO ' + CHAR(13) + CHAR(10) + '
ALTER ROLE [db_owner] ADD MEMBER [gscorp\SQL_admins]
GO ' + CHAR(13) + CHAR(10) + '');

print   @stm;
--exec @stm;
end

--close @cursor_db
--deallocate @cursor_db