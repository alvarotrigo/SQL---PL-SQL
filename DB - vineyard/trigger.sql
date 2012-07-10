/*5. Hacer la implementación de las tablas y de las restricciones en SQL de Oracle, introduciendo
datos en las tablas para poder trabajar con ellas.*/

DROP TABLE HUMEDAD CASCADE CONSTRAINT;
DROP TABLE SOL CASCADE CONSTRAINT;
DROP TABLE TIPO_TERRENO CASCADE CONSTRAINT;
DROP TABLE TIPO_UVA CASCADE CONSTRAINT;
DROP TABLE TIPO_ABONO CASCADE CONSTRAINT;
DROP TABLE QUIMICO CASCADE CONSTRAINT;
DROP TABLE TERRENO CASCADE CONSTRAINT;
DROP TABLE vinnedo CASCADE CONSTRAINT;
DROP TABLE SOL_TERRENO CASCADE CONSTRAINT;
DROP TABLE HUMEDAD_TERRENO CASCADE CONSTRAINT;
DROP TABLE ABONO_HUMEDAD CASCADE CONSTRAINT;
DROP TABLE ABONO_TIPO_TERRENO CASCADE CONSTRAINT;
DROP TABLE ABONO_TERRENO CASCADE CONSTRAINT;
DROP TABLE PLAGA CASCADE CONSTRAINT;
DROP TABLE HISTORICO_PLAGA CASCADE CONSTRAINT;
DROP TABLE TRATAMIENTO CASCADE CONSTRAINT;
DROP TABLE QUIMICO_TRATAMIENTO CASCADE CONSTRAINT;
DROP TABLE RESULTADO CASCADE CONSTRAINT;
DROP TABLE ESTADO CASCADE CONSTRAINT;
DROP TABLE VENDIMIA CASCADE CONSTRAINT;
DROP TABLE VENDIMIA_PROPIA CASCADE CONSTRAINT;
DROP TABLE VENDIMIA_PRIVADA CASCADE CONSTRAINT;
DROP TABLE TIPO_VINO CASCADE CONSTRAINT;
DROP TABLE UVA_VINO CASCADE CONSTRAINT;
DROP TABLE PLANTILLA CASCADE CONSTRAINT;
DROP TABLE PRODUCCION CASCADE CONSTRAINT;
DROP TABLE PRODUCCION_VENDIMIA CASCADE CONSTRAINT;
DROP TABLE FASE_CUBA_ACERO CASCADE CONSTRAINT;
DROP TABLE FASE_CA_CA;
DROP TABLE CUBA_ACERO CASCADE CONSTRAINT;
DROP TABLE FASE_BARRICA CASCADE CONSTRAINT;
DROP TABLE ANTIGUEDAD CASCADE CONSTRAINT;
DROP TABLE BARRICA CASCADE CONSTRAINT;
DROP TABLE CAJA CASCADE CONSTRAINT;

DROP SEQUENCE TIPOS_TERRENOS;
DROP SEQUENCE TIPOS_UVAS	;
DROP SEQUENCE TIPOS_ABONOS	;
DROP SEQUENCE QUIMICOS	;
DROP SEQUENCE TERRENOS	;
DROP SEQUENCE VINNEDOS	;
DROP SEQUENCE PLAGAS	;
DROP SEQUENCE HISTORICOS	;
DROP SEQUENCE TRATAMIENTOS	 ;
DROP SEQUENCE RESULTADOS	 ;
DROP SEQUENCE VENDIMIAS	;
DROP SEQUENCE VINOS	 ;
DROP SEQUENCE PLANTILLAS	;
DROP SEQUENCE PRODUCCIONES	;
DROP SEQUENCE FASES_CUBAS	;
DROP SEQUENCE FASES_BARRICAS	 ;
DROP SEQUENCE CAJAS	;


CREATE TABLE HUMEDAD (
	humedad	NUMBER(6)	NOT NULL CONSTRAINT PK_HUMEDAD PRIMARY KEY,
	CONSTRAINT CK_Humedad CHECK (humedad>=0 AND humedad<=100)
);

CREATE TABLE SOL (
	horas	NUMBER(6)NOT NULL CONSTRAINT PK_HORAS PRIMARY KEY,
	CONSTRAINT CK_Sol CHECK (horas>=0 AND horas<=24)
);

CREATE TABLE TIPO_TERRENO (
	Id_tipo_terreno	NUMBER(6)	NOT NULL CONSTRAINT PK_TIPO_TERRENO PRIMARY KEY,
	Tipo	VARCHAR2(20)	NOT NULL,
	CONSTRAINT U_Tipo_terreno UNIQUE (Tipo)
);

CREATE TABLE TIPO_UVA (
	Id_uva	NUMBER(6)	NOT NULL CONSTRAINT PK_Tipo_Uva PRIMARY KEY,
	Tipo_uva	VARCHAR2(20)	NOT NULL,
	Frec_abonado	NUMBER(6)	NOT NULL,
	CONSTRAINT U_Tipo_uva UNIQUE (Tipo_uva)
);

CREATE TABLE TIPO_ABONO(
	Id_abono	NUMBER(6)	NOT NULL CONSTRAINT PK_Tipo_Abono PRIMARY KEY,
	Nombre	VARCHAR2(20)	NOT NULL,
	CONSTRAINT U_Tipo_abono UNIQUE (Nombre)
);


CREATE TABLE QUIMICO (
	Id_quimico	NUMBER(6)	NOT NULL CONSTRAINT PK_Quimico PRIMARY KEY,
	Nombre	VARCHAR2(20)	NOT NULL,
	CONSTRAINT U_Quimico UNIQUE (Nombre)
);

CREATE TABLE TERRENO (
    Id_terreno NUMBER(6) NOT NULL CONSTRAINT PK_ID_TERRENO PRIMARY KEY,
	Tamano	NUMBER(6) NOT NULL,
	Direccion	VARCHAR2(50),
	Id_tipo_terreno	NUMBER(6)	 NOT NULL,
	CONSTRAINT FK_Terreno_Tipo FOREIGN KEY (Id_tipo_terreno) REFERENCES TIPO_TERRENO ON DELETE SET NULL DEFERRABLE
);

CREATE TABLE vinnedo (
	Id_vinnedo NUMBER(6) NOT NULL CONSTRAINT PK_vinnedo PRIMARY KEY,
	Porcentaje_agua	NUMBER(6) NOT NULL,
	Nombre	VARCHAR2(50),
	Id_uva	NUMBER(6)	 NOT NULL,
	Id_terreno	NUMBER(6)	 NOT NULL,
	CONSTRAINT FK_Vinnedo_uva FOREIGN KEY (Id_uva) REFERENCES TIPO_UVA ON DELETE SET NULL DEFERRABLE,
	CONSTRAINT FK_Terreno FOREIGN KEY (Id_terreno) REFERENCES TERRENO ON DELETE SET NULL DEFERRABLE
);

CREATE TABLE SOL_TERRENO (
	Horas_sol	NUMBER(6)	 NOT NULL,
	Id_terreno	NUMBER(6)	 NOT NULL,
	Fecha DATE DEFAULT SYSDATE NOT NULL,
	CONSTRAINT PK_DIAS_AP PRIMARY KEY (Horas_sol, Id_terreno, fecha),
	CONSTRAINT FK_ST_SOL FOREIGN KEY (Horas_sol) REFERENCES SOL DEFERRABLE,
	CONSTRAINT FK_ST_TERRENO FOREIGN KEY (Id_terreno) REFERENCES TERRENO DEFERRABLE
);

