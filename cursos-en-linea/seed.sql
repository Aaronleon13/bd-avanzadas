CREATE DATABASE IF NOT EXISTS cursos_enlinea;

USE cursos_enlinea;

CREATE TABLE IF NOT EXISTS cursos (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS estudiantes (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
	curso_id INT,
	FOREIGN KEY (curso_id) REFERENCES cursos (id)
);



INSERT INTO cursos (nombre) VALUES ('React'); -- 1
INSERT INTO cursos (nombre) VALUES ('Android'); -- 2
INSERT INTO cursos (nombre) VALUES ('Scrum'); -- 3
INSERT INTO cursos (nombre) VALUES ('iOS');  -- 4
INSERT INTO cursos (nombre) VALUES ('Java');  -- 5
INSERT INTO cursos (nombre) VALUES ('Arduino'); -- 6


INSERT INTO estudiantes (nombre, curso_id) VALUES ('Erick', 2);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Erick', 6);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Roberto', 1);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Roberto', 3);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Luis', 3);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Ernesto', 1);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Ernesto', 2);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Ernesto', 3);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Ernesto', 4);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Ernesto', 5);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Ernesto', 6);
INSERT INTO estudiantes (nombre, curso_id) VALUES ('Carolina', null);

-- INNER JOIN
SELECT estudiantes.nombre, cursos.nombre
FROM estudiantes
INNER JOIN cursos ON estudiantes.curso_id = cursos.id;


-- LEFT JOIN
SELECT estudiantes.nombre, cursos.nombre
FROM estudiantes
LEFT JOIN cursos ON estudiantes.curso_id = cursos.id;

-- RIGHT JOIN
SELECT estudiantes.nombre, cursos.nombre
FROM estudiantes
RIGHT JOIN cursos ON estudiantes.curso_id = cursos.id;

-- FULL JOIN
SELECT estudiantes.nombre, cursos.nombre
FROM estudiantes
LEFT JOIN cursos ON estudiantes.curso_id = cursos.id
UNION
SELECT estudiantes.nombre, cursos.nombre
FROM estudiantes
RIGHT JOIN cursos ON estudiantes.curso_id = cursos.id;
