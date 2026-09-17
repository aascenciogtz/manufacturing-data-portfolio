# Repaso Día 5

Complementando la información con el código cargado, pude encontrar las siguientes respuesta y reflexiones para dar respuesta a los ejercicios y poder orientar la empresa a la excelencia operativa.
<br>

## 1. ¿Cuáles son las 10 órdenes completadas de mayor costo?
Aplicando el siguiente código:

~~~
SELECT orden_id, producto, costo_operacion_usd
	FROM vw_ordenes_opex
	WHERE estado IN ('Completada')
	ORDER BY costo_operacion_usd DESC
	LIMIT 10;
~~~

<br>
   
Se obtienen los siguientes datos:
| orden_id | producto   | planta        | turno | maquina            | costo_operacion_usd |
| -------- | ---------- | ------------- | ----- | ------------------ | ------------------: |
| 29       | Eje FX     | Planta Centro | C     | Horno 601          |                1764 |
| 59       | Eje FX     | Planta Centro | C     | Horno 601          |                1764 |
| 10       | Panel EX   | Planta Norte  | B     | Inspeccion 701     |              1762.5 |
| 28       | Panel EX   | Planta Centro | B     | Empacadora 501     |                1545 |
| 58       | Panel EX   | Planta Centro | B     | Empacadora 501     |                1545 |
| 9        | Valvula DX | Planta Centro | A     | Horno 601          |              1543.5 |
| 39       | Valvula DX | Planta Centro | A     | Horno 601          |              1543.5 |
| 47       | Eje FX     | Planta Centro | C     | Cabina Pintura 401 |                1532 |
| 20       | Engrane CX | Planta Norte  | C     | Inspeccion 701     |              1527.5 |
| 50       | Engrane CX | Planta Norte  | C     | Inspeccion 701     |              1527.5 |

<br>

Estos resultados arrojan que las órdenes con mayor costo operativo son: **29, 59, 10, 28, 58, 9, 39, 47, 20, 50**.
Con costos arriba de **1,527 USD** por producción total.
Si revisamos bien la información podemos identificar que el costo operativo mayor es de la **Planta Centro**, ya que es la que más se presenta en todo el análisis.

## 2. ¿Qué órdenes de los turnos A o B tuvieron más de 20 defectos?
Considerando el requerimiento del ejercicio, se planteó el siguiente código:

~~~
SELECT orden_id, turno, unidades_defectuosas
	FROM vw_ordenes_opex
	WHERE unidades_defectuosas>20 AND (turno LIKE 'A' OR turno LIKE 'B')
	ORDER BY unidades_defectuosas DESC;
~~~

<br>

Se obtuvieron los siguientes resultados:
| orden_id | turno | unidades_defectuosas |
| -------- | ----- | -------------------: |
| 13       | B     |                   72 |
| 39       | A     |                   72 |
| 52       | B     |                   72 |
| 34       | B     |                   46 |
| 27       | A     |                   45 |
| 6        | A     |                   42 |
| 54       | A     |                   42 |
| 40       | B     |                   40 |
| 33       | A     |                   39 |
| 19       | B     |                   37 |
| 12       | A     |                   36 |
| 60       | A     |                   36 |
| 46       | B     |                   34 |
| 25       | B     |                   31 |
| 18       | A     |                   30 |
| 4        | B     |                   28 |
| 45       | A     |                   27 |
| 31       | B     |                   25 |
| 24       | A     |                   24 |
| 10       | B     |                   22 |
| 58       | B     |                   22 |
| 3        | A     |                   21 |
| 51       | A     |                   21 |

<br>

Estos resultados arroja que se tienen **23 órdenes** con **más de 20 defectos** para los turnos **A** o **B**.

## 3. ¿Cuántas órdenes existen por producto y estado?
Aplicando el siguiente código:

~~~
SELECT producto, estado, COUNT(orden_id) AS cantidad_ordenes
    FROM vw_ordenes_opex
    GROUP BY producto, estado
    ORDER BY producto ASC, estado ASC;
~~~

<br>
Se obtuvieron los siguientes resultados:

| producto   | estado     | cantidad de ordenes |
| ---------- | ---------- | ------------------: |
| Carcasa AX | Completada |                   8 |
| Carcasa AX | En proceso |                   2 |
| Eje FX     | Cancelada  |                   1 |
| Eje FX     | Completada |                   9 |
| Engrane CX | Completada |                   7 |
| Engrane CX | En proceso |                   3 |
| Panel EX   | Cancelada  |                   1 |
| Panel EX   | Completada |                   7 |
| Panel EX   | En proceso |                   2 |
| Soporte BX | Completada |                  10 |
| Valvula DX | Cancelada  |                   1 |
| Valvula DX | Completada |                   9 |

## 4. ¿Qué planta produjo más unidades reales en total?
Con el siguiente código podemos dar respuesta a la pregunta:

~~~
SELECT planta, SUM(unidades_reales) AS unidades_totales
    FROM vw_ordenes_opex
    GROUP BY planta
    ORDER BY unidades_totales DESC
    LIMIT 1;
~~~

<br>
La respuesta es:

| planta           | unidades_totales |
| ---------------- | ---------------: |
| **Planta Norte** |            27075 |