CREATE TABLE HUMEDAD_TERRENO(
	Humedad	NUMBER(6)	 NOT NULL,
	Id_terreno	NUMBER(6)	 NOT NULL,
	Fecha DATE DEFAULT SYSDATE NOT NULL,
	CONSTRAINT PK_HUMEDAD_TERRENO PRIMARY KEY (Humedad, Id_terreno, Fecha),
	CONSTRAINT FK_HT_HUMEDAD FOREIGN KEY (Humedad) REFERENCES HUMEDAD DEFERRABLE,
	CONSTRAINT FK_HT_TERRENO FOREIGN KEY (Id_terreno) REFERENCES TERRENO DEFERRABLE
);

CREATE TABLE ABONO_HUMEDAD (
	Humedad	NUMBER(6)	 NOT NULL,
	Id_abono	NUMBER(6)	 NOT NULL,
	CONSTRAINT PK_ABONO_HUMEDAD PRIMARY KEY (Humedad, Id_abono),
	CONSTRAINT FK_AH_HUMEDAD FOREIGN KEY (Humedad) REFERENCES HUMEDAD DEFERRABLE,
	CONSTRAINT FK_AH_ABONO FOREIGN KEY (Id_abono) REFERENCES TIPO_ABONO DEFERRABLE
);

CREATE TABLE ABONO_TIPO_TERRENO (
	Id_tipo_terreno	NUMBER(6)	NOT NULL,
	Id_abono NUMBER(6) NOT NULL,
	CONSTRAINT PK_ABONO_TT PRIMARY KEY (Id_tipo_terreno, Id_abono),
	CONSTRAINT FK_ATT_TT FOREIGN KEY (Id_tipo_terreno) REFERENCES TIPO_TERRENO DEFERRABLE,
	CONSTRAINT FK_ATT_ABONO FOREIGN KEY (Id_abono) REFERENCES TIPO_ABONO ON DELETE SET NULL DEFERRABLE
);

CREATE TABLE ABONO_TERRENO (
	Id_terreno	NUMBER(6)	NOT NULL,
	Id_abono NUMBER(6) NOT NULL,
	Fecha TIMESTAMP DEFAULT SYSDATE,
	Cantidad NUMBER(6) NOT NULL,
	CONSTRAINT PK_ABONO_TERRENO PRIMARY KEY (Id_terreno, Id_abono, Fecha),
	CONSTRAINT FK_AT_TERRENO FOREIGN KEY (Id_terreno) REFERENCES TERRENO DEFERRABLE,
	CONSTRAINT FK_AT_ABONO FOREIGN KEY (Id_abono) REFERENCES TIPO_ABONO ON DELETE SET NULL DEFERRABLE
);

CREATE TABLE PLAGA (
	Id_plaga	NUMBER(6)	NOT NULL CONSTRAINT PK_PLAGA PRIMARY KEY,
	Nombre	VARCHAR2(20)	NOT NULL,
	CONSTRAINT U_Plaga UNIQUE (Nombre)
);

CREATE TABLE HISTORICO_PLAGA (
	Id_historico	NUMBER(6)	NOT NULL CONSTRAINT PK_HISTORICO_PLAGA PRIMARY KEY,
	Fecha_inicio TIMESTAMP DEFAULT SYSDATE NOT NULL,
	Fecha_fin TIMESTAMP DEFAULT SYSDATE NOT NULL,
	Id_terreno	NUMBER(6)	NOT NULL,
	Id_plaga	NUMBER(6)	NOT NULL,
	CONSTRAINT CK_HP_fecha CHECK(Fecha_fin IS NULL OR Fecha_fin>Fecha_inicio) DEFERRABLE,
	CONSTRAINT FK_HP_TERRENO FOREIGN KEY (Id_terreno) REFERENCES TERRENO DEFERRABLE,
	CONSTRAINT FK_HP_PLAGA FOREIGN KEY (Id_plaga) REFERENCES PLAGA DEFERRABLE
);

CREATE TABLE TRATAMIENTO (
	Id_tratamiento	NUMBER(6)	NOT NULL CONSTRAINT PK_ID_TRATAMIENTO PRIMARY KEY,
	Fecha_inicio TIMESTAMP DEFAULT SYSDATE NOT NULL,
	Fecha_fin TIMESTAMP DEFAULT SYSDATE NOT NULL,
	Id_historico	NUMBER(6) NOT NULL,
	CONSTRAINT CK_T_fecha CHECK(Fecha_fin IS NULL OR Fecha_fin>Fecha_inicio)
);


CREATE TABLE QUIMICO_TRATAMIENTO (
	Id_quimico	NUMBER(6)	NOT NULL,
	Id_tratamiento NUMBER(6) NOT NULL,
	Cantidad NUMBER(6) NOT NULL,
	CONSTRAINT PK_QUIMICO_TRATAMIENTO PRIMARY KEY (Id_quimico, Id_tratamiento),
	CONSTRAINT FK_QT_QUIMICO FOREIGN KEY (Id_quimico) REFERENCES QUIMICO DEFERRABLE,
	CONSTRAINT FK_QT_TRATAMIENTO FOREIGN KEY (Id_tratamiento) REFERENCES TRATAMIENTO DEFERRABLE
);

CREATE TABLE RESULTADO (
	Id_resultado	NUMBER(6)	NOT NULL CONSTRAINT PK_RESULTADO PRIMARY KEY,
	Id_tratamiento NUMBER(6) NOT NULL,
	Fecha TIMESTAMP DEFAULT SYSDATE NOT NULL,
	Comentario VARCHAR2(50) NOT NULL,
	CONSTRAINT FK_RESULTADO_TRATAMIENTO FOREIGN KEY (Id_tratamiento) REFERENCES TRATAMIENTO DEFERRABLE
);

CREATE TABLE ESTADO (
    Id_tratamiento NUMBER(6) NOT NULL ,
	Fecha TIMESTAMP DEFAULT SYSDATE NOT NULL,
	Comentario VARCHAR2(50) NOT NULL,
	CONSTRAINT PK_ESTADO PRIMARY KEY (Id_tratamiento, Fecha),
	CONSTRAINT FK_ESTADO_TRATAMIENTO FOREIGN KEY (Id_tratamiento) REFERENCES TRATAMIENTO DEFERRABLE
);

CREATE TABLE VENDIMIA (
	Id_vendimia NUMBER(6) NOT NULL CONSTRAINT PK_VENDIMIA PRIMARY KEY,
	Fecha TIMESTAMP DEFAULT SYSDATE NOT NULL,
	Grados_uva NUMBER(6) NOT NULL,
	Acided NUMBER(6) NOT NULL,
	Cantidad NUMBER(6) NOT NULL,
	Porcentaje_agua NUMBER(6) NOT NULL,
	CONSTRAINT CK_Alcohol_Vendimia CHECK(Grados_uva>=0 AND Grados_uva<=100) DEFERRABLE,
	CONSTRAINT CK_Agua_Vendimia CHECK(Porcentaje_agua>=0 AND Porcentaje_agua<=100) DEFERRABLE
);

CREATE TABLE VENDIMIA_PROPIA (
	Id_vendimia NUMBER(6) NOT NULL CONSTRAINT PK_ID_VENDIMIA_PROPIA PRIMARY KEY,
	Id_vinnedo NUMBER(6) NOT NULL,
	CONSTRAINT FK_VPO_VENDIMIA FOREIGN KEY (Id_vendimia) REFERENCES VENDIMIA DEFERRABLE,
	CONSTRAINT FK_VPO_VINNEDO FOREIGN KEY (Id_vinnedo) REFERENCES vinnedo DEFERRABLE
);


CREATE TABLE VENDIMIA_PRIVADA (
	Id_vendimia NUMBER(6) NOT NULL CONSTRAINT PK_VENDIMIA_PROPIA PRIMARY KEY,
	Id_uva NUMBER(6) NOT NULL,
	CONSTRAINT FK_VPI_VENDIMIA FOREIGN KEY (Id_vendimia) REFERENCES VENDIMIA DEFERRABLE,
	CONSTRAINT FK_VPI_UVA FOREIGN KEY (Id_uva) REFERENCES TIPO_UVA DEFERRABLE
);

