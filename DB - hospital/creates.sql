DROP TABLE SALA CASCADE CONSTRAINT;
DROP TABLE ADMISION CASCADE CONSTRAINT;
DROP TABLE PACIENTE CASCADE CONSTRAINT;
DROP TABLE HOSPITAL CASCADE CONSTRAINT;
DROP TABLE FICHA CASCADE CONSTRAINT;
DROP TABLE ENFERMEDAD CASCADE CONSTRAINT;
DROP TABLE RESULTADO CASCADE CONSTRAINT;
DROP TABLE ADMINISTRACION CASCADE CONSTRAINT;
DROP TABLE SANITARIO CASCADE CONSTRAINT;
DROP TABLE DIASPROPIOS CASCADE CONSTRAINT;
DROP TABLE GUARDIA CASCADE CONSTRAINT;
DROP TABLE SANITARIOGUARDIA CASCADE CONSTRAINT;
DROP TABLE ESPECIALIDAD CASCADE CONSTRAINT;
DROP TABLE ADMINDIASPROPIOS CASCADE CONSTRAINT;


CREATE TABLE SALA(
	idSala		NUMBER(6)	NOT NULL CONSTRAINT PK_SALA PRIMARY KEY,
	numeroSala	NUMBER(6)	NOT NULL,
	idHospital	NUMBER(6)	NOT NULL,
	numCamas	NUMBER(3)
);



CREATE TABLE PACIENTE(
	idPaciente	NUMBER(6)	NOT NULL CONSTRAINT PK_PACIENTE PRIMARY KEY,
	dni		VARCHAR2(10)	NOT NULL UNIQUE,
	nombre		VARCHAR2(30)	NOT NULL,
	telefono	NUMBER(12)	NOT NULL,
	direccion	VARCHAR2(40)	NOT NULL,
	nss		VARCHAR2(15)	UNIQUE,
	aseguradora	VARCHAR2(40)
);


CREATE TABLE HOSPITAL(
	idHospital	NUMBER(6)	NOT NULL CONSTRAINT PK_HOSPITAL PRIMARY KEY,
	nombre		VARCHAR2(30)	NOT NULL,
	direccion	VARCHAR2(40)	NOT NULL,
	codigoPostal	NUMBER(5)	NOT NULL,
	telefono	VARCHAR2(12)	NOT NULL
);

CREATE TABLE ENFERMEDAD(
	idEnfermedad	NUMBER(6)	NOT NULL CONSTRAINT PK_ENFERMEDAD PRIMARY KEY,
	nombre		VARCHAR2(30)	NOT NULL
);

CREATE TABLE DIASPROPIOS(
	idDiasPropios		NUMBER(6)	NOT NULL CONSTRAINT PK_DIASPROPIOS PRIMARY KEY,
	fecha			DATE		NOT NULL
);


CREATE TABLE GUARDIA(
	idGuardia		NUMBER(6)	NOT NULL CONSTRAINT PK_GUARDIA PRIMARY KEY,
	fecha			DATE		NOT NULL
);


CREATE TABLE ESPECIALIDAD(
	idSanitario	NUMBER(6)	NOT NULL CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY,
	especialidad	VARCHAR2(25)	NOT NULL
);

CREATE TABLE ADMISION(
	idAdmision	NUMBER(6)	NOT NULL CONSTRAINT PK_ADMISION PRIMARY KEY,
	idPaciente	NUMBER(6)	NOT NULL,
	idSala		NUMBER(6)	NOT NULL,
	fechaInicio	DATE		NOT NULL, 
	fechaFin	DATE,
	CONSTRAINT	CK_ADMISION_FECHAS	CHECK (fechaInicio<=fechaFin),
	constraint 	FK_ADMISION_PACIENTE	FOREIGN KEY (idPaciente) REFERENCES paciente,
	constraint 	FK_ADMISION_SALA	FOREIGN KEY (idSala) REFERENCES sala
);

