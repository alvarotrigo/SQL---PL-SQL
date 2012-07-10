

CREATE OR REPLACE TRIGGER tr_existeMedico
BEFORE INSERT OR UPDATE ON FICHA
FOR EACH ROW
DECLARE
	existe NUMBER(1);
	noExisteMedico EXCEPTION;
BEGIN
	select count(*) into existe from sanitario where tipo = 'S' and idPersonal = :new.idMedico;
	if(existe<1) then
		raise noExisteMedico;
	end if;

EXCEPTION 
	when noExisteMedico then
		RAISE_APPLICATION_ERROR(-20001,'El medico asignado a la creacion de la ficha no existe');
END tr_existeMedico;



/*******************************************************************************/
/*
Cada tratamiento de cada admisión se identifica por el nombre de la enfermedad que trata, teniendo en cuenta que el tratamiento es único para cada admisió
*/

CREATE TABLE fichaTmp AS SELECT idAdmision, idEnfermedad FROM ficha;

CREATE OR REPLACE TRIGGER tr_unicaEnfermedad_BF
BEFORE INSERT OR UPDATE ON FICHA
BEGIN
  DELETE FROM fichaTmp;
  INSERT INTO fichaTmp SELECT idAdmision, idEnfermedad FROM ficha;
  DBMS_OUTPUT.PUT_LINE ('Creando tabla temporal');
END tr_unicaEnfermedad_BF;



CREATE OR REPLACE TRIGGER tr_unicaEnfermedad
BEFORE INSERT OR UPDATE ON FICHA
FOR EACH ROW
DECLARE
	v_cont NUMBER(1);
	enfermedadExiste EXCEPTION;
BEGIN
	select count(*) into v_cont from fichaTmp where idAdmision = :new.idAdmision and idEnfermedad = :new.idEnfermedad;
	if(v_cont>0) then
		raise enfermedadExiste;
	end if;
			
EXCEPTION 
	when enfermedadExiste then
		RAISE_APPLICATION_ERROR(-20001,'Ya existe tratamiento para esta enfermedad y esta admision');
END tr_unicaEnfermedad;

/*******************************************************************************/
/*
Result should be linked with an existent record.
*/
CREATE OR REPLACE TRIGGER tr_existeFicha
BEFORE INSERT OR UPDATE ON RESULTADO
FOR EACH ROW
DECLARE
	v_cont NUMBER(1);
	noExisteFicha EXCEPTION;
BEGIN
	select count(*) into v_cont from ficha where idFicha = :new.idFicha;
	if(v_cont<1) then
		raise noExisteFicha;
	end if;			
EXCEPTION 
	when noExisteFicha then
		RAISE_APPLICATION_ERROR(-20001,'No existe la ficha a la que esta asignado el resultado.');
END tr_existeFicha;


/*******************************************************************************/
/*
The result for a same record should be unique for a same date.
*/
CREATE TABLE resultadoTmp AS SELECT idResultado, idFicha, fecha FROM resultado;

CREATE OR REPLACE TRIGGER tr_unicaFechaResultado_BF
BEFORE INSERT OR UPDATE ON RESULTADO
BEGIN
  DELETE FROM resultadoTmp;
  INSERT INTO resultadoTmp SELECT idResultado, idFicha, fecha FROM resultado;
  DBMS_OUTPUT.PUT_LINE ('Creando tabla temporal');
END tr_unicaFechaResultado_BF;



CREATE OR REPLACE TRIGGER tr_unicaFechaResultado
BEFORE INSERT OR UPDATE ON RESULTADO
FOR EACH ROW
DECLARE
	v_cont NUMBER(1);
	fechaNoUnica EXCEPTION;
BEGIN
	select count(*) into v_cont from resultadoTmp where idFicha = :new.idFicha and  fecha = :new.fecha;
	if(v_cont>0) then
		raise fechaNoUnica;
	end if;
			
EXCEPTION 
	when fechaNoUnica then
		RAISE_APPLICATION_ERROR(-20001,'Ya existe un resultado para esta misma fecha en esta ficha');
END tr_unicaFechaResultado;

/*******************************************************************************/
/*
Employees can work only at one hospital.
*/
CREATE TABLE adminTmp AS SELECT dni FROM administracion;

CREATE OR REPLACE TRIGGER tr_unHospital_BF
BEFORE INSERT OR UPDATE ON ADMINISTRACION
BEGIN
  DELETE FROM adminTmp;
  INSERT INTO adminTmp SELECT dni FROM administracion;
  DBMS_OUTPUT.PUT_LINE ('Creando tabla temporal');
