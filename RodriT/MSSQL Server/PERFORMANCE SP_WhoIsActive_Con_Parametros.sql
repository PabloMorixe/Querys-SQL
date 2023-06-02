/*EXEC sp_WhoIsActive 
    @delta_interval = 10 ,
   @get_outer_command = 1, --Show Batch
    @get_plans = 1      -- Statement

    -- @sort_order = '[blocked_session_count] DESC'
*/

/*
-- analiza si hay bloqueos y los ordena de manera descendente

EXEC sp_WhoIsActive
    @find_block_leaders = 1,
    @sort_order = '[blocked_session_count] DESC'

*/