-- Creación de la tabla PROVEEDOR con sus atributos
CREATE TABLE PROVEEDOR (
    CODIGO_PROV INTEGER PRIMARY KEY,
    NOMBRE_PROV VARCHAR(20) NOT NULL,
    DIRECCION VARCHAR(20) NOT NULL,
    TELEFONO VARCHAR(20) NOT NULL,
    CIUDAD VARCHAR(20) NOT NULL
);

-- Creación de la tabla COMPRA con sus atributos y clave foránea
CREATE TABLE COMPRA (
    NO_COMPRA INTEGER PRIMARY KEY,
    CODIGO_PROV INTEGER NOT NULL,
    FECHA_COMPRA DATE NOT NULL,
    FECHA_ENTREGA DATE NOT NULL,
    CONSTRAINT FK_COMPRA_PROVEEDOR FOREIGN KEY (CODIGO_PROV) REFERENCES PROVEEDOR (CODIGO_PROV)
);

-- Creación de la tabla REPUESTOS con sus atributos
CREATE TABLE REPUESTOS (
    CODIGO_REP INTEGER PRIMARY KEY,
    NOMBRE_REP VARCHAR(20) NOT NULL,
    PRESENTACION VARCHAR(20) CHECK (PRESENTACION IN ('CAJA','UNIDAD','METRO','KILO','BOLSA')),
    VALOR_VENTA NUMBER(7,2) NOT NULL
);

-- Creación de la tabla DETALLE_COMPRA con sus atributos y claves foráneas
CREATE TABLE DETALLE_COMPRA (
    NO_COMPRA INTEGER NOT NULL,
    CODIGO_REP INTEGER NOT NULL,
    CANTIDAD INTEGER NOT NULL,
    VALOR_COMPRA NUMBER(7,2) NOT NULL,
    CONSTRAINT PK_REPUESTOS_COMPRA PRIMARY KEY (NO_COMPRA, CODIGO_REP),
    CONSTRAINT FK_COMPRA FOREIGN KEY (NO_COMPRA) REFERENCES COMPRA (NO_COMPRA),
    CONSTRAINT FK_REPUESTO FOREIGN KEY (CODIGO_REP) REFERENCES REPUESTOS (CODIGO_REP)
);

-- Consulta para mostrar los registros de cada tabla
SELECT * FROM PROVEEDOR;
SELECT * FROM COMPRA;
SELECT * FROM REPUESTOS;
SELECT * FROM DETALLE_COMPRA;

-- Eliminación de registros en las tablas
DELETE FROM COMPRA;
DELETE FROM PROVEEDOR;
DELETE FROM REPUESTOS;

-- Inserción de datos en la tabla PROVEEDOR utilizando INSERT ALL
INSERT ALL
    INTO PROVEEDOR (CODIGO_PROV, NOMBRE_PROV, DIRECCION, TELEFONO, CIUDAD) VALUES (1, 'BOSCH', 'Diag 25#53A-30', '123456', 'Bogota')
    INTO PROVEEDOR (CODIGO_PROV, NOMBRE_PROV, DIRECCION, TELEFONO, CIUDAD) VALUES (2, 'SACHS', 'Trans 40#30-10', '654321', 'Barranquilla')
    INTO PROVEEDOR (CODIGO_PROV, NOMBRE_PROV, DIRECCION, TELEFONO, CIUDAD) VALUES (3, 'COCHS', 'CLL 4 # 10-20', '6475892', 'Cartagena')
SELECT * FROM DUAL;

-- Inserción de datos en la tabla REPUESTOS utilizando INSERT ALL
INSERT ALL
    INTO REPUESTOS (CODIGO_REP, NOMBRE_REP, PRESENTACION, VALOR_VENTA) VALUES (2345, 'Amortiguadores', 'UNIDAD', 5000)
    INTO REPUESTOS (CODIGO_REP, NOMBRE_REP, PRESENTACION, VALOR_VENTA) VALUES (2447, 'Discos de Freno', 'CAJA', 10000)
    INTO REPUESTOS (CODIGO_REP, NOMBRE_REP, PRESENTACION, VALOR_VENTA) VALUES (1234, 'LLanta', 'UNIDAD', 25000)
SELECT * FROM DUAL;