CREATE TABLE TIPO_VINO (
	Id_vino	NUMBER(6)	NOT NULL CONSTRAINT PK_TIPO_VINO PRIMARY KEY,
	Nombre	VARCHAR2(20)	NOT NULL,
	CONSTRAINT U_TIPO_VINO UNIQUE (Nombre)
);

CREATE TABLE UVA_VINO (
	Id_uva NUMBER(6) NOT NULL,
	Id_vino	NUMBER(6)	NOT NULL,
	Cantidad NUMBER(6) NOT NULL,
	Edad NUMBER(6) NOT NULL,
	Grado NUMBER(6) NOT NULL,
	CONSTRAINT PK_UVA_VINO PRIMARY KEY (Id_uva, Id_vino),
	CONSTRAINT FK_UV_uva FOREIGN KEY (Id_uva) REFERENCES TIPO_UVA DEFERRABLE,
	CONSTRAINT FK_UV_vino FOREIGN KEY (Id_vino) REFERENCES TIPO_VINO DEFERRABLE,
	CONSTRAINT CK_UV_GRADO CHECK(Grado>=0 AND Grado<=100)
);

CREATE TABLE PLANTILLA (
	Id_plantilla	NUMBER(6)	NOT NULL CONSTRAINT PK_PLANTILLA PRIMARY KEY,
	Id_tipo_vino	NUMBER(6)	NOT NULL,
	t_cuba_acero NUMBER(6) NOT NULL,
	t_barrica NUMBER(6) NOT NULL,
	CONSTRAINT FK_Plantilla_tvino FOREIGN KEY (Id_tipo_vino) REFERENCES TIPO_VINO DEFERRABLE
);

CREATE TABLE PRODUCCION (
	Id_produccion	NUMBER(6)	NOT NULL CONSTRAINT PK_PRODUCCION PRIMARY KEY,
	Id_tipo_vino	NUMBER(6)	NOT NULL,
	Fecha TIMESTAMP DEFAULT SYSDATE NOT NULL,
	CONSTRAINT FK_Produccion_TV FOREIGN KEY (Id_tipo_vino) REFERENCES TIPO_VINO
);

CREATE TABLE PRODUCCION_VENDIMIA (
	Id_produccion	NUMBER(6)	NOT NULL ,
	Id_vendimia	NUMBER(6)	NOT NULL,
	cantidad NUMBER(6) NOT NULL,
	CONSTRAINT PK_PRODUCCION_VENDIMIA PRIMARY KEY (Id_produccion, Id_vendimia),
	CONSTRAINT FK_PV_PRODUCCION FOREIGN KEY (Id_produccion) REFERENCES PRODUCCION DEFERRABLE,
	CONSTRAINT FK_PV_VENDIMIA FOREIGN KEY (Id_vendimia) REFERENCES VENDIMIA DEFERRABLE
);

CREATE TABLE FASE_CUBA_ACERO(
	Id_fase_cuba	NUMBER(6)	NOT NULL CONSTRAINT PK_Id_fase_cuba PRIMARY KEY,
	Id_produccion	NUMBER(6),
	Fecha TIMESTAMP DEFAULT NULL,
	Grado_alcohol	NUMBER(6),
	CONSTRAINT CK_Fecha1 CHECK(Grado_alcohol>=0 AND Grado_alcohol<=100),
	CONSTRAINT FK_FCA_Produccion1 FOREIGN KEY (Id_produccion) REFERENCES PRODUCCION DEFERRABLE
);


CREATE TABLE CUBA_ACERO (
	N_cuba_acero	NUMBER(6)	NOT NULL CONSTRAINT PK_CUBA_ACERO PRIMARY KEY
);


CREATE TABLE FASE_CA_CA(
	Id_fase_cuba	NUMBER(6)	NOT NULL ,
	N_cuba_acero NUMBER(6) NOT NULL,
	CONSTRAINT PK_FASE_CA_CA PRIMARY KEY (Id_fase_cuba, n_cuba_acero),
	CONSTRAINT FK_FCACS_FCA FOREIGN KEY (Id_fase_cuba) REFERENCES FASE_CUBA_ACERO DEFERRABLE,
	CONSTRAINT FK_FCACS_CA FOREIGN KEY (N_cuba_acero) REFERENCES CUBA_ACERO DEFERRABLE
);


CREATE TABLE FASE_BARRICA(
	Id_fase_barrica	NUMBER(6)	NOT NULL CONSTRAINT PK_FASE_BARRICA PRIMARY KEY,
	Id_fase_cuba	NUMBER(6)	NOT NULL ,
	Notas	VARCHAR2(50),
	CONSTRAINT FK_FB_FCA FOREIGN KEY (Id_fase_cuba) REFERENCES FASE_CUBA_ACERO DEFERRABLE
);

CREATE TABLE ANTIGUEDAD(
    Edad NUMBER(6) NOT NULL CONSTRAINT PK_ANTIGUEDAD PRIMARY KEY,
	CONSTRAINT CK_ANTIGUEDAD CHECK(Edad<=3 AND Edad>=0)
);

CREATE TABLE BARRICA (
	N_barrica NUMBER(6) NOT NULL CONSTRAINT PK_BARRICA PRIMARY KEY,
	Edad NUMBER(6) NOT NULL,
	CONSTRAINT FK_BARRICA_EDAD FOREIGN KEY (Edad) REFERENCES ANTIGUEDAD
);

CREATE TABLE CAJA(
	Id_caja NUMBER(6)	NOT NULL CONSTRAINT PK_Caja PRIMARY KEY,
	Fecha DATE DEFAULT SYSDATE NOT NULL,
	Id_f_barrica NUMBER(6) NOT NULL,
	CONSTRAINT FK_CAJA_FB FOREIGN KEY (Id_f_barrica) REFERENCES FASE_BARRICA
);

/*6. Implementar las restricciones no soportadas por el SQL de Oracle y la lógica de negocio planteada
mediante Triggers.*/
--Estos son los triguers para uqe las ids se asignen automaticamente
CREATE SEQUENCE TIPOS_TERRENOS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE TIPOS_UVAS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE TIPOS_ABONOS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE QUIMICOS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE TERRENOS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE VINNEDOS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE PLAGAS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE HISTORICOS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE TRATAMIENTOS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE RESULTADOS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE VENDIMIAS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE VINOS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE PLANTILLAS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE PRODUCCIONES	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE FASES_CUBAS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE FASES_BARRICAS	INCREMENT BY 1 START WITH 1 ;
CREATE SEQUENCE CAJAS	INCREMENT BY 1 START WITH 1 ;


CREATE OR REPLACE TRIGGER TIPO_TERRENO_PK 
	BEFORE INSERT ON TIPO_TERRENO
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_tipo_terreno IS NULL THEN 
	         SELECT TIPOS_TERRENOS.NEXTVAL INTO :NEW.Id_tipo_terreno FROM DUAL;
	      END IF;
	   END IF; 
END TIPO_TERRENO_PK ;
/

CREATE OR REPLACE TRIGGER TIPOS_UVAS_PK 
	BEFORE INSERT ON TIPO_UVA
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_uva IS NULL THEN 
	         SELECT TIPOS_UVAS.NEXTVAL INTO :NEW.Id_uva FROM DUAL;
	      END IF;
	   END IF; 
END TIPOS_UVAS_PK ;
/

CREATE OR REPLACE TRIGGER TIPOS_ABONOS_PK 
	BEFORE INSERT ON TIPO_ABONO
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_abono IS NULL THEN 
	         SELECT TIPOS_ABONOS.NEXTVAL INTO :NEW.Id_abono FROM DUAL;
	      END IF;
	   END IF; 
