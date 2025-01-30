CREATE TABLE LUGAR (
    Lug_codigo SERIAL PRIMARY KEY,
    Lug_nombre VARCHAR(50) NOT NULL,
    Lug_tipo VARCHAR(50) NOT NULL,
    Fk_lugar INTEGER,
    FOREIGN KEY (Fk_lugar) REFERENCES LUGAR(Lug_codigo) ON DELETE CASCADE,
    CONSTRAINT check_tipo CHECK (Lug_tipo IN ('Pais', 'Estado', 'Municipio', 'Parroquia'))
);

CREATE TABLE PERSONA_NATURAL(
    Per_codigo SERIAL PRIMARY KEY,
    Per_nombre VARCHAR(50) NOT NULL,
    Per_direccion TEXT NOT NULL,
    Per_fecha_registro DATE NOT NULL,
    Per_identificacion VARCHAR(50) UNIQUE NOT NULL,
    Pen_segundo_nombre VARCHAR(50),
    Pen_primer_apellido VARCHAR(50) NOT NULL,
    Pen_segundo_apellido VARCHAR(50),
    Pen_fecha_nac DATE NOT NULL,
    Fk_lugar INTEGER NOT NULL,
    FOREIGN KEY(Fk_lugar) REFERENCES LUGAR(Lug_codigo) ON DELETE CASCADE
);

CREATE TABLE PERSONA_JURIDICA(
    Per_codigo SERIAL PRIMARY KEY,
    Per_nombre VARCHAR(50) NOT NULL,
    Per_direccion TEXT NOT NULL,
    Per_fecha_registro DATE NOT NULL,
    Per_identificacion VARCHAR(50) UNIQUE NOT NULL,
    Pej_pagina_web VARCHAR(60) NOT NULL,
    Fk_lugar INTEGER NOT NULL,
    FOREIGN KEY(Fk_lugar) REFERENCES LUGAR(Lug_codigo) ON DELETE CASCADE
);

CREATE TABLE PROVEEDOR (
  pro_proveedor_id SERIAL PRIMARY KEY,
  pro_nombre VARCHAR(100) NOT NULL,
  pro_direccion TEXT NOT NULL
);

CREATE TABLE CORREO_ELECTRONICO(
    Cor_codigo SERIAL PRIMARY KEY,
    Cor_direccion VARCHAR(60) NOT NULL,
    Fk_persona_natural INTEGER,
    Fk_persona_juridica INTEGER,
    FOREIGN KEY(Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo) ON DELETE CASCADE,
    FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo) ON DELETE CASCADE,
    CONSTRAINT check_direccion CHECK (Cor_direccion LIKE '%@%.%')
);

CREATE TABLE TELEFONO(
    Tel_codigo SERIAL PRIMARY KEY,
    Tel_codigo_pais INTEGER NOT NULL,
    Tel_numero BIGINT NOT NULL,
    Fk_persona_natural INTEGER,
    Fk_persona_juridica INTEGER,
    FOREIGN KEY(Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo) ON DELETE CASCADE,
    FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo) ON DELETE CASCADE
);

CREATE TABLE EMPLEADO ( 
    Emp_codigo SERIAL PRIMARY KEY,
    Emp_exp_profesional INTEGER NOT NULL,
    Emp_titulacion VARCHAR(60) NOT NULL,
    Fk_persona_natural INTEGER UNIQUE NOT NULL,
    FOREIGN KEY (Fk_persona_natural) REFERENCES PERSONA_NATURAL (Per_codigo) ON DELETE CASCADE,
    CONSTRAINT check_experiencia CHECK (Emp_exp_profesional >= 0)
);

CREATE TABLE ESTATUS(
    Est_codigo SERIAL PRIMARY KEY,
    Est_nombre_estado VARCHAR(100) NOT NULL
);

CREATE TABLE LABORATORIO(
    lab_codigo SERIAL PRIMARY KEY,
    lab_nombre VARCHAR(100) NOT NULL,
    lab_descripcion VARCHAR(200),
    Fk_estatus INTEGER,
    bool_delete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE
);

CREATE TABLE EMPLEADO_LABORATORIO (
    Empl_codigo SERIAL PRIMARY KEY,
    Empl_fecha_inicio DATE NOT NULL,
    Empl_fecha_final DATE,
    Fk_empleado INTEGER NOT NULL,
    Fk_laboratorio INTEGER NOT NULL,
    FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo) ON DELETE CASCADE,
    FOREIGN KEY (Fk_laboratorio) REFERENCES LABORATORIO(lab_codigo) ON DELETE CASCADE
);

