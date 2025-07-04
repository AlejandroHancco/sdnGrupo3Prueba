DROP DATABASE IF EXISTS sdnG03_db;
CREATE DATABASE IF NOT EXISTS sdnG03_db;
USE sdnG03_db;

-- Tabla de roles
CREATE TABLE role (
    idrole INT PRIMARY KEY AUTO_INCREMENT,
    rolname VARCHAR(50) NOT NULL
);

-- Tabla de usuarios
CREATE TABLE user (
    iduser INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    names VARCHAR(100) NOT NULL,
    lastnames VARCHAR(100) NOT NULL,
    code VARCHAR(20),
    rol INT,
    session VARCHAR(10),
    time_stamp DATETIME,
    ip VARCHAR(15),
    sw_id VARCHAR(50),
    sw_port INT,
    mac VARCHAR(17),
    numrules INT,
    FOREIGN KEY (rol) REFERENCES role(idrole)
);

-- Tabla de reglas
CREATE TABLE rule (
    idrule INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    svr_ip VARCHAR(15),
    svr_port INT,
    svr_mac VARCHAR(17),
    action VARCHAR(20)
);

-- Tabla de relación rol-regla
CREATE TABLE role_has_rule (
    role_idrole INT,
    rule_idrule INT,
    PRIMARY KEY (role_idrole, rule_idrule),
    FOREIGN KEY (role_idrole) REFERENCES role(idrole),
    FOREIGN KEY (rule_idrule) REFERENCES rule(idrule)
);

-- Tabla cursos con estado y código
CREATE TABLE curso (
    idcurso INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo'
);

-- Tabla inscripcion con distinción de rol
CREATE TABLE inscripcion (
    user_iduser INT,
    curso_idcurso INT,
    rol_id INT,  -- 2 = alumno, 3 = profesor
    fecha_inscripcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_iduser, curso_idcurso, rol_id),
    FOREIGN KEY (user_iduser) REFERENCES user(iduser),
    FOREIGN KEY (curso_idcurso) REFERENCES curso(idcurso),
    FOREIGN KEY (rol_id) REFERENCES role(idrole)
);

-- Insertar roles
INSERT INTO role (rolname) VALUES 
('Administrador'),
('Alumno'),
('Profesor'),
('Invitado');

-- Insertar usuarios con roles
INSERT INTO user (username, password, names, lastnames, code, rol, session, time_stamp, ip, sw_id, sw_port, mac, numrules) VALUES
('admin1', 'admin123', 'Admin', 'User', 'ADMIN001', 1, 'active', NOW(), '10.0.0.1', '00:00:f2:20:f9:45:4c:4e', 3, 'fa:16:3e:0a:37:49', 0),
('profesor1', 'profesor1', 'Profesor', 'Apellido1', 'P001', 3, 'active', NOW(), '10.0.0.1', '00:00:f2:20:f9:45:4c:4e', 3, 'fa:16:3e:0a:37:49', 0),
('invitado1', 'invitado1', 'Profesor', 'Apellido1', 'P001', 4, 'active', NOW(), '10.0.0.1', '00:00:f2:20:f9:45:4c:4e', 3, 'fa:16:3e:0a:37:49', 0),
('alumno1', 'passalumno', 'Alumno', 'Ejemplo', 'A001', 2, 'active', NOW(), '10.0.0.5', '00:00:11:22:33:44:55:66', 2, 'de:ad:be:ef:00:01', 0);

-- Insertar reglas
INSERT INTO rule (name, description, svr_ip, svr_port, svr_mac, action) VALUES
('Regla Admin', 'Acceso completo para admin', '192.168.201.200', 8080, 'f2:20:f9:45:4c:4e', 'allow'),
('Regla User', 'Acceso limitado para usuario', '192.168.201.201', 8081, 'fa:16:3e:0a:37:49', 'allow'),
('Regla Invitado', 'Acceso restringido para invitado', '192.168.201.202', 8082, 'de:ad:be:ef:00:01', 'deny'),
('Regla Alumno', 'Acceso para alumnos a cursos', '192.168.201.203', 8083, 'de:ad:be:ef:00:02', 'allow');

-- Asociar reglas con roles
INSERT INTO role_has_rule (role_idrole, rule_idrule) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Insertar cursos (con código)
INSERT INTO curso (codigo, nombre, estado) VALUES
('CURS001', 'Curso Python Básico', 'activo'),
('CURS002', 'Curso Redes', 'activo'),
('CURS003', 'Curso Seguridad', 'inactivo');

-- Inscribir usuario como alumno y profesor
INSERT INTO inscripcion (user_iduser, curso_idcurso, rol_id) VALUES
((SELECT iduser FROM user WHERE username = 'alumno1'),
 (SELECT idcurso FROM curso WHERE nombre = 'Curso Python Básico'),
 2),

((SELECT iduser FROM user WHERE username = 'profesor1'),
 (SELECT idcurso FROM curso WHERE nombre = 'Curso Python Básico'),
 3),

((SELECT iduser FROM user WHERE username = 'alumno1'),
 (SELECT idcurso FROM curso WHERE nombre = 'Curso Redes'),
 2);
