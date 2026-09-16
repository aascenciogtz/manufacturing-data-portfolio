-- Día 2 — Filtros y ordenamiento
-- Nombre: Alan Daniel Ascencio Gutierrez
-- Fecha: 15/sep/2026
-- Ejecuta cada consulta y conserva los comentarios.

-- 1. WHERE: órdenes completadas.
SELECT * FROM vw_ordenes_opex WHERE estado='Completada';

-- 2. Comparación numérica: órdenes con costo mayor a 1,200 USD.
SELECT * FROM vw_ordenes_opex WHERE costo_operacion_usd>1200;

-- 3. AND: turno A con más de 900 unidades reales.
SELECT * FROM vw_ordenes_opex WHERE unidades_reales>900 AND turno='A';

-- 4. OR: órdenes canceladas o en proceso.
SELECT * FROM vw_ordenes_opex WHERE estado='Cancelada' OR estado='En proceso';

-- 5. IN: productos Carcasa AX, Engrane CX o Panel EX.
SELECT * FROM vw_ordenes_opex WHERE producto IN ('Carcasa AX', 'Engrane CX', 'Panel EX');

-- 6. BETWEEN: órdenes fechadas del 10 al 20 de agosto de 2026, inclusive.
SELECT * FROM vw_ordenes_opex WHERE fecha BETWEEN '2026-08-10' AND '2026-08-20';

-- 7. LIKE: productos cuyo nombre termina en BX o CX.
SELECT * FROM vw_ordenes_opex WHERE (producto LIKE '%BX' OR producto LIKE '%CX');

-- 8. NOT: máquinas que no están activas.
SELECT * FROM maquinas WHERE estado NOT LIKE 'Activa';

-- 9. IS NULL: paros sin comentario.
SELECT * FROM paros WHERE comentario IS NULL;

-- 10. ORDER BY ASC: cinco órdenes con menor costo de operación.
SELECT * FROM vw_ordenes_opex ORDER BY costo_operacion_usd ASC LIMIT 5;

-- 11. ORDER BY DESC: cinco paros de mayor duración.
SELECT * FROM paros ORDER BY minutos DESC LIMIT 5;

-- 12. Ordenamiento múltiple: órdenes por planta A–Z y cumplimiento de mayor a menor.
SELECT * FROM vw_ordenes_opex ORDER BY planta ASC, cumplimiento_pct DESC;

-- 13. Reto de negocio: formula una pregunta que combine WHERE + AND.
-- Pregunta: ¿Cuáles son las órdenes completadas del turno A con un costo de operación mayor a 1,200 USD?
SELECT * FROM vw_ordenes_opex WHERE turno = 'A' AND estado = 'Completada' AND costo_operacion_usd > 1200;

-- 14. Reto de negocio: formula una pregunta que use IN o BETWEEN y ORDER BY.
-- Pregunta: ¿Cuáles son las órdenes de los productos Carcasa AX, Engrane CX o Panel EX fechadas entre el 10 y el 20 de agosto de 2026, ordenadas por costo de operación de menor a mayor?
SELECT * FROM vw_ordenes_opex WHERE producto IN ('Carcasa AX', 'Engrane CX', 'Panel EX') AND fecha BETWEEN '2026-08-10' AND '2026-08-20' ORDER BY costo_operacion_usd ASC;

-- 15. Reto de negocio: formula una pregunta que use LIKE, NOT o IS NULL.
-- Pregunta: ¿Cuáles son los paros sin comentario y con responsable que no es calidad?
SELECT * FROM paros WHERE comentario IS NULL AND responsable NOT LIKE 'Calidad';

