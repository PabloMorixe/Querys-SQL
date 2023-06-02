/***********************************************************************************************************************  
        Version 1.0  
        19 Aug 2010  
  
        Gregory Ferdinanddsen  
        greg@ferdinandsen.com  
  
  
            This SP will rebuild/reorg indexes.  
  
        Parameters:  
            @DB = Either 'All' or the name of one DB. If 'All' all databases on the server are examined; otherwise the name of a single DB.  
            @Stats = Statistical Sampling Method (Limited, Sampled, or Detailed) for determining what index will be impacted.  
                --LIMITED - It is the fastest mode and scans the smallest number of pages.   
                        For an index, only the parent-level pages of the B-tree (that is, the pages above the leaf level) are scanned  
                --SAMPLED - It returns statistics based on a 1 percent sample of all the pages in the index or heap.   
                        If the index or heap has fewer than 10,000 pages, DETAILED mode is used instead of SAMPLED.  
                --DETAILED - It scans all pages and returns all statistics.  
            @MinPageCount = Since index with few pages usually don't defrag (and a table scan is preferred), ignores small indexes  
            @MaxPageCount = Maximum number of index pages to be considered. This can preclude very large indexes  
            @Fill Factor = Specifies a percentage that indicates how full the Database Engine should make the leaf level of each index page   
                    during index creation or alteration. fillfactor must be an integer value from 1 to 100. The default is 0.  
            @PAD_Index = The percentage of free space that is specified by FILLFACTOR is applied to the intermediate-level pages of the index.   
                If FILLFACTOR is not specified at the same time PAD_INDEX is set to ON, the fill factor value stored in sys.indexes is used.  
            @SortInTempDB = The intermediate sort results that are used to build the index are stored in tempdb.   
                If tempdb is on a different set of disks than the user database, this may reduce the time needed to create an index.   
                However, this increases the amount of disk space that is used during the index build.  
            @Online = Online rebuild, for editions that support online rebuild (for editions that do not support online rebuild, this is ignored)  
            @ReBuildTheshold = The threshold for deciding to rebuild v reorg (MSFT recomend's 30)  
            @ReOrgThreshold = The threshold for deciding to rebuild v reorg (MSFT recomend's 5)  
            @MaxFrag = The maximum amount of fragmentation to defrag (i.e. you don't want to defrag an index over 80%)  
            @ChangeRecoveryModel = Set's the DB's in simple recovery mode prior to starting, reverts back to original mode on completion.  
  
            NB:  
            @Fill_Factor, @PAD_Index will only be applied to index that are rebuilt (Fragmentation >= @ReBuildTheshold)  
  
  
            Alter Index -- http://technet.microsoft.com/en-us/library/ms188388.aspx  
            sys.dm_db_index_physical_stats -- http://msdn.microsoft.com/en-us/library/ms188917.aspx  
  
        examples:  
            exec dbadmin..sp_Defrag_Indexes, @FillFactor = 75, @PAD_Index = 'true', @Stats = 'Detailed'  
  
            exec dbadmin..sp_Defrag_Indexes  
                @DB = 'changepoint',  
                @FillFactor = 65,  
                @PAD_Index = 'true',  
                @Stats = 'Detailed',  
                @ChangeRecoveryModel = 'true',  
                @minpagecount = 150  
***********************************************************************************************************************/  
  
