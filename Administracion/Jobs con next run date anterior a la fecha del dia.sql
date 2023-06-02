select J.name, JS.*
from msdb..sysjobschedules JS
inner join msdb..sysjobs J
on JS.job_id = J.job_id
inner join msdb..sysschedules S
on JS.schedule_id = S.schedule_id
where JS.next_run_date < '20140103' --Falta obtener y parsear la fecha actual
and J.enabled = 1
and S.enabled = 1
and JS.next_run_date > 0
