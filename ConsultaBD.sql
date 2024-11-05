-- Lista el nombre de cada producto agrupado por categoría. Ordena los resultados por precio de mayor a menor
SELECT categoria, nombre
FROM Productos
GROUP BY categoria, nombre
ORDER BY MAX(precio) DESC;

-- Calcula el promedio de ventas mensuales (en cantidad de productos) y muestra el mes y año con mayores ventas.
WITH VentasMensuales AS (
    SELECT 
        TO_CHAR(fecha, 'YYYY-MM') AS mes_anio,
        SUM(cantidad) AS total_ventas
    FROM Ventas
    GROUP BY TO_CHAR(fecha, 'YYYY-MM')
),
PromedioMensual AS (
    SELECT ROUND(AVG(total_ventas), 2) AS promedio_mensual
    FROM VentasMensuales
),
MesMayorVenta AS (
    SELECT mes_anio AS mes_y_anio, total_ventas AS mayor_venta
    FROM VentasMensuales
    WHERE total_ventas = (SELECT MAX(total_ventas) FROM VentasMensuales)
)
SELECT 
    (SELECT promedio_mensual FROM PromedioMensual) AS promedio_mensual,
    MesMayorVenta.mes_y_anio,
    MesMayorVenta.mayor_venta
FROM MesMayorVenta;

-- Encuentra el ID del cliente que ha gastado más dinero en compras durante el último año. Asegúrate de considerar clientes que se registraron hace menos de un año.
SELECT cliente_id, total_gastado
FROM (
    SELECT c.cliente_id, SUM(v.cantidad * p.precio) AS total_gastado
    FROM Ventas v
    JOIN Productos p ON v.producto_id = p.producto_id
    JOIN Clientes c ON v.cliente_id = c.cliente_id
    WHERE v.fecha >= ADD_MONTHS(SYSDATE, -12)
      AND c.fecha_registro >= ADD_MONTHS(SYSDATE, -24)
    GROUP BY c.cliente_id
    ORDER BY total_gastado DESC
) WHERE ROWNUM = 1;

-- Determina el salario promedio, el salario máximo y el salario mínimo por departamento
SELECT departamento, 
       AVG(salario) AS salario_promedio, 
       MAX(salario) AS salario_maximo, 
       MIN(salario) AS salario_minimo
FROM Empleados
GROUP BY departamento;

-- Utilizando funciones de grupo, encuentra el salario más alto en cada departamento
SELECT departamento, 
       MAX(salario) AS salario_maximo
FROM Empleados
GROUP BY departamento;

--Calcula la antigüedad en años de cada empleado y muestra aquellos con más de 10 años en la empresa
SELECT nombre, 
       departamento, 
       (SYSDATE - fecha_contratacion) / 365 AS antiguedad_anios
FROM Empleados
WHERE (SYSDATE - fecha_contratacion) / 365 > 10;
