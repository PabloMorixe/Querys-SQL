Query #54 Bad NC Indexes

What you are looking for with this query are indexes that have high numbers of writes and very few or even zero reads. If you are paying the cost to maintain an index as the data changes in your table, but the index is never used for reads, then you are placing unneeded stress on your storage subsystem that is not providing any benefits to the system. Having unused indexes also makes your database larger, and makes index maintenance more time consuming and resource intensive.

One key point to keep in mind before you start dropping indexes that appear to be unused is how long your SQL Server instance has been running. Before you drop an index, consider whether you have seen your complete normal business cycle. Perhaps there are monthly reports that actually do use an index that normally does not see any read activity with your regular workload.






-- Possible Bad NC Indexes (writes > reads)  (Query 54) (Bad NC Indexes)
   SELECT OBJECT_NAME(s.[object_id]) AS [Table Name], i.name AS [Index Name], i.index_id, 
   i.is_disabled, i.is_hypothetical, i.has_filter, i.fill_factor,
   user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads],
   user_updates - (user_seeks + user_scans + user_lookups) AS [Difference]
   FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
   INNER JOIN sys.indexes AS i WITH (NOLOCK)
   ON s.[object_id] = i.[object_id]
   AND i.index_id = s.index_id
   WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
   AND s.database_id = DB_ID()
   AND user_updates > (user_seeks + user_scans + user_lookups)
   AND i.index_id > 1
   ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE);
    
   -- Look for indexes with high numbers of writes and zero or very low numbers of reads
  -- Consider your complete workload, and how long your instance has been running
   -- Investigate further before dropping an index!