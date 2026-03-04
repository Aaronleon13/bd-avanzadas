-- Crear base de datos.
CREATE DATABASE IF NOT EXISTS trabajo;

-- Seleccionar base de datos.
USE trabajo;

-- Crear tabla.
CREATE TABLE empleados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  departamento VARCHAR(50)
);

-- Insertar 100,000 registros.
DELIMITER $$

CREATE PROCEDURE insertar_empleados()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100000 DO
    INSERT INTO empleados (nombre, departamento)
    VALUES (
      CONCAT('Empleado', i),
      IF(i % 2 = 0, 'Ventas', 'Sistemas')
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

CALL insertar_empleados();

-- Fin de la inserción de datos.

-- Consulta sin índice usando EXPLAIN.
EXPLAIN SELECT * FROM empleados WHERE departamento = 'Ventas';

-- Crear índice
CREATE INDEX idx_departamento ON empleados(departamento);

-- Consulta con índice usando EXPLAIN.
EXPLAIN SELECT * FROM empleados WHERE departamento = 'Ventas';

-- Eliminar índice.
DROP INDEX idx_departamento ON empleados;