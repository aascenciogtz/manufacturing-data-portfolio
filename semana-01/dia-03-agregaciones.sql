-- Ejercicios de prueba Día 03
-- Alan Ascencio
-- 16/sep/2026

-- 1. Contar todas las órdenes de producción.
SELECT COUNT(orden_id) FROM vw_ordenes_opex;

-- 2. Sumar las unidades reales producidas.
SELECT SUM(unidades_reales) FROM vw_ordenes_opex;

-- 3. Calcular el costo promedio de operación.
SELECT AVG(costo_operacion_usd) FROM vw_ordenes_opex;

-- 4. Mostrar el costo mínimo y máximo de operación en una sola consulta.
SELECT MIN(costo_operacion_usd) AS costo_minimo, MAX(costo_operacion_usd) AS costo_maximo FROM vw_ordenes_opex;

-- 5. Contar órdenes por estado.
SELECT estado, COUNT(orden_id) AS cantidad_ordenes FROM vw_ordenes_opex GROUP BY estado;

-- 6. Sumar unidades reales por producto.
SELECT producto, SUM(unidades_reales) FROM vw_ordenes_opex GROUP BY producto;

-- 7. Calcular el costo promedio por turno.
SELECT turno, AVG(costo_operacion_usd) AS costo_promedio FROM vw_ordenes_opex GROUP BY turno;

-- 8. Sumar unidades defectuosas por planta usando `vw_ordenes_opex`.
SELECT planta, SUM(unidades_defectuosas) FROM vw_ordenes_opex GROUP BY planta;

-- 9. Contar paros por tipo.
SELECT tipo, COUNT(paro_id) AS cantidad_paros FROM paros GROUP BY tipo;

-- 10. Sumar minutos de paro por máquina.
SELECT maquina_id, SUM(minutos) AS minutos_paro FROM paros GROUP BY maquina_id;

-- 11. Calcular el costo promedio de paros por responsable.
SELECT responsable, AVG(costo_estimado_usd) AS costo_promedio FROM paros GROUP BY responsable;

-- 12. Para órdenes completadas, mostrar por planta: cantidad de órdenes, unidades reales totales y costo promedio; ordenar por unidades totales de mayor a menor.
SELECT planta, COUNT(orden_id) AS cantidad_ordenes, SUM(unidades_reales) AS unidades_totales, AVG(costo_operacion_usd) AS costo_promedio FROM vw_ordenes_opex WHERE estado LIKE 'Completada' GROUP BY planta ORDER BY unidades_totales DESC;