CREATE TABLE PRIVILEGIO (
    Pri_codigo SERIAL PRIMARY KEY,
    Pri_nombre VARCHAR(100) NOT NULL,
    Pri_descripcion VARCHAR(200),
    Pri_es_menu BOOLEAN NOT NULL
);

CREATE TABLE ROL(
    Rol_codigo SERIAL PRIMARY KEY,
    Rol_nombre VARCHAR(100) NOT NULL,
    Rol_descripcion VARCHAR(200),
    CONSTRAINT uq_rol_nombre UNIQUE (Rol_nombre)
);

CREATE TABLE ROL_PRIVILEGIO(
    Rop_codigo SERIAL PRIMARY KEY,
    Fk_rol INTEGER NOT NULL,
    Fk_privilegio INTEGER NOT NULL,
    FOREIGN KEY (Fk_rol) REFERENCES ROL(Rol_codigo) ON DELETE CASCADE,
    FOREIGN KEY (Fk_privilegio) REFERENCES PRIVILEGIO(Pri_codigo) ON DELETE CASCADE,
    CONSTRAINT unique_rol_privilegio UNIQUE (Fk_rol, Fk_privilegio)
);

CREATE TABLE USUARIO(
    Usu_codigo SERIAL PRIMARY KEY,
    Usu_nombre VARCHAR(100) UNIQUE NOT NULL,
    Usu_contrasena VARCHAR(100) NOT NULL,
    Usu_estatus BOOLEAN NOT NULL,
    Fk_empleado INTEGER UNIQUE,
    Fk_estatus INTEGER,
    bool_delete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(emp_codigo) ON DELETE CASCADE,
    FOREIGN KEY (Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE
);

CREATE TABLE USUARIO_ROL(
    Usr_codigo SERIAL PRIMARY KEY,
    Fk_usuario INTEGER NOT NULL,
    Fk_rol INTEGER NOT NULL,
    FOREIGN KEY (Fk_usuario) REFERENCES USUARIO(Usu_codigo) ON DELETE CASCADE,
    FOREIGN KEY (Fk_rol) REFERENCES ROL(Rol_codigo) ON DELETE CASCADE,
    CONSTRAINT unique_rol_usuario UNIQUE (Fk_rol, Fk_usuario)
);

CREATE TABLE CARGO(
    Car_codigo SERIAL PRIMARY KEY,
    Car_nombre VARCHAR(50) NOT NULL,
    Car_descripcion VARCHAR(250)
);

CREATE TABLE EMPLEADO_CARGO(
    Emc_codigo SERIAL PRIMARY KEY,
    Emc_fecha_inicio_cargo DATE NOT NULL,
    Emc_fecha_final_cargo DATE,
    Fk_empleado INTEGER NOT NULL,
    Fk_cargo INTEGER NOT NULL,
    FOREIGN KEY (Fk_cargo) REFERENCES CARGO(Car_codigo) ON DELETE CASCADE,
    FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo) ON DELETE CASCADE
);