## 5. ¿Cuál fue el porcentaje promedio de defectos por turno?
Para dar respuesta a esta pregunta usamos la columna defectos_pct, que ya tiene el porcentaje de defectos para la órden producida, generando así el siguiente código:

~~~
SELECT turno, AVG(defectos_pct) AS pct_defectos
    FROM vw_ordenes_opex
	GROUP BY turno
	ORDER BY pct_defectos DESC;
~~~

<br>
Dando como respuesta:

| turno | pct_defectos |
| ----- | -----------: |
| A     |       2.5595 |
| B     |       2.5255 |
| C     |         2.49 |

Lo que indica, que el turno con mayor promedio de defectos es el **turno A**.

## 6. ¿Qué máquinas acumularon más de 250 minutos de paro?
Para dar respuesta a esta pregunta, utilizamos el comando HAVING, que permite crear el condicional de mayor a 250 minutos. Se incluye en el siguiente código:

~~~
SELECT maquina_id, SUM(minutos) AS minutos_paro
    FROM paros
	GROUP BY maquina_id
	HAVING SUM(minutos)>250
	ORDER BY minutos_paro DESC;
~~~

<br>
Con este código, se obtuvo la siguiente respuesta:

| maquina_id | minutos_paro |
| ---------- | -----------: |
| 9          |          380 |
| 5          |          380 |
| 3          |          380 |
| 8          |          300 |
| 6          |          300 |
| 2          |          300 |
| 10         |          285 |
| 1          |          265 |

Lo que indica, que se tuvieron **8 máquinas** con paros **mayores a 250 minutos**.

## 7. ¿Cuáles son los tres tipos de paro con mayor costo total?
Aplicando el siguiente código es que podemos llegar a la respuesta:

~~~
SELECT tipo, SUM(costo_estimado_usd) AS costo_total
    FROM paros
	GROUP BY tipo
	HAVING SUM(costo_estimado_usd)>250
	ORDER BY costo_total DESC
    LIMIT 3;
~~~

<br>
Dando como resultado:

| tipo             | costo_total |
| ---------------- | ----------: |
| Falla            |     2644.17 |
| Cambio de modelo |     2308.67 |
| Calidad          |     2223.17 |

El resultado es:
1. Falla
2. Cambio de modelo
3. Calidad

## 8. Clasifica las órdenes en **Cumple** si unidades reales ≥ unidades plan y **No cumple** en caso contrario; cuenta cada categoría.
Para contabilizarlas, utilizamos el comando CASE:

~~~
SELECT 
	CASE
		WHEN unidades_reales>=unidades_plan THEN 'Cumple'
		ELSE 'No Cumple'
	END AS categoria_cumplimiento,
	COUNT (orden_id) AS cantidad_ordenes
    FROM vw_ordenes_opex
	GROUP BY categoria_cumplimiento;
~~~

<br>
Dando como resultado:

| categoria_cumplimiento | cantidad_ordenes |
| ---------------------- | ---------------: |
| Cumple                 |               24 |
| No Cumple              |               36 |


## 9. Por planta, muestra órdenes, unidades reales, defectos y costo total; ordena por costo descendente.
Para conseguir este resumen, se utilizó el siguiente código:

~~~
SELECT planta, COUNT(orden_id) AS cantidad_ordenes, SUM(unidades_reales) AS unidades_totales, SUM(unidades_defectuosas) AS defectos_totales, SUM(costo_operacion_usd) AS costo_total
    FROM vw_ordenes_opex
    GROUP BY planta
    ORDER BY costo_total DESC;
~~~

<br>
Dando como resultado:

| planta        | cantidad_ordenes | unidades_totales | defectos_totales | costo_total |
| ------------- | ---------------: | ---------------: | ---------------: | ----------: |
| Planta Centro |               18 |            20115 |              405 |       25338 |
| Planta Norte  |               24 |            27075 |              673 |       23802 |
| Planta Bajio  |               18 |            16460 |              454 |       19500 |

Lo que nos indica, que el costo total más alto por planta es: **Planta Centro** con un costo total de: **25,338 USD**.

## 10. ¿Qué productos tienen más de 8,000 unidades reales y un promedio de defectos menor a 30?
Para poder responder a este planteamiento, se utilizó el comando HAVING para condicionar las unidades reales y el promedio de defectos:

~~~
SELECT producto, SUM(unidades_reales) AS unidades_totales, AVG(defectos_pct) AS promedio_defectos
    FROM vw_ordenes_opex
    GROUP BY producto
    HAVING SUM(unidades_reales)>8000 AND AVG(defectos_pct)<30
    ORDER BY unidades_totales DESC;
~~~

<br>
Se obtuvieron los siguientes resultados:

| producto   | unidades_totales | promedio_defectos |
| ---------- | ---------------: | ----------------: |
| Carcasa AX |            11175 |             2.311 |
| Soporte BX |            10665 |             2.138 |
| Engrane CX |            10580 |             2.284 |
| Valvula DX |            10495 |             2.808 |
| Panel EX   |            10410 |             2.913 |
| Eje FX     |            10325 |             2.696 |

Demostrando que se tienen **6 productos** que cumplen con las condicionales. Además el producto con mayor unidades producidas reales es **Carcasa AX** y tiene **11,175 unidades totales** con un promedio de defectos de **2.311**.
