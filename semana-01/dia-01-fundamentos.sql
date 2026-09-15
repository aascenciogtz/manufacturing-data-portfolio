-- Semana 01 - Día 01
-- Fundamentos SQL
-- Temas: SELECT, FROM, LIMIT, AS

-- Ejercicio 1
SELECT * FROM materiales;
SELECT nombre FROM materiales;
SELECT precio FROM materiales;
SELECT precio FROM materiales LIMIT 5;
SELECT precio FROM materiales LIMIT 2;
SELECT nombre AS 'Nombre del Material' FROM materiales LIMIT 3;
SELECT nombre AS 'Nombre del Material' FROM materiales LIMIT 5;
SELECT nombre FROM materiales WHERE precio>1200;
SELECT nombre FROM materiales WHERE moneda='USD';

