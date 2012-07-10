/*******************************************************************************/

/*
Pacientes treated by each doctor in the last month.
*/

CREATE VIEW pacientesPorMedico AS
SELECT sanitario.dni, sanitario.nombre as Medico, paciente.dni as DNIPaciente, paciente.nombre as NombrePaciente, admision.fecha
FROM paciente,sanitario, ficha, admision
WHERE sanitario.tipo = 'M' and sanitario.idPersonal = ficha.idMedico and admision.idAdmision = ficha.idAdmision 
and paciente.idPaciente = admision.idPaciente and admision.fecha = (select max(fecha) from admision)
order by sanitario.idPersonal desc;



/*******************************************************************************/
/*
Available beds in each room. 
*/
CREATE VIEW camasLibres AS 
select idHospital, idSala, numeroSala, numCamas from sala where idSala not in(select idSala from admision)
union
select idHospital, sala.idSala, sala.numeroSala, sala.numCamas - count(*) from admision, sala where sala.idSala = admision.idSala 
group by idHospital, sala.idSala, sala.numeroSala, sala.numCamas 





/*******************************************************************************/
/*
Paciente history.
*/
CREATE VIEW historialPaciente AS 
select f.idFicha, p.dni, p.nombre, a.idSala as Sala, a.fechaInicio as FechaAdmision, a.fechaFin as FechaAlta, f.idMedico as idMedico, m.nombre as MedicoNombre, e.nombre as Enfermedad, r.comentario as comentario, r.fecha as fechaResultado
from paciente p, admision a, ficha f, resultado r, sanitario m, enfermedad e
where p.idPaciente = a.idPaciente and
a.idAdmision = f.idAdmision and
r.idFicha = f.idFicha and 
f.idMedico = m.idPersonal and
f.idEnfermedad = e.idEnfermedad
order by p.nombre





/*******************************************************************************/
/*
Guards made for employees in each month.
*/
CREATE VIEW guardiasPorMes AS
select nombre, fecha from sanitario s,sanitarioguardia sg, guardia g where s.tipo = 'M' and s.idPersonal = sg.idSanitario and sg.idGuardia = g.idGuardia order by nombre 



/*******************************************************************************/
/*
Number of free days available for personal reasons for each employee.
*/

select a.nombre, num from administracion a, (select idAdministracion, count(*) as num from diasPropios where fecha>CURRENT_DATE group by  idAdministracion) p where a.idPersonal = p.idAdministracion


/*******************************************************************************/
/*
Number of doctors in each hospital.
*/

CREATE VIEW medicosPorHospital AS 
select h.idHospital as idHospital, h.nombre as nombreHospital, count(*) as numero from hospital h, sanitario s 
where s.tipo ='M' and s.idHospital = h.idHospital
group by h.idHospital, h.nombre
order by idHospital


