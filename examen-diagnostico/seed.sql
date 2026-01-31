Alumnos: id, nombre, apellido, edad, genero, telefono, correo, direccion.
    Materias: id, nombre, codigo, creditos, profesor.
    Inscripciones: id, id_alumno, id_materia, fecha, estado.


CREATE TABLE Alumnos (
    id_alumno INT PRIMARY KEY,
    nombre TEXT,
    apellido TEXT,
    edad INT,
    genero varchar(40),
    telefono varchar(16),
    correo varchar(100),
    direccion text,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)

CREATE TABLE Materias (
    id_materia INT PRIMARY KEY,
    nombre TEXT,
    codigo varchar(10),
    creditos INT,
    profesor TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)

CREATE TABLE Inscripciones (
    id_inscripcion INT PRIMARY KEY,
    id_alumno INT,
    id_materia INT,
    fecha TIMESTAMP,
    estado varchar(40),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
    FOREIGN KEY (id_materia) REFERENCES Materias(id_materia),
    UNIQUE (id_alumno, id_materia)
)


customers(id, name)
orders(id, customer_id, total)

--Insertar un cliente
INSERT INTO customer(name) VALUES ('pedro');

--Inserta una orden asociada a un cliente.
INSERT INTO orders (customer_id, total) VALUES (1,1000);

--Consulta todas las órdenes con total mayor a 10000.
SELECT id FROM orders WHERE total > 10000;

--Consulta el total de ventas por cliente.
SELECT customer_id, SUM(total) AS total_ventas FROM orders;

