-- Actividad de repaso Día 5
-- Alan Ascencio
-- 16/sep/2026

-- 1. ¿Cuáles son las 10 órdenes completadas de mayor costo?
SELECT orden_id, producto, costo_operacion_usd
	FROM vw_ordenes_opex
	WHERE estado IN ('Completada')
	ORDER BY costo_operacion_usd DESC
	LIMIT 10;

-- 2. ¿Qué órdenes de los turnos A o B tuvieron más de 20 defectos?
SELECT orden_id, turno, unidades_defectuosas
	FROM vw_ordenes_opex
	WHERE unidades_defectuosas>20 AND (turno LIKE 'A' OR turno LIKE 'B')
	ORDER BY unidades_defectuosas DESC;

-- 3. ¿Cuántas órdenes existen por producto y estado?
SELECT producto, estado, COUNT(orden_id) AS cantidad_ordenes
    FROM vw_ordenes_opex
    GROUP BY producto, estado
    ORDER BY producto ASC, estado ASC;

-- 4. ¿Qué planta produjo más unidades reales en total?
SELECT planta, SUM(unidades_reales) AS unidades_totales
    FROM vw_ordenes_opex
    GROUP BY planta
    ORDER BY unidades_totales DESC
    LIMIT 1;

-- 5. ¿Cuál fue el porcentaje promedio de defectos por turno?
SELECT turno, AVG(defectos_pct) AS pct_defectos
    FROM vw_ordenes_opex
	GROUP BY turno
	ORDER BY pct_defectos DESC;

-- 6. ¿Qué máquinas acumularon más de 250 minutos de paro?
SELECT maquina_id, SUM(minutos) AS minutos_paro
    FROM paros
	GROUP BY maquina_id
	HAVING SUM(minutos)>250
	ORDER BY minutos_paro DESC;

-- 7. ¿Cuáles son los tres tipos de paro con mayor costo total?
SELECT tipo, SUM(costo_estimado_usd) AS costo_total
    FROM paros
	GROUP BY tipo
	HAVING SUM(costo_estimado_usd)>250
	ORDER BY costo_total DESC
    LIMIT 3;

-- 8. Clasifica las órdenes en **Cumple** si unidades reales ≥ unidades plan y **No cumple** en caso contrario; cuenta cada categoría.
SELECT 
	CASE
		WHEN unidades_reales>=unidades_plan THEN 'Cumple'
		ELSE 'No Cumple'
	END AS categoria_cumplimiento,
	COUNT (orden_id) AS cantidad_ordenes
    FROM vw_ordenes_opex
	GROUP BY categoria_cumplimiento;

-- 9. Por planta, muestra órdenes, unidades reales, defectos y costo total; ordena por costo descendente.
SELECT planta, COUNT(orden_id) AS cantidad_ordenes, SUM(unidades_reales) AS unidades_totales, SUM(unidades_defectuosas) AS defectos_totales, SUM(costo_operacion_usd) AS costo_total
    FROM vw_ordenes_opex
    GROUP BY planta
    ORDER BY costo_total DESC;

-- 10. ¿Qué productos tienen más de 8,000 unidades reales y un promedio de defectos menor a 30?
SELECT producto, SUM(unidades_reales) AS unidades_totales, AVG(defectos_pct) AS promedio_defectos
    FROM vw_ordenes_opex
    GROUP BY producto
    HAVING SUM(unidades_reales)>8000 AND AVG(defectos_pct)<30
    ORDER BY unidades_totales DESC;