END TIPOS_ABONOS_PK ;
/

CREATE OR REPLACE TRIGGER QUIMICOS_PK 
	BEFORE INSERT ON QUIMICO
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_quimico IS NULL THEN 
	         SELECT QUIMICOS.NEXTVAL INTO :NEW.Id_quimico FROM DUAL;
	      END IF;
	   END IF; 
END QUIMICOS_PK ;
/

CREATE OR REPLACE TRIGGER TERRENOS_PK 
	BEFORE INSERT ON TERRENO
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_terreno IS NULL THEN 
	         SELECT TERRENOS.NEXTVAL INTO :NEW.Id_terreno FROM DUAL;
	      END IF;
	   END IF; 
END TERRENOS_PK ;
/

CREATE OR REPLACE TRIGGER VINNEDOS_PK 
	BEFORE INSERT ON VINNEDO
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_vinnedo IS NULL THEN 
	         SELECT VINNEDOS.NEXTVAL INTO :NEW.Id_vinnedo FROM DUAL;
	      END IF;
	   END IF; 
END VINNEDOS_PK ;
/

CREATE OR REPLACE TRIGGER PLAGAS_PK 
	BEFORE INSERT ON PLAGA
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_plaga IS NULL THEN 
	         SELECT PLAGAS.NEXTVAL INTO :NEW.Id_plaga FROM DUAL;
	      END IF;
	   END IF; 
END PLAGAS_PK ;
/

CREATE OR REPLACE TRIGGER HISTORICOS_PK 
	BEFORE INSERT ON HISTORICO_PLAGA
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_historico IS NULL THEN 
	         SELECT HISTORICOS.NEXTVAL INTO :NEW.Id_historico FROM DUAL;
	      END IF;
	   END IF; 
END HISTORICOS_PK ;
/

CREATE OR REPLACE TRIGGER TRATAMIENTOS_PK 
	BEFORE INSERT ON TRATAMIENTO
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_TRATAMIENTO IS NULL THEN 
	         SELECT TRATAMIENTOS.NEXTVAL INTO :NEW.Id_TRATAMIENTO FROM DUAL;
	      END IF;
	   END IF; 
END TRATAMIENTOS_PK ;
/

CREATE OR REPLACE TRIGGER RESULTADOS_PK 
	BEFORE INSERT ON RESULTADO
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_RESULTADO IS NULL THEN 
	         SELECT RESULTADOS.NEXTVAL INTO :NEW.Id_RESULTADO FROM DUAL;
	      END IF;
	   END IF; 
END RESULTADOS_PK ;
/

CREATE OR REPLACE TRIGGER VENDIMIAS_PK 
	BEFORE INSERT ON VENDIMIA
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_VENDIMIA IS NULL THEN 
	         SELECT VENDIMIAS.NEXTVAL INTO :NEW.Id_VENDIMIA FROM DUAL;
	      END IF;
	   END IF; 
END VENDIMIAS_PK ;
/

CREATE OR REPLACE TRIGGER VINOS_PK 
	BEFORE INSERT ON TIPO_VINO
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_VINO IS NULL THEN 
	         SELECT VINOS.NEXTVAL INTO :NEW.Id_VINO FROM DUAL;
	      END IF;
	   END IF; 
END VINOS_PK ;
/

CREATE OR REPLACE TRIGGER PLANTILLAS_PK 
	BEFORE INSERT ON PLANTILLA
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_PLANTILLA IS NULL THEN 
	         SELECT PLANTILLAS.NEXTVAL INTO :NEW.Id_PLANTILLA FROM DUAL;
	      END IF;
	   END IF; 
END PLANTILLAS_PK ;
/

CREATE OR REPLACE TRIGGER PRODUCCIONES_PK 
	BEFORE INSERT ON PRODUCCION
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_PRODUCCION IS NULL THEN 
	         SELECT PRODUCCIONES.NEXTVAL INTO :NEW.Id_PRODUCCION FROM DUAL;
	      END IF;
	   END IF; 
END PRODUCCIONES_PK ;
/

CREATE OR REPLACE TRIGGER FASES_CUBAS_PK 
	BEFORE INSERT ON FASE_CUBA_ACERO
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_FASE_CUBA IS NULL THEN 
	         SELECT FASES_CUBAS.NEXTVAL INTO :NEW.Id_FASE_CUBA FROM DUAL;
	      END IF;
	   END IF; 
END FASES_CUBAS_PK ;
/

CREATE OR REPLACE TRIGGER FASES_BARRICAS_PK 
	BEFORE INSERT ON FASE_BARRICA
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_FASE_BARRICA IS NULL THEN 
	         SELECT FASES_BARRICAS.NEXTVAL INTO :NEW.Id_FASE_BARRICA FROM DUAL;
	      END IF;
	   END IF; 
END FASES_BARRICAS_PK ;
/

CREATE OR REPLACE TRIGGER CAJAS_PK 
	BEFORE INSERT ON CAJA
	FOR EACH ROW
	BEGIN
	   IF INSERTING THEN
	      IF :NEW.Id_CAJA IS NULL THEN 
	         SELECT CAJAS.NEXTVAL INTO :NEW.Id_CAJA FROM DUAL;
	      END IF;
	   END IF; 
END CAJAS_PK ;
/

/*
7. Insertar datos coherentes en las distintas tablas para poder hacer consultas y probar los Triggers.
*/
INSERT INTO HUMEDAD(humedad) VALUES (1);
INSERT INTO HUMEDAD(humedad) VALUES (2);
INSERT INTO HUMEDAD(humedad) VALUES (5);
INSERT INTO HUMEDAD(humedad) VALUES (50);
INSERT INTO HUMEDAD(humedad) VALUES (70);
INSERT INTO HUMEDAD(humedad) VALUES (79);
INSERT INTO HUMEDAD(humedad) VALUES (92);




INSERT INTO SOL(horas) VALUES (1);
INSERT INTO SOL(horas) VALUES (2);
INSERT INTO SOL(horas) VALUES (3);
INSERT INTO SOL(horas) VALUES (4);
INSERT INTO SOL(horas) VALUES (5);
INSERT INTO SOL(horas) VALUES (6);
INSERT INTO SOL(horas) VALUES (7);
INSERT INTO SOL(horas) VALUES (8);
INSERT INTO SOL(horas) VALUES (9);
INSERT INTO SOL(horas) VALUES (10);
INSERT INTO SOL(horas) VALUES (11);
INSERT INTO SOL(horas) VALUES (12);



INSERT INTO TIPO_TERRENO(Id_tipo_terreno, tipo) VALUES (1, 'dura');
INSERT INTO TIPO_TERRENO(Id_tipo_terreno, tipo) VALUES (2, 'blanda');
INSERT INTO TIPO_TERRENO(Id_tipo_terreno, tipo) VALUES (3, 'seca');
INSERT INTO TIPO_TERRENO(Id_tipo_terreno, tipo) VALUES (4, 'peleona');
INSERT INTO TIPO_TERRENO(Id_tipo_terreno, tipo) VALUES (5, 'arenisca');



INSERT INTO TIPO_UVA(Id_uva, Tipo_uva, Frec_abonado) VALUES (1, 'roja', 2);
INSERT INTO TIPO_UVA(Id_uva, Tipo_uva, Frec_abonado) VALUES (2, 'verde', 3);
INSERT INTO TIPO_UVA(Id_uva, Tipo_uva, Frec_abonado) VALUES (3, 'morada', 4);
INSERT INTO TIPO_UVA(Id_uva, Tipo_uva, Frec_abonado) VALUES (4, 'dura', 5);
INSERT INTO TIPO_UVA(Id_uva, Tipo_uva, Frec_abonado) VALUES (5, 'mala', 7);
INSERT INTO TIPO_UVA(Id_uva, Tipo_uva, Frec_abonado) VALUES (6, 'gallega', 8);