ALTER procedure [dbo].[sp_Defrag_Indexes]  
    (  
    @DB varchar(256) = 'all',  
    @Stats varchar(8) = 'sampled',  
    @MinPageCount int = 20,  
    @MaxPageCount float = 1000000000000000, --A very large default number  
    @FillFactor int = NULL,  
    @PAD_Index varchar(8) = 'false',  
    @SortInTempDB varchar(8) = 'true',  
    @OnlineReq varchar(8) = 'true',  
    @ReBuildTheshold real = 30.0,  
    @ReOrgThreshold real = 5.0,  
    @MaxFrag real = 100.0,  
    @ChangeRecoveryModel varchar(8) = 'false'  
    )  
  
    as  
  
    declare @SQLCmd as varchar (8000)  
    declare @SQLCmdBk as varchar(4096)  
    declare @SQLCmdWith as varchar(4096)  
    declare @SQLCmdFill varchar(512)  
    declare @SQLCmdOnline varchar(512)  
    declare @SQLCmdPad varchar(512)  
    declare @SQLCmdSort varchar(512)  
    declare @SQLCmdRecovery varchar(512)  
    declare @exit varchar(8)  
    declare @ErrorTxt as varchar(128)  
    declare @SQLEdition as varchar(64)  
    declare @Online as varchar(8)  
    declare @DBName as varchar(256)  
    declare @ObjectID int  
    declare @IndexID int  
    declare @PartitionNum as bigint  
    declare @Frag as float  
    declare @PageCount as bigint  
    declare @PartitionCount as bigint  
    declare @ParititionNum as bigint  
    declare @IndexName as varchar(128)  
    declare @SchemaName as varchar(128)  
    declare @ObjectName as varchar(128)  
    declare @ParmDef nvarchar(512)  
    declare @SQLCmdID as nvarchar(1024)  
    declare @RecoveryModel as varchar(16)  
  
    --Verify that proper parameters were passed to SP  
    if @Stats not in ('limited', 'sampled', 'detailed')  
        begin  
            RaisError ('@Stats must be "limited", "sampled", or "detailed"', 16, 1)  
            return  
        end  
  
    if @PAD_Index not in ('true', 'false')  
        begin  
            RaisError ('@PAD_Index must be "true" or "false"', 16, 1)  
            return  
        end  
  
    if @SortInTempDB not in ('true', 'false')  
        begin  
            RaisError ('@SortInTempDB must be "true" or "false"', 16, 1)  
            return  
        end  
  
    if @OnlineReq not in ('true', 'false')  
        begin  
            RaisError ('@OnlineReq must be "true" or "false"', 16, 1)  
            return  
        end  
  
    if @FillFactor not between 0 and 100  
        begin  
            RaisError ('@FillFactor must be between 0 and 100', 16, 1)  
            return  
        end  
  
    if @ReBuildTheshold not between 1 and 100  
        begin  
            RaisError ('@ReBuildTheshold must be between 1 and 100', 16, 1)  
            return  
        end  
  
    if @ReOrgThreshold not between 1 and 100  
        begin  
            RaisError ('@ReOrgThreshold must be between 1 and 100', 16, 1)  
            return  
        end  
  
    --There would be nothing returned if MaxFrag was less than the reorg threshold.  
    if @MaxFrag not between @ReOrgThreshold and 100  
        begin  
            RaisError ('@MaxFrag must be between the @ReOrgThreshold value (default of 5) and 100', 16, 1)  
            return  
        end  
  
    if @MinPageCount < 0  
        begin  
            RaisError ('@MinPageCount must be positive', 16, 1)  
            return  
        end  
  
    if @MaxPageCount < 10  
        begin  
            RaisError ('@MaxPageCount must be greater than 10', 16, 1)  
            return  
        end  
  
    if @ChangeRecoveryModel not in ('true', 'false')  
        begin  
            RaisError ('@ChangeRecoveryModel must be "true" or "false"', 16, 1)  
            return  
        end  
  
    if @MinPageCount > @MaxPageCount  
        begin  
            RaisError ('@MinPageCount cannot be greater than @MaxPageCount', 16, 1)  
            return  
        end  
  
    if @DB <> 'All'  
        begin  
            if not exists (select name from sys.databases where name = @DB)  
                begin  
                    set @ErrorTxt = 'The supplied database (' + @DB + ') does not exist.'  
                    RaisError (@ErrorTxt, 16, 1)  
                    return  
                end  
        end  
  
    --You can't have rebuild be at a lower level than reorg  
    if @ReBuildTheshold < @ReOrgThreshold set @ReOrgThreshold = @ReBuildTheshold - 0.01  
  
    --Determine SQL Edition (for online rebuild -- Enterprise and Developer support online rebuild)  
    set @SQLEdition = cast(ServerProperty('Edition') as varchar)  
    set @SQLEdition =  
        case   
            when @SQLEdition = 'Enterprise Edition' then 'Enterprise'  
            when @SQLEdition = 'Standard Edition' then 'Standard'  
            when @SQLEdition = 'Developer Edition' then 'Developer'  
        end  
    if @SQLEdition = 'Enterprise' or @SQLEdition = 'Developer'  
        begin  
            set @Online = 'true'  
        end  
    else set @Online = 'false'  
  
    --If only one database, then go to the innser cursor (and exit that cursor before the fetch next command)  
    set @Exit = 'false'  
    If @DB <> 'All'  
        begin  
            set @Exit = 'true'  
            set @DBName = @DB  
            goto ExecuteForEachDatabase  
        end  
  
    --Outer Cursor for DBName  
    declare DatabaseNames cursor  
        for select name from sys.databases where is_read_only <> 1 and state = 0
  
        open DatabaseNames  
        fetch next from DatabaseNames into @DBName  
  
        while @@fetch_status <> -1  
            begin  