-- Inserción de datos en la tabla COMPRA utilizando INSERT ALL
INSERT ALL
    INTO COMPRA (NO_COMPRA, CODIGO_PROV, FECHA_COMPRA, FECHA_ENTREGA) VALUES (10, 1, TO_DATE('02/03/2018', 'DD/MM/YYYY'), TO_DATE('02/04/2018', 'DD/MM/YYYY'))
    INTO COMPRA (NO_COMPRA, CODIGO_PROV, FECHA_COMPRA, FECHA_ENTREGA) VALUES (20, 2, TO_DATE('07/05/2018', 'DD/MM/YYYY'), TO_DATE('08/07/2018', 'DD/MM/YYYY'))
    INTO COMPRA (NO_COMPRA, CODIGO_PROV, FECHA_COMPRA, FECHA_ENTREGA) VALUES (30, 3, TO_DATE('01/08/2018', 'DD/MM/YYYY'), TO_DATE('01/09/2019', 'DD/MM/YYYY'))
SELECT 1 FROM DUAL;

-- Inserción de datos en la tabla DETALLE_COMPRA
INSERT INTO DETALLE_COMPRA (NO_COMPRA, CODIGO_REP, CANTIDAD, VALOR_COMPRA) VALUES (10, 2345, 30, 5000);

-- Consultas
-- 1. Muestra las distintas ciudades en la tabla Proveedores
SELECT DISTINCT CIUDAD FROM PROVEEDOR;
-- 2. Muestra información en minúscula de los proveedores de nombre terminado por la cadena 'CHS'
--    y que se encuentran en la ciudad de BARRANQUILLA o CARTAGENA.
SELECT LOWER(NOMBRE_PROV) AS NOMBRE_PROV_MINUSCULA, DIRECCION, TELEFONO, CIUDAD
FROM PROVEEDOR
WHERE SUBSTR(NOMBRE_PROV, -3) = 'CHS' AND CIUDAD IN ('Barranquilla', 'Cartagena');

-- 3. Muestra la primera letra del nombre del proveedor en mayúscula de los proveedores cuya dirección
--    se encuentre en una DIAGONAL o TRANSVERSAL.
SELECT UPPER(SUBSTR(NOMBRE_PROV, 1, 1)) AS PRIMERA_LETRA_MAYUSCULA
FROM PROVEEDOR
WHERE DIRECCION LIKE '%Diag%' OR DIRECCION LIKE '%Trans%';

-- 4. Muestra el nombre del producto o repuesto y el precio que tienen una presentación de CAJA y
--    cuyo valor está entre 150,000 y 250,000 ordenado ascendentemente.
SELECT NOMBRE_REP AS NOMBRE_PRODUCTO, VALOR_VENTA AS PRECIO
FROM REPUESTOS
WHERE PRESENTACION = 'CAJA' AND VALOR_VENTA BETWEEN 150000 AND 250000
ORDER BY VALOR_VENTA ASC;

-- 5. Muestra el código del producto, el nombre en minúscula, las primeras tres letras de la unidad,
--    el valor, y el incremento del valor en un 10%.
SELECT 
    CODIGO_REP AS CODIGO_PRODUCTO,
    LOWER(NOMBRE_REP) AS NOMBRE_MINUSCULA,
    SUBSTR(PRESENTACION, 1, 3) AS PRIMERAS_TRES_LETRAS,
    VALOR_VENTA AS VALOR_ORIGINAL,
    VALOR_VENTA * 1.1 AS VALOR_INCREMENTADO
FROM REPUESTOS;

-- 6. Muestra las distintas presentaciones de los productos.
SELECT DISTINCT PRESENTACION FROM REPUESTOS;

-- 7. Muestra el código de la compra, código del proveedor y el número de meses de la compra,
--    coloca los nombres de etiquetas para cada columna.
SELECT 
    C.NO_COMPRA AS "Código de Compra",
    C.CODIGO_PROV AS "Código de Proveedor",
    ROUND(MONTHS_BETWEEN(sysdate, C.FECHA_COMPRA), 2) AS "Número de Meses"
FROM COMPRA C;