INSERT INTO TIPO_ABONO(Id_abono, nombre) VALUES (1, 'estiercoles');
INSERT INTO TIPO_ABONO(Id_abono, nombre) VALUES (2, 'gusano');
INSERT INTO TIPO_ABONO(Id_abono, nombre) VALUES (3, 'gallinaza');
INSERT INTO TIPO_ABONO(Id_abono, nombre) VALUES (4, 'turba');
INSERT INTO TIPO_ABONO(Id_abono, nombre) VALUES (5, 'extractos humicos');
INSERT INTO TIPO_ABONO(Id_abono, nombre) VALUES (6, 'fertilizante mineral');
INSERT INTO TIPO_ABONO(Id_abono, nombre) VALUES (7, 'abono foliar');



INSERT INTO QUIMICO(Id_quimico, nombre) VALUES (1, 'azufre');
INSERT INTO QUIMICO(Id_quimico, nombre) VALUES (2, 'carbon');
INSERT INTO QUIMICO(Id_quimico, nombre) VALUES (3, 'nitrato potasico');
INSERT INTO QUIMICO(Id_quimico, nombre) VALUES (4, 'clorato');
INSERT INTO QUIMICO(Id_quimico, nombre) VALUES (5, 'nitrato ferroso');
INSERT INTO QUIMICO(Id_quimico, nombre) VALUES (6, 'almidon');
INSERT INTO QUIMICO(Id_quimico, nombre) VALUES (7, 'cloruro amonico');



INSERT INTO TERRENO (Id_terreno, tamano, Id_tipo_terreno) VALUES (1, 120, 1);
INSERT INTO TERRENO (Id_terreno, tamano, Id_tipo_terreno) VALUES (2, 120, 2);
INSERT INTO TERRENO (Id_terreno, tamano, Id_tipo_terreno) VALUES (3, 120, 3);
INSERT INTO TERRENO (Id_terreno, tamano, Id_tipo_terreno) VALUES (4, 120, 4);
INSERT INTO TERRENO (Id_terreno, tamano, Id_tipo_terreno) VALUES (5, 120, 5);



INSERT INTO vinnedo (Id_vinnedo, Porcentaje_agua, Nombre, Id_uva, Id_terreno) VALUES (1, 5, 'unicornio', 1, 1);
INSERT INTO vinnedo (Id_vinnedo, Porcentaje_agua, Nombre, Id_uva, Id_terreno) VALUES (2, 60, 'gargola', 2, 2);
INSERT INTO vinnedo (Id_vinnedo, Porcentaje_agua, Nombre, Id_uva, Id_terreno) VALUES (3, 54, 'dragon', 1, 3);
INSERT INTO vinnedo (Id_vinnedo, Porcentaje_agua, Nombre, Id_uva, Id_terreno) VALUES (4, 20, 'delfin', 3, 4);
INSERT INTO vinnedo (Id_vinnedo, Porcentaje_agua, Nombre, Id_uva, Id_terreno) VALUES (5, 88, 'mamut', 4, 5);


INSERT INTO SOL_TERRENO (Horas_sol, Id_terreno, fecha) VALUES (1, 1, '15/Dic/2009');
INSERT INTO SOL_TERRENO (Horas_sol, Id_terreno, fecha) VALUES (2, 1, '16/Dic/2009');
INSERT INTO SOL_TERRENO (Horas_sol, Id_terreno, fecha) VALUES (3, 1, '17/Dic/2009');
INSERT INTO SOL_TERRENO (Horas_sol, Id_terreno, fecha) VALUES (4, 1, '18/Dic/2009');
INSERT INTO SOL_TERRENO (Horas_sol, Id_terreno, fecha) VALUES (5, 1, '19/Dic/2009');
INSERT INTO SOL_TERRENO (Horas_sol, Id_terreno, fecha) VALUES (6, 1, '20/Dic/2009');
INSERT INTO SOL_TERRENO (Horas_sol, Id_terreno, fecha) VALUES (7, 1, '21/Dic/2009');


INSERT INTO HUMEDAD_TERRENO (Humedad, Id_terreno, fecha) VALUES (1, 1, '21/Dic/2009');
INSERT INTO HUMEDAD_TERRENO (Humedad, Id_terreno, fecha) VALUES (2, 1, '22/Dic/2009');
INSERT INTO HUMEDAD_TERRENO (Humedad, Id_terreno, fecha) VALUES (5, 1, '23/Dic/2009');
INSERT INTO HUMEDAD_TERRENO (Humedad, Id_terreno, fecha) VALUES (50, 1, '24Dic/2009');
INSERT INTO HUMEDAD_TERRENO (Humedad, Id_terreno, fecha) VALUES (50, 1, '25/Dic/2009');
INSERT INTO HUMEDAD_TERRENO (Humedad, Id_terreno, fecha) VALUES (79, 1, '26/Dic/2009');
INSERT INTO HUMEDAD_TERRENO (Humedad, Id_terreno, fecha) VALUES (2, 1, '27/Dic/2009');


INSERT INTO ABONO_HUMEDAD (Humedad, Id_abono) VALUES (1, 1);
INSERT INTO ABONO_HUMEDAD (Humedad, Id_abono) VALUES (2, 2);
INSERT INTO ABONO_HUMEDAD (Humedad, Id_abono) VALUES (5, 3);
INSERT INTO ABONO_HUMEDAD (Humedad, Id_abono) VALUES (50, 4);
INSERT INTO ABONO_HUMEDAD (Humedad, Id_abono) VALUES (70, 5);
INSERT INTO ABONO_HUMEDAD (Humedad, Id_abono) VALUES (79, 6);
INSERT INTO ABONO_HUMEDAD (Humedad, Id_abono) VALUES (92, 7);



INSERT INTO ABONO_TIPO_TERRENO (Id_tipo_terreno, Id_abono) VALUES (1, 1);
INSERT INTO ABONO_TIPO_TERRENO (Id_tipo_terreno, Id_abono) VALUES (1, 5);
INSERT INTO ABONO_TIPO_TERRENO (Id_tipo_terreno, Id_abono) VALUES (2, 6);
INSERT INTO ABONO_TIPO_TERRENO (Id_tipo_terreno, Id_abono) VALUES (2, 5);
INSERT INTO ABONO_TIPO_TERRENO (Id_tipo_terreno, Id_abono) VALUES (3, 6);
INSERT INTO ABONO_TIPO_TERRENO (Id_tipo_terreno, Id_abono) VALUES (4, 3);



INSERT INTO ABONO_TERRENO (Id_terreno, Id_abono, fecha, Cantidad) VALUES (1, 1, '1/Dic/2009', 100);
INSERT INTO ABONO_TERRENO (Id_terreno, Id_abono, fecha, Cantidad) VALUES (1, 2, '2/Dic/2009', 20);
INSERT INTO ABONO_TERRENO (Id_terreno, Id_abono, fecha, Cantidad) VALUES (3, 1, '3/Dic/2009', 10);
INSERT INTO ABONO_TERRENO (Id_terreno, Id_abono, fecha, Cantidad) VALUES (2, 2, '4/Dic/2009', 40);
INSERT INTO ABONO_TERRENO (Id_terreno, Id_abono, fecha, Cantidad) VALUES (2, 3, '5/Dic/2009', 80);
INSERT INTO ABONO_TERRENO (Id_terreno, Id_abono, fecha, Cantidad) VALUES (4, 4, '6/Dic/2009', 140);