ExecuteForEachDatabase:  
                --Delete the Temp Table  
                if exists (Select * from tempdb.sys.objects where name = '#Fragmentation' and type in('U'))  
                    begin  
                        drop table #Fragmentation  
                    end  
  
                --Determine Recovery Model  
                set @RecoveryModel = cast(DatabasePropertyEx(@DBName, 'Recovery') as varchar(16))  
                If @RecoveryModel in ('FULL', 'BULK_LOGGED') and @ChangeRecoveryModel = 'true'  
                    begin  
                        set @SQLCmdRecovery = 'alter database ' + @DBName + ' set recovery simple with no_wait'  
                        print @DBName + ' recovery model set to simple.'  
                        exec (@SQLCmdRecovery)  
                    end  
  
                --Index_ID of 0 is a heap index, no need to defrag  
                select object_id as ObjectID, index_id as IndexID, partition_number as PartitionNum, avg_fragmentation_in_percent as Frag  
                    into #Fragmentation  
                    from sys.dm_db_index_physical_stats (DB_ID(@DBName), null, null , null, @Stats)  
                    where avg_fragmentation_in_percent >= @ReOrgThreshold and avg_fragmentation_in_percent < = @MaxFrag  
                        and index_id > 0  
                        and Page_Count >= @MinPageCount and Page_Count <= @MaxPageCount  
  
                --Inner Cursor (objects)  
                declare CurPartitions cursor  
                    for select * from #Fragmentation  
  
                    open CurPartitions  
                    fetch next from CurPartitions into @ObjectID, @IndexID, @ParititionNum, @Frag  
  
                    while @@fetch_status <> -1  
                        begin  
                            Set @SQLCmdID = 'select @ObjectName = quotename(obj.name), @SchemaName = quotename(sch.name) from ' + @DBName +   
                                '.sys.objects as obj join ' + @DBName + '.sys.schemas as sch on sch.schema_id = obj.schema_id where obj.object_id = @ObjectID'  
                            --select @ObjectName = quotename(obj.name), @SchemaName = quotename(sch.name)  
                            --    from sys.objects as obj  
                            --    join sys.schemas as sch on sch.schema_id = obj.schema_id  
                            --    where obj.object_id = @ObjectID  
                            set @ParmDef = N'@ObjectID int, @ObjectName sysname output, @SchemaName sysname output'  
                            exec sp_executesql @SQLCmdID, @ParmDef, @ObjectID= @ObjectID, @ObjectName = @ObjectName output, @SchemaName = @SchemaName output  
                                  
  
                            --select @IndexName = quotename(name)  
                            --    from sys.indexes  
                            --    where object_id = @ObjectID and index_id = @IndexID  
                            Set @SQLCmdID = 'select @IndexName = quotename(name) from ' + @DBName + '.sys.indexes where object_id = @ObjectID and index_id = @IndexID and name <> '''''  
                            set @ParmDef = N'@ObjectId int, @IndexId int, @IndexName sysname output'  
                            exec sp_executesql @SQLCmdID, @ParmDef, @ObjectId = @ObjectId, @IndexId = @IndexId, @IndexName = @IndexName output  
  
                            --select @PartitionCount = count (*)  
                            --    from sys.partitions  
                            --    where object_id = @ObjectID and index_id = @IndexID  
                            Set @SQLCmdID = 'select @PartitionCount = count (*) from ' + @DBName + '.sys.partitions where object_id = @ObjectID and index_id = @IndexID'  
                            set @ParmDef = N'@ObjectId int, @IndexId int, @PartitionCount int output'  
                            exec sp_executesql @SQLCmdID, @ParmDef, @ObjectId = @ObjectId, @IndexId = @IndexId, @PartitionCount = @PartitionCount output  
  
                            --ReOrg  
                            set @SQLCmdBk = null  
                            if @frag < @ReBuildTheshold  
                                begin  
                                    set @SQLCmdBk = 'alter index ' + @IndexName + ' on [' + @DBName + '].' + @SchemaName + '.' + @ObjectName + ' reorganize'  
                                end  
                            if @frag >= @ReBuildTheshold  
                                begin  
                                    set @SQLCmdBk = 'alter index ' + @IndexName + ' on [' + @DBName + '].' + @SchemaName + '.' + @ObjectName + ' rebuild'  
                                end  
  
                            --set options  
                            if @FillFactor is not null set @SQLCmdFill = 'fillfactor = ' + cast(@FillFactor as varchar(3))+ ', '  
                            if @Online = 'true' and @OnlineReq = 'true' set @SQLCmdOnline = 'online = on, '  
                            if @PAD_Index = 'true' set @SQLCmdPad = 'PAD_Index = on, '  
                            if @SortInTempDB = 'true' set @SQLCmdSort = 'Sort_in_TempDB = on, '  
  
                            if @PartitionCount > 1 set @SQLCmdBk = @SQLCmdBk + ' partition = ' + cast(@partitionnum as nvarchar(10))  
  
                            set @SQLCmdWith = ' with ('  
  
                            --With options only apply to rebuilds, not to re-org  
                            if @frag >= @ReBuildTheshold  
                                begin  
                                    if @SQLCmdFill is not null set @SQLCmdWith = @SQLCmdWith + @SQLCmdFill  
                                    if @SQLCmdOnline is not null set @SQLCmdWith = @SQLCmdWith + @SQLCmdOnline  
                                    if @SQLCmdPad is not null set @SQLCmdWith = @SQLCmdWith + @SQLCmdPad  
                                    if @SQLCmdSort is not null set @SQLCmdWith = @SQLCmdWith + @SQLCmdSort  
                                end  
  
                            if @SQLCmdWith <> ' with (' set @SQLCmdWith = left(@SQLCmdWith, len(@SQLCmdWith) - 1) + ')'  
                            if @SQLCmdWith <> ' with (' set @SQLCmd = @SQLCmdBk + @SQLCmdWith  
                            else set @SQLCmd = @SQLCmdBk  
  
                            --Print and execute  
                            exec (@SQLCmd)  
                            print @SQLCmd  
  
                            fetch next from CurPartitions into @ObjectID, @IndexID, @ParititionNum, @Frag  
                        end --CurPartitions  
                    close CurPartitions  
                    deallocate CurPartitions  
                    drop table #Fragmentation  
  
                    --If DB was in Full or Bulk_Logged and tlogging was disabled, then re-enable  
                    If @RecoveryModel in ('FULL', 'BULK_LOGGED') and @ChangeRecoveryModel = 'true'  
                        begin  
                            set @SQLCmdRecovery = 'alter database ' + @DBName + ' set recovery ' + @RecoveryModel + ' with no_wait'  
                            print @DBName + ' recovery model set to ' + @RecoveryModel + ' recovery model.'  
                            exec (@SQLCmdRecovery)  
                        end  
                    if @Exit = 'true' return  
  
                fetch next from DatabaseNames into @DBName  
            end --DatabaseNames  
    close DatabaseNames  
    deallocate DatabaseNames  