-- 8. Muestra el código de repuesto, los primeros 5 caracteres del nombre del repuesto, la presentación en minúscula,
--    valor de la venta, valor de venta con un descuento del 20% etiquetando la columna como DESCUENTO,
--    para aquellos repuestos que no tienen una presentación de CAJA o UNIDAD.
SELECT 
    CODIGO_REP AS "Código Repuestos",
    SUBSTR(NOMBRE_REP, 1, 5) AS "Primeras 5 letras del Nombre",
    LOWER(PRESENTACION) AS "Presentación",
    TO_CHAR(VALOR_VENTA, '999,999') AS "Valor de la Venta",
    TO_CHAR(VALOR_VENTA * 0.8) AS "Descuento 20%"
FROM REPUESTOS;
-- 9. Muestra el código de la compra, código del producto, el valor de compra, la cantidad,
--    el valor parcial (Valor de Compra * Cantidad), el valor parcial aplicando un descuento del 30%,
--    ordenando la consulta por valor parcial descendentemente.
SELECT 
    DC.NO_COMPRA AS "Código de Compra",
    DC.CODIGO_REP AS "Código de Producto",
    DC.VALOR_COMPRA AS "Valor de Compra",
    DC.CANTIDAD,
    DC.VALOR_COMPRA * DC.CANTIDAD AS "Valor Parcial",
    (DC.VALOR_COMPRA * DC.CANTIDAD) * 0.7 AS "Valor Parcial con Descuento"
FROM DETALLE_COMPRA DC
ORDER BY "Valor Parcial con Descuento" DESC;

-- 10. Muestra el código del repuesto, el valor de compra en formato $999,999 y la fecha en formato día del mes,
--     día de la semana, nombre del mes y el año, de los repuestos suministrados por los proveedores 'BOSCH' o 'COCHS'.
SELECT 
    DC.CODIGO_REP AS "Código del Repuesto",
    TO_CHAR(DC.VALOR_COMPRA, '$999,999') AS "Valor de Compra",
    TO_CHAR(C.FECHA_COMPRA, 'DD/MM/YYYY') AS "Fecha (Día del Mes)",
    TO_CHAR(C.FECHA_COMPRA, 'DY') AS "Día de la Semana",
    TO_CHAR(C.FECHA_COMPRA, 'Month') AS "Nombre del Mes",
    TO_CHAR(C.FECHA_COMPRA, 'YYYY') AS "Año"
FROM DETALLE_COMPRA DC
JOIN COMPRA C ON DC.NO_COMPRA = C.NO_COMPRA
JOIN PROVEEDOR P ON C.CODIGO_PROV = P.CODIGO_PROV
WHERE P.NOMBRE_PROV IN ('BOSCH', 'COCHS');
-- 11. Muestra el número de la compra, código del proveedor, fecha de compra, fecha de entrega, 
--     calcula el número de días entre la fecha de compra y fecha de entrega etiquetando la columna como "DIAS TRANSCURRIDOS",
--     y calcula los meses entre la fecha de compra y la fecha de entrega etiquetando la columna como "meses transcurridos".
SELECT 
    C.NO_COMPRA AS "Número de Compra",
    C.CODIGO_PROV AS "Código de Proveedor",
    C.FECHA_COMPRA,
    C.FECHA_ENTREGA,
    TRUNC(C.FECHA_ENTREGA - C.FECHA_COMPRA) AS "Dias Transcurridos",
    TRUNC(MONTHS_BETWEEN(C.FECHA_ENTREGA, C.FECHA_COMPRA)) AS "Meses Transcurridos"
FROM COMPRA C;

--     etiquetando la columna como "Posible fecha de entrega".
-- 12. Muestra el número de la compra, código del proveedor, fecha de compra y la fecha de compra + 30 días,
SELECT 
    NO_COMPRA AS "No. de Compra",
    CODIGO_PROV AS "Código de Proveedor",
    FECHA_COMPRA,
    FECHA_COMPRA + 30 AS "Posible fecha de entrega"
FROM COMPRA;

-- 13. Muestra el número de la compra, código del proveedor, fecha de compra en formato 'Fri Feb 2 1981',
--     fecha de entrega en formato 'Fri Feb 2 1981', calcula el número de días transcurridos entre las dos fechas,
--     y calcula el número de semanas transcurridas entre las dos fechas.
SELECT 
    C.NO_COMPRA AS "No. de Compra",
    C.CODIGO_PROV AS "Código de Proveedor",
    TO_CHAR(C.FECHA_COMPRA, 'DY Mon DD YYYY') AS "Fecha de Compra",
    TO_CHAR(C.FECHA_ENTREGA, 'DY Mon DD YYYY') AS "Fecha de Entrega",
    TRUNC(C.FECHA_ENTREGA - C.FECHA_COMPRA) AS "Días Transcurridos",
    TRUNC((C.FECHA_ENTREGA - C.FECHA_COMPRA) / 7) AS "No. de Semanas Transcurridas"