INSERT INTO PLAGA(Id_plaga, nombre) VALUES (1, 'lombriz de tierra');
INSERT INTO PLAGA(Id_plaga, nombre) VALUES (2, 'pulgón verde');
INSERT INTO PLAGA(Id_plaga, nombre) VALUES (3, 'araña amarilla');
INSERT INTO PLAGA(Id_plaga, nombre) VALUES (4, 'barrenador');
INSERT INTO PLAGA(Id_plaga, nombre) VALUES (5, 'mosca blanca');
INSERT INTO PLAGA(Id_plaga, nombre) VALUES (6, 'cochinilla');
INSERT INTO PLAGA(Id_plaga, nombre) VALUES (7, 'araña roja');
INSERT INTO PLAGA(Id_plaga, nombre) VALUES (8, 'hormigas');



INSERT INTO HISTORICO_PLAGA(Fecha_inicio, Fecha_fin, Id_terreno, Id_plaga) VALUES ('6/Dic/2009', '10/Dic/2009', 1, 1);
INSERT INTO HISTORICO_PLAGA(Fecha_inicio, Fecha_fin, Id_terreno, Id_plaga) VALUES ('7/Dic/2009', '8/Dic/2009', 1, 1);
INSERT INTO HISTORICO_PLAGA(Fecha_inicio, Fecha_fin, Id_terreno, Id_plaga) VALUES ('9/Dic/2009', '16/Dic/2009', 2, 2);
INSERT INTO HISTORICO_PLAGA(Fecha_inicio, Fecha_fin, Id_terreno, Id_plaga) VALUES ('13/Dic/2009', '22/Dic/2009', 3, 1);
INSERT INTO HISTORICO_PLAGA(Fecha_inicio, Fecha_fin, Id_terreno, Id_plaga) VALUES ('20/Dic/2009', '31/Dic/2009', 4, 3);



INSERT INTO TRATAMIENTO(Id_tratamiento, Fecha_inicio, Fecha_fin, Id_historico) VALUES (1, '6/Dic/2009', '10/Dic/2009', 1);
INSERT INTO TRATAMIENTO(Id_tratamiento, Fecha_inicio, Fecha_fin, Id_historico) VALUES (2, '7/Dic/2009', '8/Dic/2009', 2);
INSERT INTO TRATAMIENTO(Id_tratamiento, Fecha_inicio, Fecha_fin, Id_historico) VALUES (3, '9/Dic/2009', '16/Dic/2009', 2);
INSERT INTO TRATAMIENTO(Id_tratamiento, Fecha_inicio, Fecha_fin, Id_historico) VALUES (4, '13/Dic/2009', '22/Dic/2009', 3);
INSERT INTO TRATAMIENTO(Id_tratamiento, Fecha_inicio, Fecha_fin, Id_historico) VALUES (5, '20/Dic/2009', '31/Dic/2009', 4);


INSERT INTO QUIMICO_TRATAMIENTO(Id_quimico, Id_tratamiento, Cantidad) VALUES (1, 1, 100);
INSERT INTO QUIMICO_TRATAMIENTO(Id_quimico, Id_tratamiento, Cantidad) VALUES (2, 1, 170);
INSERT INTO QUIMICO_TRATAMIENTO(Id_quimico, Id_tratamiento, Cantidad) VALUES (3, 2, 130);
INSERT INTO QUIMICO_TRATAMIENTO(Id_quimico, Id_tratamiento, Cantidad) VALUES (4, 2, 780);
INSERT INTO QUIMICO_TRATAMIENTO(Id_quimico, Id_tratamiento, Cantidad) VALUES (5, 3, 200);



INSERT INTO RESULTADO(Id_resultado, Id_tratamiento, Fecha, Comentario) VALUES (1, 1,'15/Dic/2009', 'el culvito no mejoro');
INSERT INTO RESULTADO(Id_resultado, Id_tratamiento, Fecha, Comentario) VALUES (2, 1,'16/Dic/2009', 'la plaga prosiguio');
INSERT INTO RESULTADO(Id_resultado, Id_tratamiento, Fecha, Comentario) VALUES (3, 2,'17/Dic/2009', 'la plaga se duplico');
INSERT INTO RESULTADO(Id_resultado, Id_tratamiento, Fecha, Comentario) VALUES (4, 3,'18/Dic/2009', 'la plaga se junto con otra plaga');
INSERT INTO RESULTADO(Id_resultado, Id_tratamiento, Fecha, Comentario) VALUES (5, 3,'19/Dic/2009', 'todo salio mal');


INSERT INTO ESTADO(Id_tratamiento, Fecha, Comentario) VALUES (1, '15/Dic/2009', 'mejorando el cultivo');
INSERT INTO ESTADO(Id_tratamiento, Fecha, Comentario) VALUES (2, '16/Dic/2009', 'empeorando el cultivo');
INSERT INTO ESTADO(Id_tratamiento, Fecha, Comentario) VALUES (3, '17/Dic/2009', 'los tomates no sale esta genial');
INSERT INTO ESTADO(Id_tratamiento, Fecha, Comentario) VALUES (2, '18/Dic/2009', 'la tierra estra podrida');
INSERT INTO ESTADO(Id_tratamiento, Fecha, Comentario) VALUES (1, '19/Dic/2009', 'salen gusanos por todos los lados');


INSERT INTO VENDIMIA(Id_vendimia, Fecha, Grados_uva, Porcentaje_agua, Acided, Cantidad) VALUES (1, '15/Dic/2009', 50, 20, 3, 1000);
INSERT INTO VENDIMIA(Id_vendimia, Fecha, Grados_uva, Porcentaje_agua, Acided, Cantidad) VALUES (2, '16/Dic/2009', 50, 15, 4, 2000);
INSERT INTO VENDIMIA(Id_vendimia, Fecha, Grados_uva, Porcentaje_agua, Acided, Cantidad) VALUES (3, '17/Dic/2009', 60, 78, 70, 1000);
INSERT INTO VENDIMIA(Id_vendimia, Fecha, Grados_uva, Porcentaje_agua, Acided, Cantidad) VALUES (4, '18/Dic/2009', 80, 90, 20, 1503);
INSERT INTO VENDIMIA(Id_vendimia, Fecha, Grados_uva, Porcentaje_agua, Acided, Cantidad) VALUES (5, '19/Dic/2009', 20, 20, 10, 865);



INSERT INTO VENDIMIA_PROPIA(Id_vendimia, Id_vinnedo) VALUES (1, 1);
INSERT INTO VENDIMIA_PROPIA(Id_vendimia, Id_vinnedo) VALUES (2, 2);
INSERT INTO VENDIMIA_PROPIA(Id_vendimia, Id_vinnedo) VALUES (3, 3);
INSERT INTO VENDIMIA_PROPIA(Id_vendimia, Id_vinnedo) VALUES (4, 4);
INSERT INTO VENDIMIA_PROPIA(Id_vendimia, Id_vinnedo) VALUES (5, 5);



INSERT INTO VENDIMIA_PRIVADA(Id_vendimia, Id_uva) VALUES (1, 1);
INSERT INTO VENDIMIA_PRIVADA(Id_vendimia, Id_uva) VALUES (2, 2);
INSERT INTO VENDIMIA_PRIVADA(Id_vendimia, Id_uva) VALUES (3, 3);
INSERT INTO VENDIMIA_PRIVADA(Id_vendimia, Id_uva) VALUES (4, 4);
INSERT INTO VENDIMIA_PRIVADA(Id_vendimia, Id_uva) VALUES (5, 4);




INSERT INTO TIPO_VINO(Id_vino, Nombre) VALUES (1, 'Acevino');
INSERT INTO TIPO_VINO(Id_vino, Nombre) VALUES (2, 'Enate');
INSERT INTO TIPO_VINO(Id_vino, Nombre) VALUES (3, 'Gran Caus');
INSERT INTO TIPO_VINO(Id_vino, Nombre) VALUES (4, 'Gran Feudo');
INSERT INTO TIPO_VINO(Id_vino, Nombre) VALUES (5, 'Gran Tehyda');
INSERT INTO TIPO_VINO(Id_vino, Nombre) VALUES (6, 'Jaume Grmerlot');
INSERT INTO TIPO_VINO(Id_vino, Nombre) VALUES (7, 'Mas de Bazan');