CREATE TABLE SANITARIO(
	idPersonal		NUMBER(6)	NOT NULL CONSTRAINT PK_SANITARIO PRIMARY KEY,
	idHospital		NUMBER(6)	NOT NULL,
	idGuardia		NUMBER(6)	NOT NULL,
	dni			VARCHAR2(10)	NOT NULL UNIQUE,
	nombre			VARCHAR2(30)	NOT NULL,
	calle			VARCHAR2(40)	NOT NULL,
	telefono		NUMBER(12)	NOT NULL, 
	tipo			CHAR(1)		NOT NULL CHECK ( tipo IN ('M', 'A')),
	constraint 	FK_ADMINISTRACION_HOSPITAL	FOREIGN KEY (idHospital) REFERENCES hospital,
	constraint 	FK_ADMINISTRACION_GUARDIA	FOREIGN KEY (idGuardia) REFERENCES guardia
);


CREATE TABLE FICHA(
	idFicha 	NUMBER(6)	NOT NULL CONSTRAINT PK_FICHA PRIMARY KEY,
	idAdmision	NUMBER(6)	NOT NULL,
	idMedico	NUMBER(6)	NOT NULL,
	idEnfermedad	NUMBER(6)	NOT NULL,
	constraint 	FK_FICHA_ADMISION	FOREIGN KEY (idAdmision) REFERENCES admision,
	constraint 	FK_FICHA_MEDICO		FOREIGN KEY (idMedico) REFERENCES sanitario,
	constraint 	FK_FICHA_ENFERMEDAD	FOREIGN KEY (idEnfermedad) REFERENCES enfermedad
);


CREATE TABLE RESULTADO(
	idResultado	NUMBER(6)	NOT NULL CONSTRAINT PK_RESULTADO PRIMARY KEY,
	idFicha		NUMBER(6)	NOT NULL,
	comentario	VARCHAR2(300)	NOT NULL,
	fecha		DATE		NOT NULL,
	constraint 	FK_RESULTADO_FICHA	FOREIGN KEY (idFicha) REFERENCES ficha
);


CREATE TABLE ADMINISTRACION(
	idPersonal		NUMBER(6)	NOT NULL CONSTRAINT PK_ADMINISTRACION PRIMARY KEY,
	idHospital		NUMBER(6)	NOT NULL,
	idAsuntosPropios	NUMBER(6)	NOT NULL,
	dni			VARCHAR2(10)	NOT NULL UNIQUE,
	nombre			VARCHAR2(30)	NOT NULL,
	calle			VARCHAR2(40)	NOT NULL,
	telefono		NUMBER(12)	NOT NULL,
	constraint 	FK_ADMIN_HOS	FOREIGN KEY (idHospital) REFERENCES hospital,
	constraint 	FK_ADMIN_AS	FOREIGN KEY (idAsuntosPropios) REFERENCES diasPropios
);



CREATE TABLE ADMINDIASPROPIOS(
	idAdministracion	NUMBER(6)	NOT NULL,
	idDiasPropios		NUMBER(6)	NOT NULL,
	constraint 	FK_ADMIND_ADMIN	FOREIGN KEY (idAdministracion) REFERENCES administracion,
	constraint 	FK_ADMIND_DIAS 	FOREIGN KEY (idDiasPropios) REFERENCES diasPropios
);


CREATE TABLE SANITARIOGUARDIA(
	idSanitario	NUMBER(6)	NOT NULL,
	idGuardia	NUMBER(6)	NOT NULL,
	constraint 	FK_SANITARIOGUARDIA_SANITARIO	FOREIGN KEY (idSanitario) REFERENCES sanitario,
	constraint 	FK_SANITARIOGUARDIA_GUARDIA	FOREIGN KEY (idGuardia) REFERENCES guardia
);


INSERT INTO SALA(idSala, numeroSala, idHospital, numCamas) VALUES(1, 25, 1, 4);
INSERT INTO SALA(idSala, numeroSala, idHospital, numCamas) VALUES(2, 26, 1, 2);
INSERT INTO SALA(idSala, numeroSala, idHospital, numCamas) VALUES(3, 27, 1, 3);
INSERT INTO SALA(idSala, numeroSala, idHospital, numCamas) VALUES(4, 28, 1, 2);
INSERT INTO SALA(idSala, numeroSala, idHospital, numCamas) VALUES(5, 29, 1, 5);
INSERT INTO SALA(idSala, numeroSala, idHospital, numCamas) VALUES(6, 25, 2, 1);
INSERT INTO SALA(idSala, numeroSala, idHospital, numCamas) VALUES(7, 26, 2, 2);
INSERT INTO SALA(idSala, numeroSala, idHospital, numCamas) VALUES(8, 24, 3, 3);