CREATE TABLE EQUIPO (
    Equ_modelo VARCHAR(50) PRIMARY KEY,
    Equ_numero_serial VARCHAR(50) NOT NULL,
    Equ_numero_activo VARCHAR(50) NOT NULL,
    Equ_presentacion VARCHAR(100) NOT NULL,
    Equ_voltaje VARCHAR(20) NOT NULL,
    Equ_procesable BOOLEAN NOT NULL,
    Equ_material_requerido VARCHAR(100) NOT NULL,
    Equ_año_de_compra INTEGER NOT NULL,
    Equ_aplicacion TEXT NOT NULL,
    Equ_ultimo_mantenimiento DATE NOT NULL,
    Equ_ultima_calibracion DATE NOT NULL,
    Equ_proxima_calibracion DATE NOT NULL,
    Equ_proveedor_de_servicio VARCHAR(100) NOT NULL,
    Equ_encendido_de_noche BOOLEAN NOT NULL,
    Pro_nombre VARCHAR(100) NOT NULL,
    Pro_descripcion TEXT,
    Pro_observaciones TEXT,
    Pro_minimo_de_existencias INTEGER NOT NULL,
    Pro_marca VARCHAR(50) NOT NULL,
    Pro_stock INTEGER NOT NULL,
    lab_codigo INTEGER,
    Fk_estatus INTEGER,
    bool_delete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (lab_codigo) REFERENCES LABORATORIO(lab_codigo) ON DELETE CASCADE,
    FOREIGN KEY (Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE
);

CREATE TABLE SUSTANCIA_QUIMICA (
    Suq_formula_quimica VARCHAR(100) PRIMARY KEY,
    Suq_concentracion VARCHAR(50) NOT NULL,
    Suq_presentacion VARCHAR(100) NOT NULL,
    Suq_nombre_comercial VARCHAR(100) NOT NULL,
    Suq_tiene_msd BOOLEAN NOT NULL,
    Suq_grupo_de_riesgo VARCHAR(50) NOT NULL,
    Suq_frase_r VARCHAR(100) NOT NULL,
    Suq_metodo_de_control TEXT NOT NULL,
    Suq_permiso BOOLEAN NOT NULL,
    Suq_unidad VARCHAR(50) NOT NULL,
    Suq_precio_estimado DECIMAL(10, 2) NOT NULL,
    Suq_proveedor VARCHAR(100) NOT NULL,
    Suq_almacenado_envasado BOOLEAN NOT NULL,
    Pro_nombre VARCHAR(100) NOT NULL,
    Pro_descripcion TEXT,
    Pro_observaciones TEXT,
    Pro_minimo_de_existencias INTEGER NOT NULL,
    Pro_marca VARCHAR(50) NOT NULL,
    Pro_stock INTEGER NOT NULL,
    lab_codigo INTEGER,
    Fk_estatus INTEGER,
    bool_delete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (lab_codigo) REFERENCES LABORATORIO(lab_codigo) ON DELETE CASCADE,
    FOREIGN KEY (Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE,
    Proveedor_id INTEGER,
    FOREIGN KEY (Proveedor_id) REFERENCES PROVEEDOR(pro_proveedor_id) ON DELETE CASCADE
);

CREATE TABLE INSUMO (
    Ins_modelo VARCHAR(50) PRIMARY KEY,
    Ins_presentacion VARCHAR(100) NOT NULL,
    Ins_clasificacion VARCHAR(100) NOT NULL,
    Ins_categoria VARCHAR(100) NOT NULL,
    Ins_ultima_compra DATE NOT NULL,
    Ins_precio_estimado DECIMAL(10, 2) NOT NULL,
    Ins_unidad VARCHAR(50) NOT NULL,
    Pro_nombre VARCHAR(100) NOT NULL,
    Pro_descripcion TEXT,
    Pro_observaciones TEXT,
    Pro_minimo_de_existencias INTEGER NOT NULL,
    Pro_marca VARCHAR(50) NOT NULL,
    Pro_stock INTEGER NOT NULL,
    lab_codigo INTEGER,
    Fk_estatus INTEGER,
    bool_delete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (lab_codigo) REFERENCES LABORATORIO(lab_codigo) ON DELETE CASCADE,
    FOREIGN KEY (Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE,
    Proveedor_id INTEGER,
    FOREIGN KEY (Proveedor_id) REFERENCES PROVEEDOR(pro_proveedor_id) ON DELETE CASCADE
);

CREATE TABLE MOVIMIENTOS_INVENTARIO (
    Mov_codigo SERIAL PRIMARY KEY,
    Mov_fecha DATE NOT NULL,
    Mov_tipo VARCHAR(50) NOT NULL,
    Mov_cantidad INTEGER NOT NULL,
    Mov_motivo TEXT NOT NULL,
    Equ_modelo VARCHAR(50),
    Suq_formula_quimica VARCHAR(100),
    Ins_modelo VARCHAR(50),
    Emp_codigo INTEGER,
    FOREIGN KEY (Equ_modelo) REFERENCES EQUIPO(Equ_modelo) ON DELETE CASCADE,
    FOREIGN KEY (Suq_formula_quimica) REFERENCES SUSTANCIA_QUIMICA(Suq_formula_quimica) ON DELETE CASCADE,
    FOREIGN KEY (Ins_modelo) REFERENCES INSUMO(Ins_modelo) ON DELETE CASCADE,
    FOREIGN KEY (Emp_codigo) REFERENCES EMPLEADO(Emp_codigo) ON DELETE CASCADE,
    Proveedor_id INTEGER,
    FOREIGN KEY (Proveedor_id) REFERENCES PROVEEDOR(pro_proveedor_id) ON DELETE CASCADE
);

CREATE TABLE MANTENIMIENTOS (
    Mant_id SERIAL PRIMARY KEY,
    Equ_modelo VARCHAR(50) NOT NULL,
    Proveedor_id INTEGER NOT NULL,
    Mant_fecha DATE NOT NULL,
    Mant_detalle TEXT NOT NULL,
    FOREIGN KEY (Equ_modelo) REFERENCES EQUIPO(Equ_modelo) ON DELETE CASCADE,
    FOREIGN KEY (Proveedor_id) REFERENCES PROVEEDOR(pro_proveedor_id) ON DELETE CASCADE
);