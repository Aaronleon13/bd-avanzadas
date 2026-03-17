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
('Cheetos', 'Snack de maiz', 20, 0, 100, 7),
('Tomate', 'Fruta carnosa', 15, 0, 100, 4),
('Beef Steak', 'Carne de res', 200, 180, 10, 1),
('Chocomilk', 'Bebida de chocolate', 25, 20, 100, 6),
('Leche', 'Bebida de vaca', 20, 15, 100, 5),
('Pechuga de pollo', 'Pechuga de pollo', 100, 90, 10, 1),
('Salchicha', 'Salchicha de cerdo', 50, 40, 100, 1),
('Pescado', 'Pescado blanco', 150, 130, 10, 2),
('Jamon', 'Jamón de cerdo', 50, 40, 100, 1),
('Queso', 'Queso blanco', 50, 40, 100, 5);