INSERT INTO PACIENTE(idPaciente, dni, nombre, telefono, direccion, nss, aseguradora) VALUES(1, '71295830A', 'Alvaro Trigo Lopez', 947883322, 'C/Vitoria 34 esc2 2ºC', 98873435, 'Don mendo aseguradora');
INSERT INTO PACIENTE(idPaciente, dni, nombre, telefono, direccion, nss) VALUES(2, '71295832A', 'Alvaro Lopez Lopez', 111883322, 'C/Notengo 34 esc2 2ºC', 22273435);
INSERT INTO PACIENTE(idPaciente, dni, nombre, telefono, direccion) VALUES(3, '71295833A', 'Alvaro Perez Lopez', 222883322, 'C/Avenida 34 esc2 2ºC');
INSERT INTO PACIENTE(idPaciente, dni, nombre, telefono, direccion, nss) VALUES(4, '71295834A', 'Alvaro Juan Lopez', 333883322, 'C/Saiz del pepe 34 esc2 2ºC', 44473435);
INSERT INTO PACIENTE(idPaciente, dni, nombre, telefono, direccion, nss, aseguradora) VALUES(5, '71295835A', 'Alvaro Diez Lopez', 444883322, 'C/Camarero 34 esc2 2ºC', 55573435,'Alonso aseguradoras');
INSERT INTO PACIENTE(idPaciente, dni, nombre, telefono, direccion, nss) VALUES(6, '71295836A', 'Alvaro Saez Lopez', 555883322, 'C/Ordenador 34 esc2 2ºC', 66673435);
INSERT INTO PACIENTE(idPaciente, dni, nombre, telefono, direccion) VALUES(7, '71295837A', 'Alvaro Orozco Lopez', 666883322, 'C/Raton 34 esc2 2ºC');
INSERT INTO PACIENTE(idPaciente, dni, nombre, telefono, direccion, nss, aseguradora) VALUES(8, '71295838A', 'Alvaro Camara Lopez', 777883322, 'C/Alfombrilla 34 esc2 2ºC', 77773435,'Aseguradora PLO');
INSERT INTO PACIENTE(idPaciente, dni, nombre, telefono, direccion, nss) VALUES(9, '71295839A', 'Alvaro Sobrino Lopez', 888883322, 'C/Apple 34 esc2 2ºC', 99973435);



INSERT INTO HOSPITAL(idHospital, nombre, direccion, codigoPostal, telefono) VALUES(1, 'Hospital del buen conejo', 'C/Vitoria 50', 09007, 947886322);
INSERT INTO HOSPITAL(idHospital, nombre, direccion, codigoPostal, telefono) VALUES(2, 'Hospital del buen hermano', 'C/Santander 10', 09006, 111886322);
INSERT INTO HOSPITAL(idHospital, nombre, direccion, codigoPostal, telefono) VALUES(3, 'Hospital del buen apple', 'C/Madrir 200', 09043, 555883622);
INSERT INTO HOSPITAL(idHospital, nombre, direccion, codigoPostal, telefono) VALUES(4, 'Hospital del buen steve', 'C/Alcalá 45', 09021, 777866322);



INSERT INTO ENFERMEDAD(idEnfermedad, nombre) VALUES(1,'Gastronteritis');
INSERT INTO ENFERMEDAD(idEnfermedad, nombre) VALUES(2,'Epatitis');
INSERT INTO ENFERMEDAD(idEnfermedad, nombre) VALUES(3,'Diarrea');
INSERT INTO ENFERMEDAD(idEnfermedad, nombre) VALUES(4,'Dolor de tripa');
INSERT INTO ENFERMEDAD(idEnfermedad, nombre) VALUES(5,'Gripe A');
INSERT INTO ENFERMEDAD(idEnfermedad, nombre) VALUES(6,'Escoliosis');
INSERT INTO ENFERMEDAD(idEnfermedad, nombre) VALUES(7,'Tos aguda');



