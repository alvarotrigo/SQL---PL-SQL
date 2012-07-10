
/*******************************************************************************/
/*
a) Returns the number of free beds for the given id_hospital 
*/

CREATE OR REPLACE 
function numCamasLibres (v_idHospital NUMBER)
return NUMBER
AS
	v_cont NUMBER(38);
BEGIN
       	select sum(numCamas) into v_cont from camasLibres where idHospital = v_idHospital order by idHospital;
	return v_cont;

exception
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Error:' ||SQLCODE||SQLERRM);

end numCamasLibres;




/*******************************************************************************/
/*
Historical procedure. Given an ID (p_dni) shows the pacient history.
*/
CREATE OR REPLACE 
PROCEDURE historialPaciente(p_dni VARCHAR)
AS
	v_idFicha ficha.idFicha%TYPE;
	v_dni paciente.dni%TYPE;
	v_nombre paciente.nombre%TYPE;
	v_sala admision.idSala%TYPE;
	v_aFecha admision.fechaInicio%TYPE;
	v_aFechaFin admision.fechaFin%TYPE;
	v_idMedico ficha.idMedico%TYPE;
	v_nombreMedico sanitario.nombre%TYPE;
	v_enfermedad enfermedad.nombre%TYPE;
	v_comentario resultado.comentario%TYPE;
	v_fechaResultado resultado.fecha%TYPE;
	

	cursor historial is select * from historialPaciente h where h.dni = p_dni order by fechaAdmision;
begin
	open historial
	loop
		fetch historial into v_idFicha, v_dni, v_nombre, v_sala, v_aFechaInicio, v_aFechaFin, v_idMedico, v_nombreMedico, v_enfermedad, v_comentario, v_fechaResultado;
		exit when historial%notfound;
		dbms_output.put_line('idFicha | dni | nombre | idSala | fechaAdmision | idMedico | nombreMedico | enfermedad | comentario | fechaResultado')
		dbms_output.put_line(v_idFicha || v_dni || v_nombre || v_sala || v_aFecha || v_idMedico || v_nombreMedico || v_enfermedad || v_comentario || v_fechaResultado);
	end loop;
	close historial;
end historialPaciente;


/*******************************************************************************/
/*
Procedure which discharge a pacient on the hospital. If it was already discharged, it shows a message.
*/
CREATE OR REPLACE 
PROCEDURE altaPaciente(p_dni VARCHAR)
AS
	v_cont NUMBER(2);
	v_idPaciente paciente.idPaciente%TYPE;
	v_fechaFin admision.fechaFin%TYPE;
	v_dadoAlta NUMBER(1);
 
begin
	select idPaciente into v_idPaciente from paciente where dni = p_dni;
	select count(*) into v_dadoAlta from admision a, paciente p where p.dni = p_dni and a.idPaciente = p.idPaciente and fechaFin is null;

	if (v_dadoAlta>0) then
		update admision set fechaFin = CURRENT_DATE where idPaciente = v_idPaciente;
                commit;
                dbms_output.put_line('Dado de alta');
	end if;

end altaPaciente;


/*******************************************************************************/
/*
Procedure which given the illness id, it returns the name and room in which pacients with that illness are registered. 
*/
CREATE OR REPLACE 
PROCEDURE camasPorEnfermedad(p_idEnfermedad NUMBER)
AS
	v_cont NUMBER(2);
	v_idAdmision admision.idAdmision%TYPE;

	v_numeroSala sala.numeroSala%TYPE;
	v_numCamas sala.numCamas%TYPE;
	v_nombre paciente.nombre%TYPE;

	cursor idAdmision is select idAdmision from ficha f where f.idEnfermedad = p_idEnfermedad;
	cursor datos (p_idAdmision in number) is
       		select s.numeroSala, s.numCamas, p.nombre from paciente p, admision a, sala s 
			where a.idAdmision = p_idAdmision and p.idPaciente = a.idPaciente and a.idSala = s.idSala and a.fechaFin is null;
begin

	open idAdmision;
	loop
		fetch idAdmision into v_idAdmision;
		exit when idAdmision%notfound;

			open datos(v_idAdmision);
			loop
				fetch datos into v_numeroSala, v_numCamas, v_nombre;
				exit when datos%notfound;
				dbms_output.put_line('Nombre paciente:'||v_nombre|| ' Habitacion numero '||v_numeroSala||' con '||v_numCamas||' camas');
			end loop;
			close datos;
	end loop;
	close idAdmision;
end camasPorEnfermedad;


/*******************************************************************************/
/*
Procedure which given the illness id it returns the different treatments and results obtained for that illness. 
*/


CREATE OR REPLACE 
PROCEDURE datosPorEnfermedad(p_idEnfermedad NUMBER)
AS
	v_cont NUMBER(2);
	v_idFicha ficha.idFicha%TYPE;
	v_comentario VARCHAR2(300);
	v_fecha DATE;

	cursor idFicha is select idFicha from ficha f where f.idEnfermedad = p_idEnfermedad;
	cursor resultado (p_idFicha in number) is
       		select comentario, fecha from resultado where idFicha = p_idFicha;
begin

	open idFicha;
	loop
		fetch idFicha into v_idFicha;
		exit when idFicha%notfound;

			open resultado(v_idFicha);
			loop
				fetch resultado into v_comentario, v_fecha;
				exit when resultado%notfound;
				dbms_output.put_line('idEnfermedad:'||p_idEnfermedad||' idFicha:'||v_idFicha||' comentario:'||v_comentario||' fecha:'||v_fecha);
			end loop;
			close resultado;
	end loop;
	close idFicha;
end datosPorEnfermedad;




/*******************************************************************************/
/*
c) It returns the number of times a pacient has been registered in the given hospital. 
*/

CREATE OR REPLACE 
function vecesIngresado (p_idHospital NUMBER, p_idPaciente NUMBER)
return NUMBER
AS
	v_cont NUMBER(38);
BEGIN
       	select count(*) into v_cont from admision, sala where sala.idHospital = p_idHospital and admision.idPaciente = p_idPaciente and sala.idSala = admision.idSala;
	return v_cont;

exception
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Error:' ||SQLCODE||SQLERRM);

end vecesIngresado;