INSERT INTO UVA_VINO(Id_uva, Id_vino, Cantidad, Edad, Grado) VALUES (1, 1, 100, 3, 8);
INSERT INTO UVA_VINO(Id_uva, Id_vino, Cantidad, Edad, Grado) VALUES (2, 2, 120, 5, 20);
INSERT INTO UVA_VINO(Id_uva, Id_vino, Cantidad, Edad, Grado) VALUES (3, 3, 130, 2, 30);
INSERT INTO UVA_VINO(Id_uva, Id_vino, Cantidad, Edad, Grado) VALUES (4, 4, 140, 1, 50);
INSERT INTO UVA_VINO(Id_uva, Id_vino, Cantidad, Edad, Grado) VALUES (5, 5, 150, 6, 3);
INSERT INTO UVA_VINO(Id_uva, Id_vino, Cantidad, Edad, Grado) VALUES (6, 6, 90, 10, 7);



INSERT INTO PLANTILLA(Id_plantilla, Id_tipo_vino, t_cuba_acero, t_barrica) VALUES (1, 1, 90, 10);
INSERT INTO PLANTILLA(Id_plantilla, Id_tipo_vino, t_cuba_acero, t_barrica) VALUES (2, 2, 10, 20);
INSERT INTO PLANTILLA(Id_plantilla, Id_tipo_vino, t_cuba_acero, t_barrica) VALUES (3, 3, 100, 10);
INSERT INTO PLANTILLA(Id_plantilla, Id_tipo_vino, t_cuba_acero, t_barrica) VALUES (4, 4, 75, 13);
INSERT INTO PLANTILLA(Id_plantilla, Id_tipo_vino, t_cuba_acero, t_barrica) VALUES (5, 5, 40, 17);


INSERT INTO PRODUCCION(Id_produccion, Id_tipo_vino, Fecha) VALUES (1, 1, '15/Dic/2009');
INSERT INTO PRODUCCION(Id_produccion, Id_tipo_vino, Fecha) VALUES (2, 2, '16/Dic/2009');
INSERT INTO PRODUCCION(Id_produccion, Id_tipo_vino, Fecha) VALUES (3, 3, '17/Dic/2009');
INSERT INTO PRODUCCION(Id_produccion, Id_tipo_vino, Fecha) VALUES (4, 4, '18/Dic/2009');
INSERT INTO PRODUCCION(Id_produccion, Id_tipo_vino, Fecha) VALUES (5, 5, '19/Dic/2009');



INSERT INTO PRODUCCION_VENDIMIA(Id_produccion, Id_vendimia, cantidad) VALUES (1, 1, 1000);
INSERT INTO PRODUCCION_VENDIMIA(Id_produccion, Id_vendimia, cantidad) VALUES (1, 2, 200);
INSERT INTO PRODUCCION_VENDIMIA(Id_produccion, Id_vendimia, cantidad) VALUES (2, 3, 3000);
INSERT INTO PRODUCCION_VENDIMIA(Id_produccion, Id_vendimia, cantidad) VALUES (3, 4, 4000);
INSERT INTO PRODUCCION_VENDIMIA(Id_produccion, Id_vendimia, cantidad) VALUES (4, 5, 5000);


INSERT INTO FASE_CUBA_ACERO(Id_fase_cuba, Id_produccion, Fecha, Grado_alcohol) VALUES (1, 1, '15/Dic/2009', 100);
INSERT INTO FASE_CUBA_ACERO(Id_fase_cuba, Id_produccion, Fecha, Grado_alcohol) VALUES (2, 2, '16/Dic/2009', 10);
INSERT INTO FASE_CUBA_ACERO(Id_fase_cuba, Id_produccion, Fecha, Grado_alcohol) VALUES (3, 3, '17/Dic/2009', 20);
INSERT INTO FASE_CUBA_ACERO(Id_fase_cuba, Id_produccion, Fecha, Grado_alcohol) VALUES (4, 4, '18/Dic/2009', 80);
INSERT INTO FASE_CUBA_ACERO(Id_fase_cuba, Id_produccion, Fecha, Grado_alcohol) VALUES (5, 5, '19/Dic/2009', 90);


INSERT INTO CUBA_ACERO(N_cuba_acero) VALUES (1);
INSERT INTO CUBA_ACERO(N_cuba_acero) VALUES (2);
INSERT INTO CUBA_ACERO(N_cuba_acero) VALUES (3);
INSERT INTO CUBA_ACERO(N_cuba_acero) VALUES (4);
INSERT INTO CUBA_ACERO(N_cuba_acero) VALUES (5);
INSERT INTO CUBA_ACERO(N_cuba_acero) VALUES (6);


INSERT INTO FASE_CA_CA(Id_fase_cuba, N_cuba_acero) VALUES (1, 1);
INSERT INTO FASE_CA_CA(Id_fase_cuba, N_cuba_acero) VALUES (2, 2);
INSERT INTO FASE_CA_CA(Id_fase_cuba, N_cuba_acero) VALUES (3, 3);
INSERT INTO FASE_CA_CA(Id_fase_cuba, N_cuba_acero) VALUES (4, 4);
INSERT INTO FASE_CA_CA(Id_fase_cuba, N_cuba_acero) VALUES (5, 5);


INSERT INTO FASE_BARRICA(Id_fase_barrica, Id_fase_cuba, Notas) VALUES (1, 1, 'nada en especial1');
INSERT INTO FASE_BARRICA(Id_fase_barrica, Id_fase_cuba, Notas) VALUES (2, 2, '2nada en especial1');
INSERT INTO FASE_BARRICA(Id_fase_barrica, Id_fase_cuba, Notas) VALUES (3, 3, '3nada en especial1');
INSERT INTO FASE_BARRICA(Id_fase_barrica, Id_fase_cuba, Notas) VALUES (4, 4, '4nada en especial1');
INSERT INTO FASE_BARRICA(Id_fase_barrica, Id_fase_cuba, Notas) VALUES (5, 5, '5nada en especial1');



INSERT INTO ANTIGUEDAD(Edad) VALUES (1);
INSERT INTO ANTIGUEDAD(Edad) VALUES (2);
INSERT INTO ANTIGUEDAD(Edad) VALUES (3);


INSERT INTO BARRICA(N_barrica, Edad) VALUES (1, 1);
INSERT INTO BARRICA(N_barrica, Edad) VALUES (2, 1);
INSERT INTO BARRICA(N_barrica, Edad) VALUES (3, 2);
INSERT INTO BARRICA(N_barrica, Edad) VALUES (4, 2);
INSERT INTO BARRICA(N_barrica, Edad) VALUES (5, 3);
INSERT INTO BARRICA(N_barrica, Edad) VALUES (6, 3);
INSERT INTO BARRICA(N_barrica, Edad) VALUES (7, 3);


INSERT INTO CAJA(Id_caja, Fecha, Id_f_barrica) VALUES (1, '15/Dic/2009', 1);
INSERT INTO CAJA(Id_caja, Fecha, Id_f_barrica) VALUES (2,  '16/Dic/2009', 2);
INSERT INTO CAJA(Id_caja, Fecha, Id_f_barrica) VALUES (3,'17/Dic/2009', 1);
INSERT INTO CAJA(Id_caja, Fecha, Id_f_barrica) VALUES (4, '18/Dic/2009', 2);
INSERT INTO CAJA(Id_caja, Fecha, Id_f_barrica) VALUES (5, '19/Dic/2009', 5);