INSERT INTO DIASPROPIOS(idDiasPropios, fecha) VALUES(1, '15/Dic/2009');
INSERT INTO DIASPROPIOS(idDiasPropios, fecha) VALUES(2, '16/Dic/2009');
INSERT INTO DIASPROPIOS(idDiasPropios, fecha) VALUES(3, '17/Dic/2009');
INSERT INTO DIASPROPIOS(idDiasPropios, fecha) VALUES(4, '18/Dic/2009');
INSERT INTO DIASPROPIOS(idDiasPropios, fecha) VALUES(5, '19/Dic/2009');
INSERT INTO DIASPROPIOS(idDiasPropios, fecha) VALUES(6, '20/Dic/2009');
INSERT INTO DIASPROPIOS(idDiasPropios, fecha) VALUES(7, '21/Dic/2009');
INSERT INTO DIASPROPIOS(idDiasPropios, fecha) VALUES(8, '22/Dic/2009');



INSERT INTO GUARDIA(idGuardia, fecha) VALUES(1, '15/Dic/2009');
INSERT INTO GUARDIA(idGuardia, fecha) VALUES(2, '16/Dic/2009');
INSERT INTO GUARDIA(idGuardia, fecha) VALUES(3, '17/Dic/2009');
INSERT INTO GUARDIA(idGuardia, fecha) VALUES(4, '18/Dic/2009');
INSERT INTO GUARDIA(idGuardia, fecha) VALUES(5, '19/Dic/2009');
INSERT INTO GUARDIA(idGuardia, fecha) VALUES(6, '20/Dic/2009');
INSERT INTO GUARDIA(idGuardia, fecha) VALUES(7, '15/Dic/2009');
INSERT INTO GUARDIA(idGuardia, fecha) VALUES(8, '16/Dic/2009');
INSERT INTO GUARDIA(idGuardia, fecha) VALUES(9, '17/Dic/2009');
INSERT INTO GUARDIA(idGuardia, fecha) VALUES(11, '19/Dic/2009');



INSERT INTO ESPECIALIDAD(idSanitario, especialidad) VALUES(1, 'gripes a');
INSERT INTO ESPECIALIDAD(idSanitario, especialidad) VALUES(2, 'gripes b');
INSERT INTO ESPECIALIDAD(idSanitario, especialidad) VALUES(3, 'gripes c');
INSERT INTO ESPECIALIDAD(idSanitario, especialidad) VALUES(4, 'gripes d');




INSERT INTO ADMISION(idAdmision, idPaciente, idSala, fechaInicio, fechaFin) VALUES(1, 1, 1, '15/feb/2009', '26/feb/2010');
INSERT INTO ADMISION(idAdmision, idPaciente, idSala, fechaInicio, fechaFin) VALUES(2, 2, 2, '20/feb/2009','26/feb/2010');
INSERT INTO ADMISION(idAdmision, idPaciente, idSala, fechaInicio) VALUES(3, 3, 4, '25/feb/2009');
INSERT INTO ADMISION(idAdmision, idPaciente, idSala, fechaInicio) VALUES(4, 2, 6, '26/feb/2009');
INSERT INTO ADMISION(idAdmision, idPaciente, idSala, fechaInicio) VALUES(5, 1, 1, '28/feb/2009');
INSERT INTO ADMISION(idAdmision, idPaciente, idSala, fechaInicio, fechaFin) VALUES(6, 4, 7, '1/feb/2009', '26/feb/2010');
INSERT INTO ADMISION(idAdmision, idPaciente, idSala, fechaInicio, fechaFin) VALUES(7, 5, 8, '4/feb/2009', '26/feb/2010');
INSERT INTO ADMISION(idAdmision, idPaciente, idSala, fechaInicio) VALUES(8, 4, 7, '9/feb/2009');



