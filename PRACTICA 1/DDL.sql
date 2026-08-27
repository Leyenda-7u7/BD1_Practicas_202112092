-- Generado por Oracle SQL Developer Data Modeler 24.3.1.347.1153
--   en:        2026-08-13 22:17:20 CST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE bitacora (
    id_bitacora      INTEGER NOT NULL,
    correlativo      INTEGER NOT NULL,
    fecha            DATE NOT NULL,
    horas_trabajadas NUMBER(4, 2) NOT NULL,
    actividades      VARCHAR2(500) NOT NULL,
    observaciones    VARCHAR2(500),
    id_colocacion    INTEGER,
    id_contacto      INTEGER
);

ALTER TABLE bitacora ADD CONSTRAINT ck_bit_horas CHECK ( horas_trabajadas > 0 );

ALTER TABLE bitacora ADD CONSTRAINT ck_bit_correlativo CHECK ( correlativo >= 1 );

ALTER TABLE bitacora ADD CONSTRAINT bitacora_pk PRIMARY KEY ( id_bitacora );

CREATE TABLE catedratico (
    id_catedratico  INTEGER NOT NULL,
    nombre          VARCHAR2(100) NOT NULL,
    identificacion  VARCHAR2(25) NOT NULL,
    telefono        VARCHAR2(20) NOT NULL,
    id_instituto    INTEGER NOT NULL,
    id_especialidad INTEGER
);

ALTER TABLE catedratico ADD CONSTRAINT catedratico_pk PRIMARY KEY ( id_catedratico );

ALTER TABLE catedratico ADD CONSTRAINT catedratico_identificacion_un UNIQUE ( identificacion );

CREATE TABLE colocacion (
    id_colocacion      INTEGER NOT NULL,
    fecha_inicio       DATE NOT NULL,
    fecha_finalizacion DATE,
    estado             VARCHAR2(15) NOT NULL,
    id_estudiante      INTEGER,
    id_plaza           INTEGER,
    id_catedratico     INTEGER
);

ALTER TABLE colocacion
    ADD CONSTRAINT ck_col_estado
        CHECK ( estado IN ( 'ACTIVA', 'FINALIZADA', 'CANCELADA' ) );

ALTER TABLE colocacion
    ADD CONSTRAINT ck_col_fechas
        CHECK ( fecha_finalizacion IS NULL
                OR fecha_finalizacion >= fecha_inicio );

ALTER TABLE colocacion ADD CONSTRAINT colocacion_pk PRIMARY KEY ( id_colocacion );

CREATE TABLE contacto_empresarial (
    id_contacto INTEGER NOT NULL,
    nombre      VARCHAR2(100) NOT NULL,
    telefono    VARCHAR2(20) NOT NULL,
    correo      VARCHAR2(100) NOT NULL,
    id_empresa  INTEGER NOT NULL
);

ALTER TABLE contacto_empresarial ADD CONSTRAINT contacto_empresarial_pk PRIMARY KEY ( id_contacto );

CREATE TABLE criterio_evaluacion (
    id_criterio INTEGER NOT NULL,
    nombre      VARCHAR2(200) NOT NULL,
    descripcion VARCHAR2(250)
);

ALTER TABLE criterio_evaluacion ADD CONSTRAINT criterio_evaluacion_pk PRIMARY KEY ( id_criterio );

ALTER TABLE criterio_evaluacion ADD CONSTRAINT criterio_evaluacion_nombre_un UNIQUE ( nombre );

CREATE TABLE departamento (
    id_departamento INTEGER NOT NULL,
    nombre          VARCHAR2(50) NOT NULL
);

ALTER TABLE departamento ADD CONSTRAINT departamento_pk PRIMARY KEY ( id_departamento );

ALTER TABLE departamento ADD CONSTRAINT departamento_nombre_un UNIQUE ( nombre );

CREATE TABLE detalle_evaluacion (
    puntuacion    INTEGER NOT NULL,
    id_evaluacion INTEGER NOT NULL,
    id_criterio   INTEGER NOT NULL
);

ALTER TABLE detalle_evaluacion
    ADD CONSTRAINT ck_det_puntuacion CHECK ( puntuacion BETWEEN 1 AND 5 );

ALTER TABLE detalle_evaluacion ADD CONSTRAINT detalle_evaluacion_pk PRIMARY KEY ( id_criterio,
                                                                                  id_evaluacion );

CREATE TABLE empresa (
    id_empresa       INTEGER NOT NULL,
    nombre           VARCHAR2(100) NOT NULL,
    direccion        VARCHAR2(200) NOT NULL,
    sector_economico VARCHAR2(20) NOT NULL
);

ALTER TABLE empresa
    ADD CONSTRAINT ck_emp_sector1
        CHECK ( sector_economico IN ( 'INDUSTRIA', 'SERVICIOS', 'COMERCIO', 'TECNOLOGIA' ) );

ALTER TABLE empresa ADD CONSTRAINT empresa_pk PRIMARY KEY ( id_empresa );

CREATE TABLE especialidad_tecnica (
    id_especialidad INTEGER NOT NULL,
    nombre          VARCHAR2(100) NOT NULL,
    descripcion     VARCHAR2(250)
);

ALTER TABLE especialidad_tecnica ADD CONSTRAINT especialidad_tecnica_pk PRIMARY KEY ( id_especialidad );

ALTER TABLE especialidad_tecnica ADD CONSTRAINT especialidad_tecnica_nombre_un UNIQUE ( nombre );