/*
8. Atendiendo a la lógica de negocio planteada, implementar mediante Triggers las siguientes
restricciones:
a) Al tratar de mezclar varios tipos de uva en determinadas cantidades, si se desvían en un 15%
a lo establecido en las plantillas para conseguir el tipo de vino mostrará un error y no
permitirá la inserción.
*/

DROP TABLE TMP_PRODUCCION_VENDIMIA;
CREATE TABLE TMP_PRODUCCION_VENDIMIA AS SELECT * FROM PRODUCCION_VENDIMIA;

CREATE OR REPLACE TRIGGER tr_PV_tmp
BEFORE INSERT OR UPDATE ON PRODUCCION_VENDIMIA
BEGIN
  DELETE FROM TMP_PRODUCCION_VENDIMIA;
  INSERT INTO TMP_PRODUCCION_VENDIMIA SELECT * FROM PRODUCCION_VENDIMIA;
  DBMS_OUTPUT.PUT_LINE ('Creando tabla temporal');
END tr_PV_tmp;
/

CREATE OR REPLACE TRIGGER TR_PORCENTAJES_UVAS 
	BEFORE INSERT OR UPDATE ON PRODUCCION_VENDIMIA
	FOR EACH ROW
	DECLARE
	    total_uvas_hay NUMBER(6);
		total_uvas_plantilla NUMBER(6);
		t_uva NUMBER(6);
		t_vino NUMBER(6);
		vendimia NUMBER(6);
		cant NUMBER(6);
		aux NUMBER(6);
		porcentaje_plantilla NUMBER(6);
		p_hay NUMBER(6);
		CURSOR PUVAS(p IN NUMBER) IS SELECT id_vendimia, cantidad FROM TMP_PRODUCCION_VENDIMIA WHERE id_produccion=p;
		err EXCEPTION;
	BEGIN
	    total_uvas_hay:=0;
		SELECT id_tipo_vino INTO t_vino
		FROM PRODUCCION
		WHERE id_produccion= :NEW.id_produccion;
		SELECT SUM(cantidad) INTO total_uvas_plantilla
		FROM UVA_VINO
		WHERE id_vino=t_vino;
		OPEN puvas(:NEW.id_produccion);
		FETCH puvas INTO vendimia, cant;
		WHILE(puvas%FOUND) LOOP
			total_uvas_hay:=total_uvas_hay+cant;
			FETCH puvas INTO vendimia, cant;
		END LOOP;
		CLOSE puvas;
		OPEN puvas(:NEW.id_produccion);
		FETCH puvas INTO vendimia, cant;
		WHILE(puvas%FOUND) LOOP
			SELECT count(*) INTO aux
			FROM VENDIMIA_PRIVADA
			WHERE id_vendimia=vendimia;
			IF aux=0 THEN
				SELECT vinnedo.id_uva INTO t_uva
				FROM VINNEDO JOIN VENDIMIA_PROPIA ON (VINNEDO.id_vinnedo=VENDIMIA_PROPIA.id_vinnedo)
				WHERE id_vendimia=vendimia;
			ELSE 
				SELECT vendimia_privada.id_uva INTO t_uva
				FROM VENDIMIA_PRIVADA
				WHERE id_vendimia=vendimia;
			END IF;
			SELECT (UVA_VINO.cantidad/total_uvas_plantilla) INTO porcentaje_plantilla
			FROM UVA_VINO
			WHERE id_vino=t_vino AND id_uva=t_uva;
			SELECT (TMP_PRODUCCION_VENDIMIA.cantidad/total_uvas_hay) INTO p_hay
			FROM TMP_PRODUCCION_VENDIMIA
			WHERE id_produccion=:NEW.id_produccion AND id_vendimia=vendimia;
			IF ((porcentaje_plantilla>(15/100)*p_hay) AND ((15/100)*porcentaje_plantilla<p_hay)) THEN
					RAISE err;
			END IF;
			FETCH puvas INTO vendimia, cant;
		END LOOP;
		CLOSE puvas;
	EXCEPTION
	WHEN err THEN
		RAISE_APPLICATION_ERROR(-20011,'Los porcentajes de uvas no pueden desviarse más de un 15% de la plantilla');   
END TR_PORCENTAJES_UVAS;


/*****************************/



CREATE OR REPLACE TRIGGER TR_PORCENTAJES_UVAS 
	BEFORE INSERT OR UPDATE ON PRODUCCION_VENDIMIA
	FOR EACH ROW
	DECLARE
	    total_uvas_hay NUMBER(6);
		total_uvas_plantilla NUMBER(6);
		t_uva NUMBER(6);
		t_vino NUMBER(6);
		vendimia NUMBER(6);
		cant NUMBER(6);
		aux NUMBER(6);
		porcentaje_plantilla NUMBER(6);
		p_hay NUMBER(6);
		CURSOR PUVAS(p IN NUMBER) IS SELECT id_vendimia, cantidad FROM PRODUCCION_VENDIMIA WHERE id_produccion=p;
		err EXCEPTION;
	BEGIN
	    total_uvas_hay:=0;
		SELECT id_tipo_vino INTO t_vino
		FROM PRODUCCION
		WHERE id_produccion= :NEW.id_produccion;
		SELECT SUM(cantidad) INTO total_uvas_plantilla
		FROM UVA_VINO
		WHERE id_vino=t_vino;
		OPEN puvas(:NEW.id_produccion);
		FETCH puvas INTO vendimia, cant;
		WHILE(puvas%FOUND) LOOP
			total_uvas_hay:=total_uvas_hay+cant;
			FETCH puvas INTO vendimia, cant;
		END LOOP;
		CLOSE puvas;
		OPEN puvas(:NEW.id_produccion);
		FETCH puvas INTO vendimia, cant;
		WHILE(puvas%FOUND) LOOP
			SELECT count(*) INTO aux
			FROM VENDIMIA_PRIVADA
			WHERE id_vendimia=vendimia;
			IF aux=0 THEN
				SELECT vinedo.id_uva INTO t_uva
				FROM VINEDO JOIN VENDIMIA_PROPIA ON (VINEDO.id_vinedo=VENDIMIA_PROPIA.id_vinedo)
				WHERE id_vendimia=vendimia;
			ELSE 
				SELECT vendimia_privada.id_uva INTO t_uva
				FROM VENDIMIA_PRIVADA
				WHERE id_vendimia=vendimia;
			END IF;
			SELECT (UVA_VINO.cantidad/total_uvas_plantilla) INTO porcentaje_plantilla
			FROM UVA_VINO
			WHERE id_vino=t_vino AND id_uva=t_uva;
			SELECT (PRODUCCION_VENDIMIA.cantidad/total_uvas_hay) INTO p_hay
			FROM PRODUCCION_VENDIMIA
			WHERE id_produccion=:NEW.id_produccion AND id_vendimia=vendimia;
			IF ((porcentaje_plantilla>(15/100)*p_hay) AND ((15/100)*porcentaje_plantilla<p_hay)) THEN
					RAISE err;
			END IF;
			FETCH puvas INTO vendimia, cant;
		END LOOP;
		CLOSE puvas;
	EXCEPTION
	WHEN err THEN
		RAISE_APPLICATION_ERROR(-20011,'Los porcentajes de uvas no pueden desviarse más de un 15% de la plantilla');   
END TR_PORCENTAJES_UVAS;




/
/*
b) Si se intenta sacar vino de las barricas de roble y no ha pasado el tiempo mínimo establecido,
o no se dispone del número suficiente de botellas vacias, no permitirá hacer la operación
correspondiente mostrando un error.
c) Otra restricción que consideres interesante.
*/

CREATE OR REPLACE TRIGGER tr_tiempoBarrica
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
END tr_tiempoBarrica;
