# Examen Diagnóstico - Bases de Datos Avanzadas

## Sección 1: Conceptos Básicos

1. **¿Cuál es la diferencia entre base de datos y SGBD (Sistema Gestor de Base de Datos)?**

   > Una base de datos es un motor o conjunto estructurado de datos que se almacenan, mientras que el SGBD es el software que permite gestionar, manipular y consultar dicha base de datos (ejemplos: MySQL, MariaDB, PostgreSQL, SQL Server, MongoDB, VectorDB, Cassandra, Redis).

2. **¿Qué problema resuelve el modelo entidad–relación?**

   > Es un modelo de datos que permite representar gráficamente y de forma estructurada las entidades, sus atributos y las relaciones entre ellas antes de implementarlas físicamente.

3. **Define llave primaria y llave foránea.**

   > - **Llave Primaria:** Un atributo (o conjunto de ellos) que identifica de manera única a cada registro en una tabla.
   > - **Llave Foránea:** Un atributo que establece un vínculo entre dos tablas, apuntando a la llave primaria de otra tabla.

4. **¿Qué es cardinalidad en una relación?**

   > Define el número de registros que pueden estar asociados entre dos tablas (ej: 1:1, 1:N, N:M).

5. **¿Para qué sirve la normalización?**
   > Es un proceso para organizar los datos de manera que se elimine la redundancia y se proteja la integridad de la base de datos al evitar anomalías en la inserción, actualización o borrado.

---

## Ejemplo de Normalización

### Tabla: `productos`

| id_producto | nombre    | precio | stock | id_categoria |
| :---------- | :-------- | :----- | :---- | :----------- |
| 1           | Cheetos   | 20     | 5     | 1            |
| 2           | Manzana   | 8      | 2     | 2            |
| 3           | Coca-Cola | 15     | 8     | 3            |

### Tabla: `categorias`

| id_categoria | nombre  |
| :----------- | :------ |
| 1            | Snacks  |
| 2            | Frutas  |
| 3            | Bebidas |

---

## Sección 2: Modelo Entidad–Relación

### Escenario:

Un sistema escolar requiere almacenar:

- Alumnos
- Materias
- Inscripciones

_Un alumno puede inscribirse a muchas materias y una materia puede tener muchos alumnos._

### Preguntas:

6. **Identifica las entidades.**

   > Alumnos, Materias e Inscripciones.

7. **Indica el tipo de relación entre Alumno y Materia.**

   > Muchos a muchos (N:M).

8. **Indica la cardinalidad de la relación.**

   > `N:M`

9. **¿Es necesaria una entidad intermedia? ¿Por qué?**

   > Sí, para descomponer la relación muchos a muchos y evitar la duplicidad innecesaria de datos, gestionando las inscripciones de forma independiente.

10. **Menciona atributos para cada entidad.**
    > - **Alumnos:** `id`, `nombre`, `apellido`, `edad`, `genero`, `telefono`, `correo`, `direccion`.
    > - **Materias:** `id`, `nombre`, `codigo`, `creditos`, `profesor`.
    > - **Inscripciones:** `id`, `id_alumno`, `id_materia`, `fecha`, `estado`.

---

## Sección 3: Modelo Relacional

11. **Escribe las tablas necesarias.** (Ver archivo `seed.sql` o sección de DDL abajo).

12. **Indica la llave primaria de cada tabla.**

    > `id_alumno`, `id_materia`, `id_inscripcion`.

13. **Indica las llaves foráneas.**

    > En `Inscripciones`: `id_alumno` e `id_materia`.

14. **Escribe el DDL (CREATE TABLE) de la tabla de inscripción.**

```sql
CREATE TABLE Inscripciones (
    id_inscripcion INT PRIMARY KEY,
    id_alumno INT,
    id_materia INT,
    fecha TIMESTAMP,
    estado VARCHAR(40),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
    FOREIGN KEY (id_materia) REFERENCES Materias(id_materia),
    UNIQUE (id_alumno, id_materia)
);
```

15. **¿Qué restricción usarías para evitar inscripciones duplicadas?**
    > `UNIQUE` sobre la combinación de `id_alumno` e `id_materia`.

---

## Sección 4: SQL

### Esquema de base:

- `customers(id, name)`
- `orders(id, customer_id, total)`

### Consultas:

16. **Inserta un cliente.**

    ```sql
    INSERT INTO customers(name) VALUES ('Pedro');
    ```

17. **Inserta una orden asociada a un cliente.**

    ```sql
    INSERT INTO orders (customer_id, total) VALUES (1, 1000);
    ```

18. **Consulta todas las órdenes con total mayor a 10000.**

    ```sql
    SELECT * FROM orders WHERE total > 10000;
    ```

19. **Consulta el total de ventas por cliente.**

    ```sql
    SELECT c.name, SUM(o.total) AS total_ventas
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.name;
    ```

20. **Muestra solo clientes con ventas mayores a 30000.**
    ```sql
    SELECT c.name, SUM(o.total) AS total_ventas
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.name
    HAVING SUM(o.total) > 30000;
    ```

---

## Sección 5: Análisis

21. **¿Por qué es mala práctica usar `SELECT *` en producción?**

    > Porque puede afectar el rendimiento al traer datos innecesarios, expone datos sensibles accidentalmente y puede romper la aplicación si la estructura de la tabla cambia (ej. nuevas columnas).

22. **¿Qué ventaja tiene usar llaves foráneas en lugar de manejar relaciones solo en la aplicación?**
    > El motor de base de datos se encarga de mantener la **integridad referencial** de forma nativa, evitando huérfanos y garantizando que los datos sean consistentes incluso si diferentes aplicaciones acceden a la misma base.