CREATE TABLE estudiante (
    id_estudiante    INTEGER NOT NULL,
    carne            VARCHAR2(20) NOT NULL,
    nombre_completo  VARCHAR2(150) NOT NULL,
    direccion        VARCHAR2(200) NOT NULL,
    telefono         VARCHAR2(20) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero           VARCHAR2(20) NOT NULL,
    tipo_practica    VARCHAR2(15) NOT NULL,
    id_municipio     INTEGER,
    id_instituto     INTEGER,
    id_especialidad  INTEGER
);

ALTER TABLE estudiante
    ADD CONSTRAINT ck_est_tipo_pract CHECK ( tipo_practica IN ( 'PRIMERA', 'REPITENCIA' ) );

ALTER TABLE estudiante ADD CONSTRAINT estudiante_pk PRIMARY KEY ( id_estudiante );

ALTER TABLE estudiante ADD CONSTRAINT estudiante_carne_un UNIQUE ( carne );

CREATE TABLE evaluacion (
    id_evaluacion    INTEGER NOT NULL,
    tipo_evaluacion  VARCHAR2(10) NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    id_colocacion    INTEGER
);

ALTER TABLE evaluacion
    ADD CONSTRAINT ck_eva_tipo CHECK ( tipo_evaluacion IN ( 'PARCIAL', 'FINAL' ) );

ALTER TABLE evaluacion ADD CONSTRAINT evaluacion_pk PRIMARY KEY ( id_evaluacion );

ALTER TABLE evaluacion ADD CONSTRAINT uq_eva_col_tipo UNIQUE ( tipo_evaluacion,
                                                               id_colocacion );

CREATE TABLE instituto (
    id_instituto        INTEGER NOT NULL,
    nombre              VARCHAR2(100) NOT NULL,
    direccion           VARCHAR2(200) NOT NULL,
    codigo_autorizacion VARCHAR2(50) NOT NULL
);

ALTER TABLE instituto ADD CONSTRAINT instituto_pk PRIMARY KEY ( id_instituto );

ALTER TABLE instituto ADD CONSTRAINT uq_ins_codigo UNIQUE ( codigo_autorizacion );

CREATE TABLE municipio (
    id_municipio    INTEGER NOT NULL,
    nombre          VARCHAR2(50) NOT NULL,
    id_departamento INTEGER NOT NULL
);

ALTER TABLE municipio ADD CONSTRAINT municipio_pk PRIMARY KEY ( id_municipio );

CREATE TABLE plaza (
    id_plaza        INTEGER NOT NULL,
    id_especialidad INTEGER,
    id_contacto     INTEGER
);

ALTER TABLE plaza ADD CONSTRAINT plaza_pk PRIMARY KEY ( id_plaza );

ALTER TABLE bitacora
    ADD CONSTRAINT bitacora_colocacion_fk FOREIGN KEY ( id_colocacion )
        REFERENCES colocacion ( id_colocacion );

ALTER TABLE catedratico
    ADD CONSTRAINT catedratico_instituto_fk FOREIGN KEY ( id_instituto )
        REFERENCES instituto ( id_instituto );

ALTER TABLE colocacion
    ADD CONSTRAINT colocacion_catedratico_fk FOREIGN KEY ( id_catedratico )
        REFERENCES catedratico ( id_catedratico );

ALTER TABLE colocacion
    ADD CONSTRAINT colocacion_estudiante_fk FOREIGN KEY ( id_estudiante )
        REFERENCES estudiante ( id_estudiante );

ALTER TABLE colocacion
    ADD CONSTRAINT colocacion_plaza_fk FOREIGN KEY ( id_plaza )
        REFERENCES plaza ( id_plaza );

ALTER TABLE estudiante
    ADD CONSTRAINT estudiante_instituto_fk FOREIGN KEY ( id_instituto )
        REFERENCES instituto ( id_instituto );

ALTER TABLE estudiante
    ADD CONSTRAINT estudiante_municipio_fk FOREIGN KEY ( id_municipio )
        REFERENCES municipio ( id_municipio );

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_colocacion_fk FOREIGN KEY ( id_colocacion )
        REFERENCES colocacion ( id_colocacion );

ALTER TABLE bitacora
    ADD CONSTRAINT fk_bit_con FOREIGN KEY ( id_contacto )
        REFERENCES contacto_empresarial ( id_contacto );

ALTER TABLE catedratico
    ADD CONSTRAINT fk_cat_esp FOREIGN KEY ( id_especialidad )
        REFERENCES especialidad_tecnica ( id_especialidad );

ALTER TABLE contacto_empresarial
    ADD CONSTRAINT fk_con_emp FOREIGN KEY ( id_empresa )
        REFERENCES empresa ( id_empresa );

ALTER TABLE detalle_evaluacion
    ADD CONSTRAINT fk_det_cri FOREIGN KEY ( id_criterio )
        REFERENCES criterio_evaluacion ( id_criterio );

ALTER TABLE detalle_evaluacion
    ADD CONSTRAINT fk_det_eva FOREIGN KEY ( id_evaluacion )
        REFERENCES evaluacion ( id_evaluacion );

ALTER TABLE estudiante
    ADD CONSTRAINT fk_est_esp FOREIGN KEY ( id_especialidad )
        REFERENCES especialidad_tecnica ( id_especialidad );

ALTER TABLE municipio
    ADD CONSTRAINT municipio_departamento_fk FOREIGN KEY ( id_departamento )
        REFERENCES departamento ( id_departamento );

ALTER TABLE plaza
    ADD CONSTRAINT plaza_contacto_empresarial_fk FOREIGN KEY ( id_contacto )
        REFERENCES contacto_empresarial ( id_contacto );

ALTER TABLE plaza
    ADD CONSTRAINT plaza_especialidad_tecnica_fk FOREIGN KEY ( id_especialidad )
        REFERENCES especialidad_tecnica ( id_especialidad );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             0
-- ALTER TABLE                             46
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
