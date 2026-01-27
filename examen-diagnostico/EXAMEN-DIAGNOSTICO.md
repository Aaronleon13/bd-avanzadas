### Sección 1 – Conceptos básicos

1. ¿Cuál es la diferencia entre base de datos y SGBD (Sistema gestor de base de
   datos. )?
   R.La base datos es un motor que almacena datos, mientras que el SGBD es el
   software que gestiona la base de datos.(Mysql, Mariadb, postgresql, SQL, Mongodb, Vectordb,Cassandradb, Redis)
2. ¿Qué problema resuelve el modelo entidad–relación?
   R. El modelo entidad-relación es un modelo de datos que permite representar entidades, atributos y relaciones entre ellas.
3. Define llave primaria y llave foránea.
   R. La llave primaria es un atributo que identifica de manera única a cada registro de una tabla. La llave foránea es un atributo que establece una relación entre dos tablas.
4. ¿Qué es cardinalidad en una relación?
   R. La cardinalidad en una relación define el número de registros que pueden existir en una tabla con respecto a los registros de otra tabla.
5. ¿Para qué sirve la normalización?
   R. La normalización es un proceso que permite eliminar la redundancia de datos y mejorar la integridad de la base de datos.

## Ejemplo Normalización

Tabla productos

id_producto | nombre | precio | stock | categoria
1 | Cheetos | 20 | 5 | 1
2 | Manzana | 8 | 2 | 2
3 | Coca-Cola | 15 | 8 | 3

Tabla categorias

id_categoria | nombre
1 | Snacks
2 | Frutas
3 | Bebidas

### Sección 2 – Modelo Entidad–Relación

## Escenario:

# Un sistema escolar requiere almacenar:

● Alumnos
● Materias
● Inscripciones

Un alumno puede inscribirse a muchas materias y una materia puede tener muchos
alumnos.

## Preguntas:

6. Identifica las entidades.
   R. Alumnos, Materias, Inscripciones
7. Indica el tipo de relación entre Alumno y Materia.
   R. Muchos a muchos
8. Indica la cardinalidad de la relación.
   R. N:M
9. ¿Es necesaria una entidad intermedia? ¿Por qué?
   R.Si, evitar duplicidad de datosde alumnos en materias.
10. Menciona dos atributos para cada entidad.
    R.Alumnos: id, nombre, apellido, edad, genero, telefono, correo, direccion.
    Materias: id, nombre, codigo, creditos, profesor.
    Inscripciones: id, id_alumno, id_materia, fecha, estado.

### Sección 3 – Modelo Relacional

## A partir del escenario anterior:

11. Escribe las tablas necesarias.
    R. seed.sql
12. Indica la llave primaria de cada tabla.
    R.id_alumno, id_materia, id_inscripcion
13. Indica las llaves foráneas.
    R.id_alumno, id_materia
14. Escribe el DDL (CREATE TABLE) de la tabla de inscripción.
    R.seed.sql
15. ¿Qué restricción usarías para evitar inscripciones duplicadas?
    R.UNIQUE

### Sección 4 – SQL

## Dadas las siguientes tablas:

customers(id, name)
orders(id, customer_id, total)

## Preguntas:

16. Inserta un cliente.
    R. seeds.sql
17. Inserta una orden asociada a un cliente.
    R. seeds.sql
18. Consulta todas las órdenes con total mayor a 10000.
    R. seeds.sql
19. Consulta el total de ventas por cliente.
    R. seeds.sql
20. Muestra solo clientes con ventas mayores a 30000.
    R. seeds.sql

### Sección 5 – Análisis

21. ¿Por qué es mala práctica usar SELECT \* en producción?
    R. Para evitar trae datos sensibles que no deberian de mostrarse.
22. ¿Qué ventaja tiene usar llaves foráneas en lugar de manejar relaciones solo en la
    aplicación?
    R. El motor de base de datos se encarga de mantener la integridad de los datos.
