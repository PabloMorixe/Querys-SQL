--Opciones

ALTER DATABASE [Test4] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
OR
ALTER DATABASE [Test4] SET SINGLE_USER WITH ROLLBACK AFTER 30
OR
ALTER DATABASE [Test4] SET SINGLE_USER WITH NO_WAIT


/*

    * WITH ROLLBACK IMMEDIATE - this option doesn't wait for transactions to complete it just begins rolling back all open transactions
    * WITH ROLLBACK AFTER nnn - this option will rollback all open transactions after waiting nnn seconds for the open transactions to complete.  In our example we are specifying that the process should wait 30 seconds before rolling back any open transactions.
    * WITH NO_WAIT - this option will only set the database to single user mode if all transactions have been completed.  It waits for a specified period of time and if the transactions are not complete the process will fail.  This is the cleanest approach, because it doesn't rollback any transactions, but it will not always work if there are open transactions.

*/

