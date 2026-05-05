-- Registrar clientes
-- Registrar productos por categoría
-- Generar órdenes de compra
-- Registrar los productos de cada orden
-- Registrar pagos
-- Consultar ventas y totales


-- TABLAS
-- 1. Usuarios
-- 2. Clientes
-- 3. Categorias
-- 4. Productos
-- 5. Ordenes
-- 6. Orden_Productos
-- 7. Pagos

CREATE DATABASE IF NOT EXISTS db_sistema_ventas;

USE db_sistema_ventas;

CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(300) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    rol ENUM('admin', 'vendedor') DEFAULT 'vendedor',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(50) NULL,
    telefono VARCHAR(20) NOT NULL UNIQUE,
    direccion VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(100) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(100) NULL,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    precio_oferta DECIMAL(10, 2) NULL CHECK (precio_oferta > 0),
    stock INT NOT NULL CHECK (stock >= 0),
    categoria_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ordenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    usuario_id INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL CHECK (total > 0), -- Modificar a >= para que pueda ser 0
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Cambiar el CHECK de total para que pueda ser 0
ALTER TABLE ordenes
MODIFY COLUMN total DECIMAL(10, 2) NOT NULL CHECK (total >= 0);

CREATE TABLE IF NOT EXISTS orden_productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    orden_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (orden_id, producto_id),
    FOREIGN KEY (orden_id) REFERENCES ordenes(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    orden_id INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL CHECK (monto > 0),
    metodo_pago ENUM('efectivo', 'tarjeta') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (orden_id) REFERENCES ordenes(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



INSERT INTO usuarios (nombre, email, password_hash, is_active, rol) VALUES 
('Alexis', 'alexis@gmail.com', 'alexis', TRUE, 'admin'),
('Luis Miguel', 'luis@gmail.com', 'luis', TRUE, 'vendedor');

INSERT INTO clientes (nombre, email, telefono, direccion) VALUES 
('Pablo Emilio Escobar Gaviria', 'cocacola@gmail.com', '12345678', 'Calle 123'),
('Andres Manuel Lopez Obrador', 'andres@gmail.com', '87654321', 'Calle 456');


INSERT INTO categorias (nombre, descripcion) VALUES 
('Carnes frias', 'Productos ultra procesados de procedencia animal especificamente aves, cerdos y ganados'),
('Pescados', 'Productos de procedencia animal marina'),
('Verduras', 'Productos de procedencia terrestre sin semillas'),
('Frutas', 'Productos de procedencia terrestre con semillas'),
('Lacteos', 'Productos pertenecientes o relativos a la leche.'),
('Bebidas', 'Productos con alcohol'),
('Snacks', 'Productos de consumo rapido');


INSERT INTO productos (nombre, descripcion, precio, precio_oferta, stock, categoria_id) VALUES
('Cheetos', 'Snack de maiz', 20, 10, 100, 7),
('Tomate', 'Fruta carnosa', 15, 10, 100, 4),
('Beef Steak', 'Carne de res', 200, 180, 10, 1),
('Chocomilk', 'Bebida de chocolate', 25, 20, 100, 6),
('Leche', 'Bebida de vaca', 20, 15, 100, 5),
('Pechuga de pollo', 'Pechuga de pollo', 100, 90, 10, 1),
('Salchicha', 'Salchicha de cerdo', 50, 40, 100, 1),
('Pescado', 'Pescado blanco', 150, 130, 10, 2),
('Jamon', 'Jamón de cerdo', 50, 40, 100, 1),
('Queso', 'Queso blanco', 50, 40, 100, 5);


START TRANSACTION;

INSERT INTO categorias (nombre, descripcion) VALUES
('Juguetes', 'Juguetes para niños o adultos');

SET @categoria_id = LAST_INSERT_ID();

INSERT INTO productos (nombre, descripcion, precio, precio_oferta, stock, categoria_id)
VALUES ('Pelota', 'Pelota de futbol', 20, 10, 100, @categoria_id);

SELECT * FROM productos;

COMMIT;
ROLLBACK;



SELECT
    p.nombre,
    op.cantidad,
    op.precio,
    op.cantidad * op.precio AS subtotal
FROM orden_productos op
JOIN productos p ON op.producto_id = p.id
WHERE op.orden_id = @orden_id;


SELECT SUM(cantidad * precio) AS total FROM orden_productos
WHERE orden_id = @orden_id;


-- Actividad GROUP BY Y HAVING


SELECT 
    p.nombre,
    SUM(op.cantidad) AS total_vendidos
FROM productos p
JOIN orden_productos op ON p.id = op.producto_id
GROUP BY p.id, p.nombre
HAVING total_vendidos > 10;


SELECT 
    p.nombre,
    SUM(op.cantidad) AS total_vendidos
FROM productos p
JOIN orden_productos op ON p.id = op.producto_id
GROUP BY p.id, p.nombre
HAVING total_vendidos > 10;


SELECT 
    DATE(o.created_at) AS fecha,
    SUM(op.cantidad * op.precio) AS total
FROM ordenes o
JOIN orden_productos op ON o.id = op.orden_id
GROUP BY fecha
HAVING total > 1000;


SELECT 
    o.id,
    COUNT(op.producto_id) AS total_productos
FROM ordenes o
JOIN orden_productos op ON o.id = op.orden_id
GROUP BY o.id
HAVING total_productos > 3;


--CREAR VISTA
CREATE VIEW vista_productos AS
SELECT id, nombre, precio, stock FROM productos WHERE stock > 0;


--USAR
SELECT * FROM vista_productos WHERE id = 1;

SELECT id, nombre, precio, stock FROM productos WHERE stock > 0 AND id = 1;


CREATE VIEW vista_ordenes_clientes AS
SELECT id, total, is_active FROM ordenes o
JOIN clientes c ON o.cliente_id = c.id;

SELECT * FROM vista_ordenes_clientes WHERE cliente_id = 1;

---------------------------------------------------------------

-- STORED PROCEDURE

DELIMITER $$

CREATE PROCEDURE crear_venta(
    IN p_cliente_id INT,
    IN p_usuario_id INT,
    IN p_total DECIMAL(10,2)
)
BEGIN
    DECLARE v_orden_id INT;

    -- manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO ordenes (cliente_id, usuario_id, total)
    VALUES (p_cliente_id, p_usuario_id, p_total);

    SET v_orden_id = LAST_INSERT_ID();

    INSERT INTO orden_productos (orden_id, producto_id, cantidad, precio)
    VALUES
    (v_orden_id, 2, 1, 300),
    (v_orden_id, 5, 2, 20),
    (v_orden_id, 7, 1, 50);

    -- triggers:
    -- Descontar Stock
    -- Validar Stock negativo

    INSERT INTO pagos (orden_id, monto, metodo_pago)
    VALUES (v_orden_id, p_total, 'tarjeta');

    COMMIT;
END$$

DELIMITER ;


------------------------- STORED PROCEDURE CORRECTO

DELIMITER $$

CREATE PROCEDURE crear_venta(
    IN p_cliente_id INT,
    IN p_usuario_id INT,
    IN p_total DECIMAL(10,2),
    IN p_productos JSON
)
BEGIN
    DECLARE v_orden_id INT;
    DECLARE v_total_real DECIMAL(10,2);

    -- manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO ordenes (cliente_id, usuario_id, total)
    VALUES (p_cliente_id, p_usuario_id, p_total);

    SET v_orden_id = LAST_INSERT_ID();

    INSERT INTO orden_productos (orden_id, producto_id, cantidad, precio)
    VALUES
    (v_orden_id, 2, 1, 300),
    (v_orden_id, 5, 2, 20),
    (v_orden_id, 7, 1, 50);

    -- triggers:

    SELECT SUM(cantidad * precio)
    INTO v_total_real
    FROM orden_productos
    WHERE orden_id = v_orden_id;

    IF v_total_real != p_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total incorrecto';
    END IF;

    INSERT INTO pagos (orden_id, monto, metodo_pago)
    VALUES (v_orden_id, p_total, 'tarjeta');

    COMMIT;
END$$

DELIMITER ;

CALL crear_venta(1, 1, 390, '[{"producto_id": 2, "cantidad": 1, "precio": 300}, {"producto_id": 5, "cantidad": 2, "precio": 20}, {"producto_id": 7, "cantidad": 1, "precio": 50}]');




try{
    START TRANSACTION;

    INSERT INTO ordenes (cliente_id, usuario_id, total)
    VALUES (p_cliente_id, p_usuario_id, p_total);

    SET v_orden_id = LAST_INSERT_ID();

    -- Itera sobre el array de productos
    
    INSERT INTO orden_productos (orden_id, producto_id, cantidad, precio)
    VALUES
    (v_orden_id, 2, 1, 300),
    (v_orden_id, 5, 2, 20),
    (v_orden_id, 7, 1, 50);

    -- triggers:
    -- Descontar Stock
    -- Validar Stock negativo

    INSERT INTO pagos (orden_id, monto, metodo_pago)
    VALUES (v_orden_id, p_total, 'tarjeta');

    COMMIT;
}
catch{
    ROLLBACK;
}