FROM COMPRA C;

-- 14. Muestra el número de la compra, extrae el año de la fecha de compra, 
--     y muestra el mes de la fecha de compra para aquellas compras realizadas en los últimos 5 años.
SELECT 
    NO_COMPRA AS "Número de Compra",
    EXTRACT(YEAR FROM FECHA_COMPRA) AS "Año de la Compra"
FROM COMPRA;

-- 15. Concatena el nombre del producto con la unidad media separada por un espacio.
SELECT
    NOMBRE_REP || ' ' || 'UNIDAD' AS "Producto -> Unidad"
FROM REPUESTOS;

-- 16. Obtiene los primeros 5 caracteres del nombre del repuesto, los primeros 3 caracteres de la unidad,
--     y muestra el valor del producto.
SELECT 
    SUBSTR(NOMBRE_REP, 1, 5) AS "Primeros 5 Caracteres",
    SUBSTR('UNIDAD', 1, 3) AS "Primeros 3 Caracteres",
    VALOR_VENTA AS "Valor del Producto"
FROM REPUESTOS;

-- 17. Consulta los primeros 3 registros de la tabla proveedores.
SELECT *
FROM PROVEEDOR
WHERE ROWNUM <= 3;
--Parte II (consultas con funciones de grupo)
SELECT * FROM COMPRA;
--1.Inserte 3 registros más en cada una de las tablas Detalle de Compra
INSERT ALL
    INTO COMPRA (NO_COMPRA, CODIGO_PROV, FECHA_COMPRA, FECHA_ENTREGA) VALUES (40, 1, TO_DATE('15/06/2019', 'DD/MM/YYYY'), TO_DATE('20/07/2019', 'DD/MM/YYYY'))
    INTO COMPRA (NO_COMPRA, CODIGO_PROV, FECHA_COMPRA, FECHA_ENTREGA) VALUES (50, 2, TO_DATE('05/11/2020', 'DD/MM/YYYY'), TO_DATE('10/12/2020', 'DD/MM/YYYY'))
    INTO COMPRA (NO_COMPRA, CODIGO_PROV, FECHA_COMPRA, FECHA_ENTREGA) VALUES (60, 3, TO_DATE('23/09/2021', 'DD/MM/YYYY'), TO_DATE('28/10/2021', 'DD/MM/YYYY'))
SELECT 1 FROM DUAL;
--2.Muestre el numero de proveedores por ciudad
SELECT P.CIUDAD, COUNT(*) AS Numero_de_Proveedores FROM PROVEEDOR P
GROUP BY P.CIUDAD;
--3.Muestre el numero de repuestos por presentación
SELECT PRESENTACION, COUNT(*) AS "Número de Repuestos"
FROM REPUESTOS
GROUP BY PRESENTACION;
--4.Muestre la fecha máxima y mínima de Compra
SELECT MAX(FECHA_COMPRA) AS "Fecha Máxima de Compra",
       MIN(FECHA_COMPRA) AS "Fecha Mínima de Compra"
FROM COMPRA;
--5.Muestre el valor de venta máximo y mínimo del repuesto 
SELECT MAX(VALOR_VENTA) AS "Valor de Venta Máximo",
       MIN(VALOR_VENTA) AS "Valor de Venta Mínimo"
FROM REPUESTOS;
--6.Muestre el número de compras realizadas a un proveedor
SELECT P.NOMBRE_PROV AS "Proveedor",
       COUNT(C.NO_COMPRA) AS "Número de Compras"
FROM PROVEEDOR P
JOIN COMPRA C ON P.CODIGO_PROV = C.CODIGO_PROV
GROUP BY P.NOMBRE_PROV;
--7.Muestre el valor total(cantidad por valor) por compra
SELECT DC.NO_COMPRA AS "Número de Compra",
       SUM(DC.CANTIDAD * R.VALOR_VENTA) AS "Valor Total"
