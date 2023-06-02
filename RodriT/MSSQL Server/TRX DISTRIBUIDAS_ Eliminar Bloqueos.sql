Killing an MSDTC transaction
So, you’ve come up against an MSDTC transaction that the MSDTC service has been unable to successfully commit or rollback.
This transaction has now left locks on your data that are associated with an orphaned SPID and you’ve got no option but to kill that MSDTC transaction.
You first need to retrieve the UoW ID. This should be displayed in the MSDTC console, but to verify it is the correct ID, you can interrogate the syslockinfo system view. Specifically the req_transactionUoW column. The req_spid column in syslockinfo hosts the SPID number.
So, to pull out the UoW ID for an orphaned MSDTC transaction you just need to run the following query:
select req_transactionUoW as [UoW ID] from syslockinfo where req_spid = -2
The above will work in SQL Server 2000 onward, but from SQL Server 2005, it’s more politically correct to use the DMVs, so the table and column names have changed slightly:

select request_owner_guid as [UoW ID] from sys.dm_tran_locks where request_session_id = -2

Then to kill it:

kill {'UoW ID'}

where {UoW ID} is the result of the above select statement.
However, this must only be done as an absolute last resort when other methods, such as e.g. restarting the applications/processes involved in that distributed transaction do not resolve the problem. At the end of the day, those locks will have been placed for a reason, so you don’t know if the consistency of the data is now compromised especially if syslockinfo/sys.dm_tran_locks shows the MSDTC transaction(s) concerned have placed exclusive locks on objects.
The default behaviour for handling in-doubt MSDTC transactions can be altered from the default of doing nothing and letting the DBA handle it, to either abort or commit the transaction automatically.
It is configured by specifying the server configuration option ‘in-doubt xact resolution’ as documented in BOL. Check the documentation on this carefully, particularly the note on ensure that all servers involved in the transaction have the same setting for this option.


Los links son: 

http://www.eraofdata.com/orphaned-msdtc-transactions-2-spids/ 
http://technet.microsoft.com/en-us/library/aa275795(v=sql.80).aspx 