INSERT INTO SANITARIO(idPersonal, idHospital, idGuardia, dni, nombre, calle, telefono, tipo) VALUES(1,1,1,'71295566Z', 'Estevan Blanco', 'C/bbbbajo el puente', 777888333, 'M');
INSERT INTO SANITARIO(idPersonal, idHospital, idGuardia, dni, nombre, calle, telefono, tipo) VALUES(2,1,1,'72295566Z', 'Miguel Lopez', 'C/ccccantabia nº2', 666888444, 'M');
INSERT INTO SANITARIO(idPersonal, idHospital, idGuardia, dni, nombre, calle, telefono, tipo) VALUES(3,2,1,'73295566Z', 'Elena Maria', 'C/aaaDel cid 25 nº1', 555888666, 'M');
INSERT INTO SANITARIO(idPersonal, idHospital, idGuardia, dni, nombre, calle, telefono, tipo) VALUES(4,2,1,'74295566Z', 'Maria del Pilar', 'C/sdddantander 201 4ºb', 888888555, 'M');
INSERT INTO SANITARIO(idPersonal, idHospital, idGuardia, dni, nombre, calle, telefono, tipo) VALUES(5,2,1,'75295566Z', 'Miryam Lopez ', 'C/eeemadrid 7 ', 000888777, 'A');
INSERT INTO SANITARIO(idPersonal, idHospital, idGuardia, dni, nombre, calle, telefono, tipo) VALUES(6,3,1,'76295566Z', 'Pablo Loco', 'C/fffburgos 12', 111888888, 'A');
INSERT INTO SANITARIO(idPersonal, idHospital, idGuardia, dni, nombre, calle, telefono, tipo) VALUES(7,4,1,'77295566Z', 'Javier Villaldaba', 'C/hhhasturias 2', 333888999, 'A');




INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(1,1,1,1);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(2,1,3,3);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(3,1,2,5);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(4,2,1,2);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(5,2,2,4);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(6,3,1,7);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(7,3,3,5);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(8,5,2,6);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(9,4,2,2);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(10,7,1,1);
INSERT INTO FICHA(idFicha, idAdmision, idMedico, idEnfermedad) VALUES(11,8,3,6);





INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(1,1,'1-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(2,1,'2-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(3,2,'3-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(4,2,'4-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(5,3,'5-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(6,4,'6-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(7,5,'7-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(8,6,'8-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(9,7,'9-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(10,8,'10-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(11,9,'11-Que cosa tan rara', '15/feb/2009');
INSERT INTO RESULTADO(idResultado, idFicha, comentario, fecha) VALUES(12,10,'12-Que cosa tan rara', '15/feb/2009');


INSERT INTO ADMINISTRACION(idPersonal, idHospital, idAsuntosPropios, dni, nombre, calle, telefono) VALUES(1,1,1,'71295566Z', 'Pepe calvo', 'C/bajo el puente', 777888999);
INSERT INTO ADMINISTRACION(idPersonal, idHospital, idAsuntosPropios, dni, nombre, calle, telefono) VALUES(2,1,1,'72295566Z', 'Steve Jobs', 'C/cantabia nº2', 666888999);
INSERT INTO ADMINISTRACION(idPersonal, idHospital, idAsuntosPropios, dni, nombre, calle, telefono) VALUES(3,2,1,'73295566Z', 'Bill Gates', 'C/Del cid 25 nº1', 555888999);
INSERT INTO ADMINISTRACION(idPersonal, idHospital, idAsuntosPropios, dni, nombre, calle, telefono) VALUES(4,2,1,'74295566Z', 'Wozniak Jobs', 'C/santander 201 4ºb', 888888999);
INSERT INTO ADMINISTRACION(idPersonal, idHospital, idAsuntosPropios, dni, nombre, calle, telefono) VALUES(5,2,1,'75295566Z', 'Lorenzo Lopez ', 'C/madrid 7 ', 000888999);
INSERT INTO ADMINISTRACION(idPersonal, idHospital, idAsuntosPropios, dni, nombre, calle, telefono) VALUES(6,3,1,'76295566Z', 'Juan ramon gimenez', 'C/burgos 12', 111888999);
INSERT INTO ADMINISTRACION(idPersonal, idHospital, idAsuntosPropios, dni, nombre, calle, telefono) VALUES(7,4,1,'77295566Z', 'Pedro del alba', 'C/asturias 2', 333888999);




INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(1, 1);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(1, 2);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(1, 3);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(1, 4);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(2, 5);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(2, 6);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(3, 2);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(4, 8);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(5, 7);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(6, 7);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(6, 6);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(6, 5);
INSERT INTO ADMINDIASPROPIOS(idAdministracion, idDiasPropios) VALUES(7, 6);



INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(1, 1);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(1, 2);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(1, 3);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(1, 4);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(2, 5);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(2, 6);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(2, 7);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(2, 8);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(3, 9);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(3, 9);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(3, 11);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(3, 1);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(4, 3);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(4, 5);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(4, 5);
INSERT INTO SANITARIOGUARDIA(idSanitario, idGuardia) VALUES(4, 8);

