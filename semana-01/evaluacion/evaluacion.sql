-- Evaluación Semana 01
-- Nombre: Alan Ascencio
-- Fecha: 20/sep/2026

-- 1. Mostrar cinco órdenes con columnas seleccionadas y alias.
SELECT orden_id, criticidad, producto, unidades_reales, costo_operacion_usd, estado
	FROM vw_ordenes_opex
	LIMIT 5;

-- 2. Filtrar órdenes completadas con costo mayor a 1,100.
SELECT orden_id, producto, estado
	FROM vw_ordenes_opex
	WHERE estado = 'Completada';

-- 3. Filtrar tres productos mediante `IN`.
SELECT orden_id, producto
	FROM vw_ordenes_opex
	WHERE producto IN('Carcasa AX', 'Engrane CX', 'Eje FX');

-- 4. Recuperar órdenes de un intervalo de fechas y ordenarlas por costo descendente.
SELECT orden_id, producto, fecha, costo_operacion_usd
	FROM vw_ordenes_opex
	WHERE fecha BETWEEN '2026-08-12' AND '2026-08-15'
	ORDER BY costo_operacion_usd DESC;

-- 5. Buscar productos que terminen en AX o EX.
SELECT producto
	FROM vw_ordenes_opex
	WHERE (producto LIKE '%EX' OR producto LIKE '%AX')
	GROUP BY producto;
    
-- 6. Contar órdenes por estado.
SELECT estado, COUNT(orden_id) AS cantidad_ordenes
	FROM vw_ordenes_opex
	GROUP BY estado;

-- 7. Calcular unidades reales y defectuosas totales por planta.
SELECT planta, SUM(unidades_reales) AS unidades_reales_totales, SUM(unidades_defectuosas) AS unidades_defectuosas_totales
	FROM vw_ordenes_opex
	GROUP BY planta;

-- 8. Obtener costo mínimo, máximo y promedio por turno.
SELECT turno, MIN(costo_operacion_usd) AS costo_minimo, MAX(costo_operacion_usd) AS costo_maximo, AVG(costo_operacion_usd) AS costo_promedio
	FROM vw_ordenes_opex
	GROUP BY turno;

-- 9. Mostrar máquinas con más de 5 órdenes.
SELECT maquina, COUNT(orden_id)
	FROM vw_ordenes_opex
	GROUP BY maquina
	HAVING COUNT(orden_id)>5;

-- 10. Mostrar tipos de paro con más de 200 minutos acumulados.
SELECT tipo, SUM(minutos) AS tiempo_paro
	FROM paros
	GROUP BY tipo
	HAVING SUM(minutos)>200;

-- 11. Clasificar órdenes por cumplimiento: bajo, objetivo y sobre objetivo.
SELECT orden_id, producto,  
	CASE
		WHEN cumplimiento_pct < 80 THEN 'Bajo'
		WHEN cumplimiento_pct > 95 THEN 'Sobre objetivo'
		ELSE 'Objetivo'
	END AS categoria_cumplimiento
	FROM vw_ordenes_opex;

-- 12. Contar órdenes por categoría de cumplimiento.
SELECT 
	CASE
		WHEN cumplimiento_pct < 80 THEN 'Bajo'
		WHEN cumplimiento_pct > 95 THEN 'Sobre objetivo'
		ELSE 'Objetivo'
	END AS categoria_cumplimiento,
	COUNT(orden_id)
	FROM vw_ordenes_opex
	GROUP BY categoria_cumplimiento;

-- 13. Mostrar las tres máquinas con más minutos de paro.
SELECT maquina_id, SUM(minutos) AS minutos_paro
	FROM paros
	GROUP BY maquina_id
	ORDER BY minutos_paro DESC
	LIMIT 3;

-- 14. Por producto, mostrar unidades reales, defectos y porcentaje de defectos; ordenar del peor al mejor.
SELECT producto, SUM(unidades_reales) AS unidades_reales, SUM(unidades_defectuosas) AS unidades_defectuosas, SUM(defectos_pct) AS porcentaje_defectos
	FROM vw_ordenes_opex
	GROUP BY producto
	ORDER BY unidades_defectuosas DESC;

-- 15. Formular una pregunta propia que combine filtro, agregación, `GROUP BY`, `HAVING` y ordenamiento.
-- Pregunta formulada: 15. Productos con más de 5,000 unidades reales producidas y costo promedio mayor a 1,000 USD, ordenados por costo promedio descendente.
SELECT producto, SUM(unidades_reales) AS unidades_producidas, AVG(costo_operacion_usd) AS costo_promedio
	FROM vw_ordenes_opex
	GROUP BY producto
	HAVING costo_promedio > 1000
	ORDER BY costo_promedio DESC;