END tr_unHospital_BF;


CREATE OR REPLACE TRIGGER tr_unHospital
BEFORE INSERT OR UPDATE ON ADMINISTRACION
FOR EACH ROW
DECLARE
	v_cont NUMBER(4);
	error EXCEPTION;
BEGIN
	select count(*) into v_cont from adminTmp where dni = :new.dni;
	if(v_cont>0) then
		raise error;
	end if;			
EXCEPTION 
	when error then
		RAISE_APPLICATION_ERROR(-20001,'La persona de administracion trabaja ya para un hospital.');
END tr_unHospital;



/*******************************************************************************/
/*
Administrators can ask for own affairs days, max of 5 per year. 
*/
CREATE TABLE diasPropiosTmp AS SELECT idDiasPropios, idAdministracion FROM diasPropios;

CREATE OR REPLACE TRIGGER tr_maxAsuntosPropios_BF
BEFORE INSERT OR UPDATE ON DIASPROPIOS
BEGIN
  DELETE FROM diasPropiosTmp;
  INSERT INTO diasPropiosTmp SELECT idDiasPropiosm, idAdministracion FROM diasPropios;
  DBMS_OUTPUT.PUT_LINE ('Creando tabla temporal');
END tr_maxAsuntosPropios_BF;


CREATE OR REPLACE TRIGGER tr_maxAsuntosPropios
BEFORE INSERT OR UPDATE ON DIASPROPIOS
FOR EACH ROW
DECLARE
	v_cont NUMBER(10);
	error EXCEPTION;
BEGIN
	select count(*) into v_cont from diasPropiosTmp where idAdministracion = :new.idAdministracion;
	if(v_cont>5) then
		raise error;
	end if;			
EXCEPTION 
	when error then
		RAISE_APPLICATION_ERROR(-20001,'La persona de administracion ya solicitó los 5 dias permitidos para asuntos propios.');
END tr_maxAsuntosPropios;


/*******************************************************************************/
/*
Doctors and ats can not have 2 guards of 24 hours in the same day.
*/

CREATE TABLE guardiaTmp AS SELECT idSanitario, idGuardia FROM sanitarioguardia;

CREATE OR REPLACE TRIGGER tr_unaGuardia_BF
BEFORE INSERT OR UPDATE ON sanitarioguardia
BEGIN
  DELETE FROM guardiaTmp;
  INSERT INTO guardiaTmp SELECT idSanitario, idGuardia FROM sanitarioguardia;
  DBMS_OUTPUT.PUT_LINE ('Creando tabla temporal');
END tr_unaGuardia_BF;


CREATE OR REPLACE TRIGGER tr_unaGuardia
BEFORE INSERT OR UPDATE ON SANITARIOGUARDIA
FOR EACH ROW
DECLARE
	v_cont NUMBER(10);
	error EXCEPTION;
BEGIN
	select count(*) into v_cont from guardiaTmp where idSanitario = :new.idSanitario and idGuardia = :new.idGuardia;
	if(v_cont>0) then
		raise error;
	end if;			
EXCEPTION 
	when error then
		RAISE_APPLICATION_ERROR(-20001,'Ya existe una guardia asignada para esa persona en esa fecha');
END tr_unaGuardia;




/*******************************************************************************/
/*
Initial date have to be less or equal than the end date for an admission. 
*/

CREATE OR REPLACE TRIGGER tr_fechaInifechaFin
BEFORE INSERT OR UPDATE ON ADMISION
FOR EACH ROW
DECLARE
	v_fechaInicio NUMBER(10);
	error EXCEPTION;
BEGIN
	if(:new.fechaFin<:new.fechaInicio) then
		raise error;
	end if;
		
EXCEPTION 
	when error then
		RAISE_APPLICATION_ERROR(-20001,'La fecha fin no puede ser menor que la fecha de alta');
END tr_fechaInifechaFin;




/*******************************************************************************/
/*
Creating an updated view.
*/

create trigger updateHistorialPaciente
    instead of update on historialPaciente
    for each row
declare
    NuevoCliente integer;
begin
	update paciente set dni = :new.dni, nombre = :new.nombre;
	update admision set Sala = :new.Sala, fechaAdmision = :new.fechaAdmision, fechaAlta = :new.fechaAlta;
	update ficha set idFicha = :new.idFicha, idMedico = :new.idMedico;
	update resultado set comentario = :new.comentario, fechaResultado = :new.fechaResultado;
	update sanitario set MedicoNombre = :new.MedicoNombre;
	update enfermedad set Enfermedad = :new.Enfermedad;
	

end;

