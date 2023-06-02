update Implementacion
set 
       idestado = 2,
       MotivoRechazo = 'Solicitado via email por el referente'    
where IdImplementacion in (23978,24045,24086)


update ImplementacionSM
set    
       IdEstadoSM=9,  
       Finalizada='S'     
where IdImplementacion  in (23978,24045,24086)
