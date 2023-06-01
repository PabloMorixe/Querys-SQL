
--**************************************

-- Obtiene listado de ETLS en la msdb.

-- En el listado que resulte cambiar el path .\  por la ubicacion donde se quiere guardar los ETL y ejecutarlo en un CMD.

--**************************************


WITH FOLDERS AS
(
    -- Capture root node
    SELECT
        cast(PF.foldername AS varchar(max)) AS FolderPath
    ,   PF.folderid
    ,   PF.parentfolderid
    ,   PF.foldername
    FROM
        msdb.dbo.sysssispackagefolders PF
    WHERE
        PF.parentfolderid IS NULL

    -- build recursive hierarchy
    UNION ALL
    SELECT
        cast(F.FolderPath + 'F:\BORRAR\' + PF.foldername AS varchar(max)) AS FolderPath
    ,   PF.folderid
    ,   PF.parentfolderid
    ,   PF.foldername
    FROM
        msdb.dbo.sysssispackagefolders PF
        INNER JOIN
            FOLDERS F
            ON F.folderid = PF.parentfolderid
)
,   PACKAGES AS
(
    -- pull information about stored SSIS packages
    SELECT
        P.name AS PackageName
    ,   P.id AS PackageId
    ,   P.description as PackageDescription
    ,   P.folderid
    ,   P.packageFormat
    ,   P.packageType
    ,   P.vermajor
    ,   P.verminor
    ,   P.verbuild
    ,   suser_sname(P.ownersid) AS ownername
    FROM
        msdb.dbo.sysssispackages P
)
SELECT 
    -- assumes default instance and localhost
    -- use serverproperty('servername') and serverproperty('instancename') 
    -- if you need to really make this generic
    'dtutil /sourceserver ' + @@SERVERNAME + ' /SQL "'+ F.FolderPath + '\' + P.PackageName + '" /copy file;"F:\BORRAR\' + P.PackageName +'.dtsx"' AS cmd
FROM 
    FOLDERS F
    INNER JOIN
        PACKAGES P
        ON P.folderid = F.folderid
-- uncomment this if you want to filter out the 
-- native Data Collector packages
   WHERE
   F.FolderPath <> '\Data Collector'