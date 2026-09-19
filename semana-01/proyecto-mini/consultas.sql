-- Proyecto Mini - Consultas SQL
-- Autor: Alan Ascencio
-- Fecha: 18/sep/2026

-- 1. ¿Qué planta tiene mayor y menor cumplimiento promedio?
SELECT planta, SUM(unidades_plan) AS unidades_plan, SUM(unidades_reales) AS unidades_reales, SUM(unidades_defectuosas) AS unidades_defectuosas, AVG(cumplimiento_pct) AS cumplimiento
	FROM vw_ordenes_opex
	WHERE estado = 'Completada'
	GROUP BY planta
	ORDER BY cumplimiento DESC;

-- 2. ¿Qué máquina acumula más minutos de paro?
SELECT paros.maquina_id, maquinas.maquina, SUM(paros.minutos) AS tiempo_paro
	FROM paros
	INNER JOIN maquinas ON paros.maquina_id = maquinas.maquina_id
	GROUP BY maquinas.maquina
	ORDER BY tiempo_paro DESC;

-- 3. ¿Qué producto genera más unidades defectuosas?
SELECT producto, SUM(unidades_defectuosas) AS unidades_defectuosas
	FROM vw_ordenes_opex
	GROUP BY producto
	ORDER BY unidades_defectuosas DESC;

-- 4. ¿Qué turno tiene mayor porcentaje promedio de defectos?
SELECT turno, AVG(defectos_pct) AS promedio_defectos
	FROM vw_ordenes_opex
	GROUP BY turno
	ORDER BY promedio_defectos DESC;

-- 5. ¿Cuáles son los tres tipos de paro más costosos?
SELECT tipo, SUM(costo_estimado_usd) AS costo_paro
	FROM paros
	GROUP BY tipo
	ORDER BY costo_paro DESC
	LIMIT 3;

-- 6. ¿Qué máquinas críticas tienen desempeño operativo que requiere atención? Define y explica tu criterio.
-- 7. ¿Qué productos superan 8,000 unidades reales y cuál es su costo promedio?
SELECT producto, SUM(unidades_reales) AS unidades_reales, AVG(costo_operacion_usd) AS costo_promedio
	FROM vw_ordenes_opex
	WHERE estado = 'Completada'
	GROUP BY producto
	HAVING SUM(unidades_reales)>8000
	ORDER BY unidades_reales DESC;
    
-- 8. Crea una clasificación de riesgo **Alto/Medio/Bajo** combinando cumplimiento o defectos, y resume cuántas órdenes hay por nivel.
SELECT 
	CASE
		WHEN cumplimiento_pct <= 80 THEN 'Alto'
		WHEN cumplimiento_pct >= 90 THEN 'Bajo'
	ELSE 'Medio' 
	END AS riesgo,
	COUNT (orden_id) AS ordenes
	FROM vw_ordenes_opex
	GROUP BY riesgo;