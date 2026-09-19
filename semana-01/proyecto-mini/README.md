# Proyecto mini SQL para la Semana 01

## Objetivo
El objetivo de este proyecto es realizar un compilado de los comandos revisados durante la Semana 1, contestar a preguntas que se pueden realizar para buscar la **Excelencia Operativa** dentro de la compañía (que en este caso es solamente para fines de aprendizaje).

Las consultas sql creadas se encuentran en el archivo `consultas.sql` dentro de este mismo directorio.

<br>

## Se plantean las siguientes preguntas

### 1. ¿Qué planta tiene mayor y menor cumplimiento promedio?

Para dar respuesta a este cuestionamiento, se utilizó el siguiente código:

~~~
SELECT planta, SUM(unidades_plan) AS unidades_plan, SUM(unidades_reales) AS unidades_reales, SUM(unidades_defectuosas) AS unidades_defectuosas, AVG(cumplimiento_pct) AS cumplimiento
	FROM vw_ordenes_opex
	WHERE estado = 'Completada'
	GROUP BY planta
	ORDER BY cumplimiento DESC;
~~~

Dicho código, nos solicita la información de las sumas totales de las unidades planeadas, reales, defectuosas y cumplimiento agrupadas por planta, pero solamente con estado _Completada_ para validar solamente las órdenes que si se cumplieron al 100%.

| planta        | unidades_plan | unidades_reales | unidades_defectuosas | cumplimiento |
| ------------- | ------------: | --------------: | -------------------: | -----------: |
| Planta Centro |         14000 |           16635 |                  374 |  125.0886667 |
| Planta Norte  |         23400 |           23085 |                  580 |  100.7604762 |
| Planta Bajio  |         15700 |           13095 |                  360 |       91.525 |

<br>

Este planteamiento nos da como resultado la siguiente tabla ordenada de mayor a menor cumplimiento. Demostrando que la planta con mayor cumplimiento es **Planta Centro** con un **125.09%** de cumplimiento. Mientras que la **Planta Bajio** es la que tiene menor cumplimiento con un **91.52%**.

<br>

### 2. ¿Qué máquina acumula más minutos de paro?

En este ejercicio se utilizó el comando `SUM` para acumular los minutos de paro para cada una de las máquinas. Adicionalmente se utilizó otro comando nuevo `JOIN` que permite mezclar columnas de dos tablas, que en este caso se ligaron con `maquina_id` porque se tenía solamente `maquina_id` en la tabla de paros. El código es el siguiente:

~~~
SELECT paros.maquina_id, maquinas.maquina, SUM(paros.minutos) AS tiempo_paro
	FROM paros
	INNER JOIN maquinas ON paros.maquina_id = maquinas.maquina_id
	GROUP BY maquinas.maquina
	ORDER BY tiempo_paro DESC;
~~~

Este código nos muestra la respuesta al planteamiento indicado. Sin embargo, se tienen más plantas de las esperadas. La información se muestra en la siguiente tabla:

| maquina_id | maquina            | tiempo_paro |
| ---------- | ------------------ | ----------: |
| 5          | Linea Ensamble 301 |         380 |
| 9          | Horno 601          |         380 |
| 3          | CNC 201            |         380 |
| 2          | Prensa 102         |         300 |
| 6          | Linea Ensamble 302 |         300 |
| 8          | Empacadora 501     |         300 |
| 10         | Inspeccion 701     |         285 |
| 1          | Prensa 101         |         265 |
| 7          | Cabina Pintura 401 |         225 |
| 4          | CNC 202            |         165 |

<br>

La máquina (máquinas en este caso) que tiene **380 minutos** de paro son:
* **Linea Ensamble 301**
* **Horno 601**
* **CNC 201**

Se decidió no limitar el resultado a 1 registro en este caso, dado que se podía tener que más máquinas tuvieran el mismo resultado. Y como se visualizó con este resultado, se encontraron 3 máquinas con el mismo tiempo de paro.

<br>

### 3. ¿Qué producto genera más unidades defectuosas?

Para dar respuesta a este planteamiento, se utilizó el siguiente query:

~~~
SELECT producto, SUM(unidades_defectuosas) AS unidades_defectuosas
	FROM vw_ordenes_opex
	GROUP BY producto
	ORDER BY unidades_defectuosas DESC;
~~~

Dando como resultado la siguiente tabla:

| producto   | unidades_defectuosas |
| ---------- | -------------------: |
| Eje FX     |                  249 |
| Valvula DX |                  246 |
| Carcasa AX |                  222 |
| Soporte BX |                  213 |
| Panel EX   |                  192 |
| Engrane CX |                  192 |

<br>

Con esto se puede identificar que el producto que genera más unidades defectuosas es **Eje FX** con **249 unidades defectuosas**.

Si analizamos la información es importante no discriminar por estado de las órdenes, ya que una vista real de lo que está sucediendo en el proceso es también contabilizar los defectos que se vayan generando en órdenes _En proceso_ o con órdenes _Canceladas_.

<br>

### 4. ¿Qué turno tiene mayor porcentaje promedio de defectos?

Para dar respuesta a este planteamiento, se utilizó el siguiente query:

~~~
SELECT turno, AVG(defectos_pct) AS promedio_defectos
	FROM vw_ordenes_opex
	GROUP BY turno
	ORDER BY promedio_defectos DESC;
~~~

Esto nos da como resultado que el turno que tiene mayor porcentaje promedio de defectos es el **turno A**.

| turno | promedio_defectos |
| ----- | ----------------: |
| A     |            2.5595 |
| B     |            2.5255 |
| C     |              2.49 |

<br>

### 5. ¿Cuáles son los tres tipos de paro más costosos?

Con este planteamiento si se utilizó el comando `LIMIT` para poder mostrar solamente los 3 registros más altos.

El query utilizado es el siguiente:

~~~
SELECT tipo, SUM(costo_estimado_usd) AS costo_paro
	FROM paros
	GROUP BY tipo
	ORDER BY costo_paro DESC
	LIMIT 3;
~~~

Esto nos da como resultado que los 3 tipos de paro más costosos son:

| tipo                 | costo_paro |
| -------------------- | ---------: |
| **Falla**            |    2644.17 |
| **Cambio de modelo** |    2308.67 |
| **Calidad**          |    2223.17 |

<br>

### 6. ¿Qué máquinas críticas tienen desempeño operativo que requiere atención? Define y explica tu criterio.

Para poder dar respuesta a este planteamiento, se consideró realizar una validación de los distintos tipos de paro y su tiempo, respecto de cada una de las máquinas. Por lo que se utilizó el siguiente código:

~~~
SELECT maquinas.maquina, paros.tipo, SUM(paros.minutos) AS tiempo_paro, SUM(paros.costo_estimado_usd) AS costo_paro
	FROM paros
	INNER JOIN maquinas ON paros.maquina_id = maquinas.maquina_id
	GROUP BY maquinas.maquina, paros.tipo
	ORDER BY costo_paro DESC;
~~~

Este query muestra como resultado lo siguiente:

| maquina            | tipo             | tiempo_paro | costo_paro |
| ------------------ | ---------------- | ----------: | ---------: |
| Horno 601          | Calidad          |         380 |    1722.67 |
| Inspeccion 701     | Falla            |         285 |     1377.5 |
| Empacadora 501     | Cambio de modelo |         300 |       1270 |
| Linea Ensamble 301 | Falla            |         380 |    1266.67 |
| Linea Ensamble 302 | Material         |         300 |       1090 |
| CNC 201            | Cambio de modelo |         380 |    1038.67 |
| Cabina Pintura 401 | Preventivo       |         225 |        885 |
| Prensa 102         | Preventivo       |         300 |        730 |
| Prensa 101         | Material         |         265 |     565.34 |
| CNC 202            | Calidad          |         165 |      500.5 |

<br>

Si consideramos que para poder dar criticidad a las máquinas se deben considerar los tipos de fallos relacionados, se encuentra que tenemos el **Horno 601** con mayor tiempo de paro por temas de **Calidad** y que tiene un impacto muy elevado en costo con **1,722.67 USD**, por lo que sería la prioridad número 1.

