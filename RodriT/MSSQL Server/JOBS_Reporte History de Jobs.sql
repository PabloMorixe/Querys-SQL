-- Variable Declarations 

DECLARE @PreviousDate datetime  
DECLARE @Year VARCHAR(4)   
DECLARE @Month VARCHAR(2)  
DECLARE @MonthPre VARCHAR(2)  
DECLARE @Day VARCHAR(2)  
DECLARE @DayPre VARCHAR(2)  
DECLARE @FinalDate INT  

-- Initialize Variables  
SET @PreviousDate = DATEADD(dd, -1, GETDATE()) -- Last 1 day   
SET @Year = DATEPART(yyyy, @PreviousDate)   
SELECT @MonthPre = CONVERT(VARCHAR(2), DATEPART(mm, @PreviousDate))  
SELECT @Month = RIGHT(CONVERT(VARCHAR, (@MonthPre + 1000000000)),2)  
SELECT @DayPre = CONVERT(VARCHAR(2), DATEPART(dd, @PreviousDate))  
SELECT @Day = RIGHT(CONVERT(VARCHAR, (@DayPre + 1000000000)),2)  
SET @FinalDate = CAST(@Year + @Month + @Day AS INT)  

-- Final Logic 

SELECT   
		j.[name] as Job,  
         --s.step_name,  
         --h.step_id,  
         --h.step_name,  
         h.run_date,  
         --h.run_time,
		 --h.run_duration
		 substring(right('0000'+cast(h.run_duration as varchar(6)),6),1,2)*60 +
		 substring(right('0000'+cast(h.run_duration as varchar(6)),6),3,2) as [Duracion(MIN)]
         --h.sql_severity,  
         --h.message,   
         --h.server  
FROM     msdb.dbo.sysjobhistory h  
         INNER JOIN msdb.dbo.sysjobs j  
           ON h.job_id = j.job_id  
         INNER JOIN msdb.dbo.sysjobsteps s  
           ON j.job_id = s.job_id 
           AND h.step_id = s.step_id  
WHERE    
		--h.run_status = 0 -- Failure  
		h.run_status = 1 -- Success
         --AND h.run_date > @FinalDate  
		 and j.[name] like '%P - FULL'

ORDER BY h.instance_id DESC 