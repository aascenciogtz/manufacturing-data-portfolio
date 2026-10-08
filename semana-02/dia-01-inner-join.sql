-- Usa `database/manufacturing_opex.db`. Escribe cada pregunta como comentario y debajo su consulta terminada en `;`.

-- 1. Mostrar cada máquina con su planta, ciudad y región.
SELECT maquina_id, maquina, plantas.planta, plantas.ciudad, plantas.region
	FROM maquinas
	INNER JOIN plantas
	ON maquinas.planta_id = plantas.planta_id;

-- 2. Mostrar las órdenes con fecha, producto, código y nombre de máquina.
SELECT orden_id, fecha, producto, maquinas.codigo AS codigo_maquina, maquinas.maquina
	FROM ordenes_produccion
	INNER JOIN maquinas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id;

-- 3. Mostrar las órdenes con planta, máquina, producto y turno.
SELECT orden_id, plantas.planta, maquinas.maquina, producto, turno
    FROM ordenes_produccion
    INNER JOIN maquinas
    INNER JOIN plantas
    ON ordenes_produccion.maquina_id = maquinas.maquina_id
    AND maquinas.planta_id = plantas.planta_id;

-- 4. Listar únicamente órdenes de máquinas de criticidad `Alta`.
SELECT orden_id, producto, maquinas.maquina, maquinas.criticidad
	FROM ordenes_produccion
	INNER JOIN maquinas
	ON maquinas.maquina_id = ordenes_produccion.maquina_id
	WHERE maquinas.criticidad="Alta";

-- 5. Mostrar paros con código de máquina, tipo, minutos y responsable.
SELECT tipo AS tipo_paro, maquinas.codigo AS codigo_maquina, minutos, responsable
	FROM paros
	INNER JOIN maquinas
	ON maquinas.maquina_id = paros.maquina_id;

-- 6. Mostrar paros con máquina, planta y costo estimado.
SELECT paros.tipo AS tipo_paro, maquinas.maquina, plantas.planta, paros.costo_estimado_usd
	FROM paros
	INNER JOIN maquinas, plantas
	ON paros.maquina_id = maquinas.maquina_id
	AND plantas.planta_id = maquinas.planta_id
	ORDER BY costo_estimado_usd DESC;

-- 7. Contar órdenes por planta usando las tres tablas necesarias.
SELECT plantas.planta, COUNT(ordenes_produccion.orden_id) AS cantidad_ordenes
	FROM ordenes_produccion
	INNER JOIN plantas, maquinas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id
	AND plantas.planta_id = maquinas.planta_id
	GROUP BY plantas.planta;

-- 8. Sumar unidades reales por área.
SELECT maquinas.area, SUM(ordenes_produccion.unidades_reales) AS unidades_reales
	FROM ordenes_produccion
	INNER JOIN maquinas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id
	GROUP BY maquinas.area
	ORDER BY unidades_reales DESC;

-- 9. Calcular el costo promedio de operación por región.
SELECT plantas.region, AVG(costo_operacion_usd) AS costo_promedio_operacion
	FROM ordenes_produccion
	INNER JOIN plantas, maquinas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id
	AND maquinas.planta_id = plantas.planta_id
	GROUP BY region;

-- 10. Mostrar las 10 órdenes completadas de mayor costo con planta y máquina.
SELECT ordenes_produccion.orden_id, ordenes_produccion.producto, ordenes_produccion.costo_operacion_usd, plantas.planta, maquinas.maquina 
	FROM ordenes_produccion
	INNER JOIN maquinas, plantas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id
	AND maquinas.planta_id = plantas.planta_id
	WHERE ordenes_produccion.estado = "Completada"
	ORDER BY ordenes_produccion.costo_operacion_usd DESC
	LIMIT 10;