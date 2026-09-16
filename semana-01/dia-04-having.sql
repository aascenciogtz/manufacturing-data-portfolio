-- Ejercicios de prueba Día 04
-- Alan Ascencio
-- 16/sep/2026

-- 1. Productos cuya suma de unidades reales sea mayor a 8,000.
SELECT producto, SUM(unidades_reales) AS unidades_totales
	FROM vw_ordenes_opex
	GROUP BY producto
	HAVING SUM(unidades_reales)>8000;

-- 2. Máquinas con más de 5 órdenes registradas.
SELECT maquina, COUNT(orden_id) AS ordenes
	FROM vw_ordenes_opex
	GROUP BY maquina
	HAVING COUNT(orden_id)>5;

-- 3. Plantas cuyo promedio de cumplimiento sea menor a 100%.
SELECT planta, AVG(cumplimiento_pct) AS cumplimiento
    FROM vw_ordenes_opex
    GROUP BY planta
    HAVING AVG(cumplimiento_pct)<100;

-- 4. Tipos de paro cuya suma de minutos sea mayor a 200.
SELECT tipo, SUM(minutos) AS tiempo_paro
	FROM paros
	GROUP BY tipo
	HAVING SUM(minutos)>200;

-- 5. Responsables cuyo costo total de paros supere USD 1,000.
SELECT responsable, SUM(costo_estimado_usd) AS costo_paros
	FROM paros
	GROUP BY responsable
	HAVING SUM(costo_estimado_usd)>1000;

-- 6. Clasificar cada orden por costo: **Bajo** (<900), **Medio** (900–1,199.99) y **Alto** (≥1,200).
SELECT orden_id, producto, costo_operacion_usd,
	CASE
		WHEN costo_operacion_usd<900 THEN 'Bajo'
		WHEN costo_operacion_usd>=1200 THEN 'Alto'
		ELSE 'Medio'
	END AS categoria_costo
	FROM vw_ordenes_opex;

-- 7. Clasificar cumplimiento: **Bajo** (<90), **En objetivo** (90–100) y **Sobre objetivo** (>100).
SELECT orden_id, planta, cumplimiento_pct,
	CASE
		WHEN cumplimiento_pct<90 THEN 'Bajo'
		WHEN cumplimiento_pct>100 THEN 'Sobre objetivo'
		ELSE 'En objetivo'
	END AS categoria_cumplimiento
	FROM vw_ordenes_opex;

-- 8. Clasificar cada paro: **Corto** (≤45 min), **Medio** (46–100) o **Largo** (>100).
SELECT paro_id, tipo, minutos,
	CASE
		WHEN minutos<=45 THEN 'Corto'
		WHEN minutos>100 THEN 'Largo'
		ELSE 'Medio'
	END AS categoria_paro
	FROM paros;

-- 9. Agrupar las órdenes por la categoría de costo del ejercicio 6 y contar cuántas hay en cada categoría.
SELECT 
	CASE
		WHEN costo_operacion_usd<900 THEN 'Bajo'
		WHEN costo_operacion_usd>=1200 THEN 'Alto'
		ELSE 'Medio'
	END AS categoria_costo,
	COUNT(orden_id) AS cantidad_ordenes
	FROM vw_ordenes_opex
	GROUP BY categoria_costo;

-- 10. Por planta, contar órdenes de costo alto usando `SUM(CASE WHEN ... THEN 1 ELSE 0 END)`; mostrar sólo plantas con al menos una.
SELECT planta, SUM(CASE WHEN costo_operacion_usd>=1200 THEN 1 ELSE 0 END) AS ordenes_costo_alto
    FROM vw_ordenes_opex
    GROUP BY planta
    HAVING SUM(CASE WHEN costo_operacion_usd>=1200 THEN 1 ELSE 0 END)>0;