FROM DETALLE_COMPRA DC
JOIN REPUESTOS R ON DC.CODIGO_REP = R.CODIGO_REP
GROUP BY DC.NO_COMPRA;
--8.Muestre el valor del inventario de repuestos por unidad
SELECT
    R.CODIGO_REP AS "Código del Repuesto",
    R.NOMBRE_REP AS "Nombre del Repuesto",
    R.VALOR_VENTA AS "Valor de Venta por Unidad",
    SUM(DC.CANTIDAD) AS "Total de Unidades ",
    SUM(DC.CANTIDAD) * R.VALOR_VENTA AS "Valor Total de Inventario"
FROM REPUESTOS R
JOIN DETALLE_COMPRA DC ON R.CODIGO_REP = DC.CODIGO_REP
GROUP BY R.CODIGO_REP, R.NOMBRE_REP, R.VALOR_VENTA;

--9.Cuente el número de proveedores de la compañía
SELECT COUNT(*) AS "Número de Proveedores" FROM PROVEEDOR;
--10.Cuente el número de repuestos de la compañía.
SELECT COUNT(*) AS "NUM Repuestos" FROM REPUESTOS;  

-- 11. Determinar el valor de venta máximo y mínimo de los repuestos
SELECT MAX(VALOR_VENTA) AS "Valor de Venta Máximo",
       MIN(VALOR_VENTA) AS "Valor de Venta Mínimo"
FROM REPUESTOS;

-- 12. Calcular el promedio del valor de los repuestos
SELECT ROUND(AVG(VALOR_VENTA), 2) AS "Valor Promedio de Repuestos" FROM REPUESTOS;

-- 13. Contar el número de proveedores registrados en una misma ciudad,
--     ordenar la consulta de manera ascendente por ciudad.
SELECT CIUDAD, COUNT(*) AS "Número de Proveedores"
FROM PROVEEDOR
GROUP BY CIUDAD
ORDER BY CIUDAD ASC;

-- 14. Contar las compras realizadas por cada proveedor en los últimos 6 meses
SELECT P.NOMBRE_PROV AS "Proveedor",
       COUNT(C.NO_COMPRA) AS "Cantidad de Compras"
FROM PROVEEDOR P
JOIN COMPRA C ON P.CODIGO_PROV = C.CODIGO_PROV
WHERE C.FECHA_COMPRA >= SYSDATE - INTERVAL '6' MONTH
GROUP BY P.NOMBRE_PROV;

--15.Cuente las compras que se han realizado por proveedor, muestre solo aquellas donde el número de compras no este entre 3 y 5

SELECT P.NOMBRE_PROV AS "Proveedor",
       COUNT(C.NO_COMPRA) AS "Cantidad de Compras"
FROM PROVEEDOR P
JOIN COMPRA C ON P.CODIGO_PROV = C.CODIGO_PROV
GROUP BY P.NOMBRE_PROV
HAVING COUNT(C.NO_COMPRA) < 3 OR COUNT(C.NO_COMPRA) > 5;
--16.Calcular el valor total por compra, muestre solo las que no se encuentran entre 150000 y 200000 pesos.
SELECT C.NO_COMPRA AS "Número de Compra",
       SUM(DC.CANTIDAD * DC.VALOR_COMPRA) AS "Valor Total"
FROM COMPRA C
JOIN DETALLE_COMPRA DC ON C.NO_COMPRA = DC.NO_COMPRA
GROUP BY C.NO_COMPRA
HAVING SUM(DC.CANTIDAD * DC.VALOR_COMPRA) < 150000 OR SUM(DC.CANTIDAD * DC.VALOR_COMPRA) > 200000;

--17.Calcular el valor promedio para cada producto comprado, muestre solo el valor promedio que se encuentra entre un rango entre 500.000 y 800.000.
SELECT R.CODIGO_REP AS "Código de Producto",
       R.NOMBRE_REP AS "Nombre del Producto",
       AVG(DC.VALOR_COMPRA) AS "Valor Promedio"
FROM REPUESTOS R
JOIN DETALLE_COMPRA DC ON R.CODIGO_REP = DC.CODIGO_REP
GROUP BY R.CODIGO_REP, R.NOMBRE_REP
HAVING AVG(DC.VALOR_COMPRA) >= 500 AND AVG(DC.VALOR_COMPRA) <= 1000;