La prioridad número 2, sería **Línea de Ensamble 301** con tiempo de paro por **Falla** en el equipo y que representa un costo de más de **1,266 USD**.

En tercer lugar, se tendría que priorizar la **Empacadora 501** con un tiempo de paro por **Cambio de modelo** con un impacto en costo de **1,270 USD**.

<br>

### 7. ¿Qué productos superan 8,000 unidades reales y cuál es su costo promedio?

Para dar respuesta a este planteamiento, se utilizó el siguiente query con el comando `HAVING`:

~~~
SELECT producto, SUM(unidades_reales) AS unidades_reales, AVG(costo_operacion_usd) AS costo_promedio
	FROM vw_ordenes_opex
	WHERE estado = 'Completada'
	GROUP BY producto
	HAVING SUM(unidades_reales)>8000
	ORDER BY unidades_reales DESC;
~~~

Esto da como resultado la siguiente tabla:

| producto   | unidades_reales | costo_promedio |
| ---------- | --------------: | -------------: |
| Soporte BX |           10665 |            975 |
| Carcasa AX |            9365 |          973.5 |
| Valvula DX |            9250 |    1182.611111 |
| Eje FX     |            9165 |    1274.222222 |

<br>

Se tienen **4 productos** que cumplen las condiciones indicadas, que tengan **más de 8,000 unidades reales**, y se incluyó una condición operativa para el estado de la órden como **Completada**, ya que sin esta condicional estaríamos evaluando órdenes _En proceso_ o _Canceladas_. Estos estados se pueden analizar a detalle más adelante para también evaluar si es viable operativamente respecto a su costo.

<br>

### 8. Crea una clasificación de riesgo **Alto/Medio/Bajo** combinando cumplimiento o defectos, y resume cuántas órdenes hay por nivel.

Para dar respuesta a este planteamiento, se utilizó el siguiente query con el comando `CASE`. Se consideró el porcentaje de cumplimiento para cada órden considerando riesgo ALTO<=80, 80\<MEDIO>90 y BAJO>=90:

~~~
SELECT 
	CASE
		WHEN cumplimiento_pct <= 80 THEN 'Alto'
		WHEN cumplimiento_pct >= 90 THEN 'Bajo'
	ELSE 'Medio' 
	END AS riesgo,
	COUNT (orden_id) AS ordenes
	FROM vw_ordenes_opex
	GROUP BY riesgo;
~~~

Esto da como resultado la siguiente clasificación:

| riesgo | ordenes |
| ------ | ------: |
| Alto   |      16 |
| Bajo   |      34 |
| Medio  |      10 |

<br>

Con esto podemos concluir que se tienen **16 órdenes** con riesgo Alto, **34 órdenes** con riesgo Bajo y **10 órdenes** con riesgo Medio.


## Recomendaciones finales

Una vez analizado todos los planteamientos indicados, y haber entendido e interpretado la información, se recomienda trabajar con actividades de mejora continua para poder reducir los desperdicios, mejorar los costos operativos, incrementar la eficiencia de los equipos y ver reflejados monetariamente estos impactos una vez implementados.

<br>

**1. Trabajar con metodologías de identificación de causas raíz e identificación de problemas enfocados a los tipos de paros más costosos, que en este caso son:**

- Falla
- Cambio de modelo
- Calidad

Algunas de la metodologías que se pueden utilizar son:
- 5W's
- Ishikawa
- VSM

<br>

**2. Enfocar los recursos para la reducción de fallas en los siguientes equipos para poder incrementar la eficiencia operativa y reducir las afectaciones a la producción:**

- Línea de Ensamble 301
- Horno 601
- CNC 201

<br>

**3. Analizar a un nivel de detalle más amplio las causas de productos con nivel más alto de defectos, que en este caso son:**
- Eje FX
- Valvula DX
- Carcasa AX

Para este caso se tendrían que arrancar con equipos CFT para identificar en conjunto las causas de fabricación de defectos, con integrantes de Mantenimiento, Producción, Calidad, y en casos necesarios Proveedores.

<br>