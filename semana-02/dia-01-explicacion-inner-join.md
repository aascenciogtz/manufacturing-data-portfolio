# Explicación Inner - Join SQL

El objetivo de esta explicación es profundizar un poco más y entender de mejor manera la forma en que se utiliza este comando.
Se procede con la respuesta a los siguientes puntos:

## 1. :key: Qué son una llave primaria y una llave foránea.
La llave primaria es una columna que se identifica como `primary key` de la tabla principal a trabajar, es la que contiene valores únicos para toda la información contenida en la tabla. Esta permite identificar a cada uno de los registros de manera completamente única y se incrementa de manera de manera automatica en enteros.
La llave foránea es la `key` que también contiene los valores únicos para cada uno de los registros de la información, pero que se encuentra en una segunda tabla y contiene otro tipo de información, pero que dicho conjunto de tablas se mantienen relacionadas por el `id` que se haya definido.

## 2. :question: ¿Por qué la condición `ON` es necesaria y qué ocurriría si se omite?
Se necesita inclui la condición ON para poder especificar en que llaves primarias se van a conectar los datos, ya que estos son valores completamente únicos que permiten realizar este tipo de relaciones con información de distintas tablas.
En caso de que no se agregara, el contenido solicitado en el query mostraría el primer valor obtenido, y se estaría repitiendo para cada uno de los resultados ya que no encuentra una relación de valores únicos.

## 3. :sparkles: Dos resultados obtenidos y su significado para la operación.
Con la realización de los ejercicios para este día, puedo observar que uno de los puntos más relevantes fue identificar los productos que tienen una criticidad Alta en los equipos, y que en ocasiones se pasa por alto en la operación diaria. Conociendo esta característica importante del equipo es que se pueden trabajar planes de acción más específicos, destinar mayores controles operativos, técnicos y de confirmación para evitar que por algún fallo en el equipo se tenga que detener la operación.

Otro valor obtenido es la cantidad de minutos y costo estimado en USD de paros de línea. Con este valor se puede observar que una gran parte de los paros obtenidos es por temas de calidad en el producto, por lo que se generan costos más elevados en reparaciones y que generan a su vez desperdicios en el proceso (tiempo operativo, costo de reparación, costo por mala calidad, mano de obra operativa para recuperaciones, entre otros posibles efectos).

<br>

## Resultado de los ejercicios ejecutados

### 1. Mostrar cada máquina con su planta, ciudad y región.

Código:
~~~
SELECT maquina_id, maquina, plantas.planta, plantas.ciudad, plantas.region
	FROM maquinas
	INNER JOIN plantas
	ON maquinas.planta_id = plantas.planta_id;
~~~

<br>

Resultado:
| maquina_id | maquina            | planta        | ciudad    | region |
| ---------- | ------------------ | ------------- | --------- | ------ |
| 1          | Prensa 101         | Planta Norte  | Monterrey | Norte  |
| 2          | Prensa 102         | Planta Norte  | Monterrey | Norte  |
| 3          | CNC 201            | Planta Norte  | Monterrey | Norte  |
| 4          | CNC 202            | Planta Bajio  | Queretaro | Centro |
| 5          | Linea Ensamble 301 | Planta Bajio  | Queretaro | Centro |
| 6          | Linea Ensamble 302 | Planta Bajio  | Queretaro | Centro |
| 7          | Cabina Pintura 401 | Planta Centro | Puebla    | Centro |
| 8          | Empacadora 501     | Planta Centro | Puebla    | Centro |
| 9          | Horno 601          | Planta Centro | Puebla    | Centro |
| 10         | Inspeccion 701     | Planta Norte  | Monterrey | Norte  |

<br>

### 2. Mostrar las órdenes con fecha, producto, código y nombre de máquina.

Código:
~~~
SELECT orden_id, fecha, producto, maquinas.codigo AS codigo_maquina, maquinas.maquina
	FROM ordenes_produccion
	INNER JOIN maquinas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id;
~~~

<br>

Resultado:
| orden_id | fecha      | producto   | codigo_maquina | maquina            |
| -------- | ---------- | ---------- | -------------- | ------------------ |
| 1        | 01/08/2026 | Soporte BX | PRE-101        | Prensa 101         |
| 2        | 02/08/2026 | Engrane CX | PRE-102        | Prensa 102         |
| 3        | 03/08/2026 | Valvula DX | CNC-201        | CNC 201            |
| 4        | 04/08/2026 | Panel EX   | CNC-202        | CNC 202            |
| 5        | 05/08/2026 | Eje FX     | ENS-301        | Linea Ensamble 301 |
| 6        | 06/08/2026 | Carcasa AX | ENS-302        | Linea Ensamble 302 |
| 7        | 07/08/2026 | Soporte BX | PIN-401        | Cabina Pintura 401 |
| 8        | 08/08/2026 | Engrane CX | EMP-501        | Empacadora 501     |
| 9        | 09/08/2026 | Valvula DX | HOR-601        | Horno 601          |
| 10       | 10/08/2026 | Panel EX   | INS-701        | Inspeccion 701     |
| 11       | 11/08/2026 | Eje FX     | PRE-101        | Prensa 101         |
| 12       | 12/08/2026 | Carcasa AX | PRE-102        | Prensa 102         |
| 13       | 13/08/2026 | Soporte BX | CNC-201        | CNC 201            |
| 14       | 14/08/2026 | Engrane CX | CNC-202        | CNC 202            |
| 15       | 15/08/2026 | Valvula DX | ENS-301        | Linea Ensamble 301 |
| 16       | 16/08/2026 | Panel EX   | ENS-302        | Linea Ensamble 302 |
| 17       | 17/08/2026 | Eje FX     | PIN-401        | Cabina Pintura 401 |
| 18       | 18/08/2026 | Carcasa AX | EMP-501        | Empacadora 501     |
| 19       | 19/08/2026 | Soporte BX | HOR-601        | Horno 601          |
| 20       | 20/08/2026 | Engrane CX | INS-701        | Inspeccion 701     |
| 21       | 21/08/2026 | Valvula DX | PRE-101        | Prensa 101         |
| 22       | 22/08/2026 | Panel EX   | PRE-102        | Prensa 102         |
| 23       | 23/08/2026 | Eje FX     | CNC-201        | CNC 201            |
| 24       | 24/08/2026 | Carcasa AX | CNC-202        | CNC 202            |
| 25       | 25/08/2026 | Soporte BX | ENS-301        | Linea Ensamble 301 |
| 26       | 26/08/2026 | Engrane CX | ENS-302        | Linea Ensamble 302 |
| 27       | 27/08/2026 | Valvula DX | PIN-401        | Cabina Pintura 401 |
| 28       | 28/08/2026 | Panel EX   | EMP-501        | Empacadora 501     |
| 29       | 29/08/2026 | Eje FX     | HOR-601        | Horno 601          |
| 30       | 30/08/2026 | Carcasa AX | INS-701        | Inspeccion 701     |
| 31       | 01/08/2026 | Soporte BX | PRE-101        | Prensa 101         |
| 32       | 02/08/2026 | Engrane CX | PRE-102        | Prensa 102         |
| 33       | 03/08/2026 | Valvula DX | CNC-201        | CNC 201            |
| 34       | 04/08/2026 | Panel EX   | CNC-202        | CNC 202            |
| 35       | 05/08/2026 | Eje FX     | ENS-301        | Linea Ensamble 301 |
| 36       | 06/08/2026 | Carcasa AX | ENS-302        | Linea Ensamble 302 |
| 37       | 07/08/2026 | Soporte BX | PIN-401        | Cabina Pintura 401 |
| 38       | 08/08/2026 | Engrane CX | EMP-501        | Empacadora 501     |
| 39       | 09/08/2026 | Valvula DX | HOR-601        | Horno 601          |
| 40       | 10/08/2026 | Panel EX   | INS-701        | Inspeccion 701     |
| 41       | 11/08/2026 | Eje FX     | PRE-101        | Prensa 101         |
| 42       | 12/08/2026 | Carcasa AX | PRE-102        | Prensa 102         |
| 43       | 13/08/2026 | Soporte BX | CNC-201        | CNC 201            |
| 44       | 14/08/2026 | Engrane CX | CNC-202        | CNC 202            |
| 45       | 15/08/2026 | Valvula DX | ENS-301        | Linea Ensamble 301 |
| 46       | 16/08/2026 | Panel EX   | ENS-302        | Linea Ensamble 302 |
| 47       | 17/08/2026 | Eje FX     | PIN-401        | Cabina Pintura 401 |
| 48       | 18/08/2026 | Carcasa AX | EMP-501        | Empacadora 501     |
| 49       | 19/08/2026 | Soporte BX | HOR-601        | Horno 601          |
| 50       | 20/08/2026 | Engrane CX | INS-701        | Inspeccion 701     |
| 51       | 21/08/2026 | Valvula DX | PRE-101        | Prensa 101         |
| 52       | 22/08/2026 | Panel EX   | PRE-102        | Prensa 102         |
| 53       | 23/08/2026 | Eje FX     | CNC-201        | CNC 201            |
| 54       | 24/08/2026 | Carcasa AX | CNC-202        | CNC 202            |
| 55       | 25/08/2026 | Soporte BX | ENS-301        | Linea Ensamble 301 |
| 56       | 26/08/2026 | Engrane CX | ENS-302        | Linea Ensamble 302 |
| 57       | 27/08/2026 | Valvula DX | PIN-401        | Cabina Pintura 401 |
| 58       | 28/08/2026 | Panel EX   | EMP-501        | Empacadora 501     |
| 59       | 29/08/2026 | Eje FX     | HOR-601        | Horno 601          |
| 60       | 30/08/2026 | Carcasa AX | INS-701        | Inspeccion 701     |

<br>

### 3. Mostrar las órdenes con planta, máquina, producto y turno.

Código:
~~~
SELECT orden_id, plantas.planta, maquinas.maquina, producto, turno
    FROM ordenes_produccion
    INNER JOIN maquinas, plantas
    ON ordenes_produccion.maquina_id = maquinas.maquina_id
    AND maquinas.planta_id = plantas.planta_id;
~~~

<br>

Resultado:
| orden_id | fecha         | maquina            | producto   | turno |
| -------- | ------------- | ------------------ | ---------- | ----- |
| 1        | Planta Norte  | Prensa 101         | Soporte BX | B     |
| 2        | Planta Norte  | Prensa 102         | Engrane CX | C     |
| 3        | Planta Norte  | CNC 201            | Valvula DX | A     |
| 4        | Planta Bajio  | CNC 202            | Panel EX   | B     |
| 5        | Planta Bajio  | Linea Ensamble 301 | Eje FX     | C     |
| 6        | Planta Bajio  | Linea Ensamble 302 | Carcasa AX | A     |
| 7        | Planta Centro | Cabina Pintura 401 | Soporte BX | B     |
| 8        | Planta Centro | Empacadora 501     | Engrane CX | C     |
| 9        | Planta Centro | Horno 601          | Valvula DX | A     |
| 10       | Planta Norte  | Inspeccion 701     | Panel EX   | B     |
| 11       | Planta Norte  | Prensa 101         | Eje FX     | C     |
| 12       | Planta Norte  | Prensa 102         | Carcasa AX | A     |
| 13       | Planta Norte  | CNC 201            | Soporte BX | B     |
| 14       | Planta Bajio  | CNC 202            | Engrane CX | C     |
| 15       | Planta Bajio  | Linea Ensamble 301 | Valvula DX | A     |
| 16       | Planta Bajio  | Linea Ensamble 302 | Panel EX   | B     |
| 17       | Planta Centro | Cabina Pintura 401 | Eje FX     | C     |
| 18       | Planta Centro | Empacadora 501     | Carcasa AX | A     |
| 19       | Planta Centro | Horno 601          | Soporte BX | B     |
| 20       | Planta Norte  | Inspeccion 701     | Engrane CX | C     |
| 21       | Planta Norte  | Prensa 101         | Valvula DX | A     |
| 22       | Planta Norte  | Prensa 102         | Panel EX   | B     |
| 23       | Planta Norte  | CNC 201            | Eje FX     | C     |
| 24       | Planta Bajio  | CNC 202            | Carcasa AX | A     |
| 25       | Planta Bajio  | Linea Ensamble 301 | Soporte BX | B     |
| 26       | Planta Bajio  | Linea Ensamble 302 | Engrane CX | C     |
| 27       | Planta Centro | Cabina Pintura 401 | Valvula DX | A     |
| 28       | Planta Centro | Empacadora 501     | Panel EX   | B     |
| 29       | Planta Centro | Horno 601          | Eje FX     | C     |
| 30       | Planta Norte  | Inspeccion 701     | Carcasa AX | A     |
| 31       | Planta Norte  | Prensa 101         | Soporte BX | B     |
| 32       | Planta Norte  | Prensa 102         | Engrane CX | C     |
| 33       | Planta Norte  | CNC 201            | Valvula DX | A     |
| 34       | Planta Bajio  | CNC 202            | Panel EX   | B     |
| 35       | Planta Bajio  | Linea Ensamble 301 | Eje FX     | C     |
| 36       | Planta Bajio  | Linea Ensamble 302 | Carcasa AX | A     |
| 37       | Planta Centro | Cabina Pintura 401 | Soporte BX | B     |
| 38       | Planta Centro | Empacadora 501     | Engrane CX | C     |
| 39       | Planta Centro | Horno 601          | Valvula DX | A     |
| 40       | Planta Norte  | Inspeccion 701     | Panel EX   | B     |
| 41       | Planta Norte  | Prensa 101         | Eje FX     | C     |
| 42       | Planta Norte  | Prensa 102         | Carcasa AX | A     |
| 43       | Planta Norte  | CNC 201            | Soporte BX | B     |
| 44       | Planta Bajio  | CNC 202            | Engrane CX | C     |
| 45       | Planta Bajio  | Linea Ensamble 301 | Valvula DX | A     |
| 46       | Planta Bajio  | Linea Ensamble 302 | Panel EX   | B     |
| 47       | Planta Centro | Cabina Pintura 401 | Eje FX     | C     |
| 48       | Planta Centro | Empacadora 501     | Carcasa AX | A     |
| 49       | Planta Centro | Horno 601          | Soporte BX | B     |
| 50       | Planta Norte  | Inspeccion 701     | Engrane CX | C     |
| 51       | Planta Norte  | Prensa 101         | Valvula DX | A     |
| 52       | Planta Norte  | Prensa 102         | Panel EX   | B     |
| 53       | Planta Norte  | CNC 201            | Eje FX     | C     |
| 54       | Planta Bajio  | CNC 202            | Carcasa AX | A     |
| 55       | Planta Bajio  | Linea Ensamble 301 | Soporte BX | B     |
| 56       | Planta Bajio  | Linea Ensamble 302 | Engrane CX | C     |
| 57       | Planta Centro | Cabina Pintura 401 | Valvula DX | A     |
| 58       | Planta Centro | Empacadora 501     | Panel EX   | B     |
| 59       | Planta Centro | Horno 601          | Eje FX     | C     |
| 60       | Planta Norte  | Inspeccion 701     | Carcasa AX | A     |

<br>

### 4. Listar únicamente órdenes de máquinas de criticidad `Alta`.

Código:
~~~
SELECT orden_id, producto, maquinas.maquina, maquinas.criticidad
	FROM ordenes_produccion
	INNER JOIN maquinas
	ON maquinas.maquina_id = ordenes_produccion.maquina_id
	WHERE maquinas.criticidad="Alta";
~~~

<br>

Resultado:
| orden_id | producto   | maquina            | criticidad |
| -------- | ---------- | ------------------ | ---------- |
| 1        | Soporte BX | Prensa 101         | Alta       |
| 3        | Valvula DX | CNC 201            | Alta       |
| 5        | Eje FX     | Linea Ensamble 301 | Alta       |
| 7        | Soporte BX | Cabina Pintura 401 | Alta       |
| 9        | Valvula DX | Horno 601          | Alta       |
| 11       | Eje FX     | Prensa 101         | Alta       |
| 13       | Soporte BX | CNC 201            | Alta       |
| 15       | Valvula DX | Linea Ensamble 301 | Alta       |
| 17       | Eje FX     | Cabina Pintura 401 | Alta       |
| 19       | Soporte BX | Horno 601          | Alta       |
| 21       | Valvula DX | Prensa 101         | Alta       |
| 23       | Eje FX     | CNC 201            | Alta       |
| 25       | Soporte BX | Linea Ensamble 301 | Alta       |
| 27       | Valvula DX | Cabina Pintura 401 | Alta       |
| 29       | Eje FX     | Horno 601          | Alta       |
| 31       | Soporte BX | Prensa 101         | Alta       |
| 33       | Valvula DX | CNC 201            | Alta       |
| 35       | Eje FX     | Linea Ensamble 301 | Alta       |
| 37       | Soporte BX | Cabina Pintura 401 | Alta       |
| 39       | Valvula DX | Horno 601          | Alta       |
| 41       | Eje FX     | Prensa 101         | Alta       |
| 43       | Soporte BX | CNC 201            | Alta       |
| 45       | Valvula DX | Linea Ensamble 301 | Alta       |
| 47       | Eje FX     | Cabina Pintura 401 | Alta       |
| 49       | Soporte BX | Horno 601          | Alta       |
| 51       | Valvula DX | Prensa 101         | Alta       |
| 53       | Eje FX     | CNC 201            | Alta       |
| 55       | Soporte BX | Linea Ensamble 301 | Alta       |
| 57       | Valvula DX | Cabina Pintura 401 | Alta       |
| 59       | Eje FX     | Horno 601          | Alta       |

<br>

### 5. Mostrar paros con código de máquina, tipo, minutos y responsable.

Código:
~~~
SELECT tipo AS tipo_paro, maquinas.codigo AS codigo_maquina, minutos, responsable
	FROM paros
	INNER JOIN maquinas
	ON maquinas.maquina_id = paros.maquina_id;
~~~

<br>

Resultado:
| tipo_paro        | codigo_maquina | minutos | responsable   |
| ---------------- | -------------- | ------- | ------------- |
| Cambio de modelo | CNC-201        | 35      | Produccion    |
| Material         | ENS-302        | 55      | Calidad       |
| Calidad          | HOR-601        | 75      | Logistica     |
| Preventivo       | PRE-102        | 95      | Mantenimiento |
| Falla            | ENS-301        | 115     | Produccion    |
| Cambio de modelo | EMP-501        | 135     | Calidad       |
| Material         | PRE-101        | 155     | Logistica     |
| Calidad          | CNC-202        | 15      | Mantenimiento |
| Preventivo       | PIN-401        | 35      | Produccion    |
| Falla            | INS-701        | 55      | Calidad       |
| Cambio de modelo | CNC-201        | 75      | Logistica     |
| Material         | ENS-302        | 95      | Mantenimiento |
| Calidad          | HOR-601        | 115     | Produccion    |
| Preventivo       | PRE-102        | 135     | Calidad       |
| Falla            | ENS-301        | 155     | Logistica     |
| Cambio de modelo | EMP-501        | 15      | Mantenimiento |
| Material         | PRE-101        | 35      | Produccion    |
| Calidad          | CNC-202        | 55      | Calidad       |
| Preventivo       | PIN-401        | 75      | Logistica     |
| Falla            | INS-701        | 95      | Mantenimiento |
| Cambio de modelo | CNC-201        | 115     | Produccion    |
| Material         | ENS-302        | 135     | Calidad       |
| Calidad          | HOR-601        | 155     | Logistica     |
| Preventivo       | PRE-102        | 15      | Mantenimiento |
| Falla            | ENS-301        | 35      | Produccion    |
| Cambio de modelo | EMP-501        | 55      | Calidad       |
| Material         | PRE-101        | 75      | Logistica     |
| Calidad          | CNC-202        | 95      | Mantenimiento |
| Preventivo       | PIN-401        | 115     | Produccion    |
| Falla            | INS-701        | 135     | Calidad       |
| Cambio de modelo | CNC-201        | 155     | Logistica     |
| Material         | ENS-302        | 15      | Mantenimiento |
| Calidad          | HOR-601        | 35      | Produccion    |
| Preventivo       | PRE-102        | 55      | Calidad       |
| Falla            | ENS-301        | 75      | Logistica     |
| Cambio de modelo | EMP-501        | 95      | Mantenimiento |

<br>

### 6. Mostrar paros con máquina, planta y costo estimado.

Código:
~~~
SELECT paros.tipo AS tipo_paro, maquinas.maquina, plantas.planta, paros.costo_estimado_usd
	FROM paros
	INNER JOIN maquinas, plantas
	ON paros.maquina_id = maquinas.maquina_id
	AND plantas.planta_id = maquinas.planta_id
	ORDER BY costo_estimado_usd DESC;
~~~

<br>

Resultado:
| paro_id | tipo_paro        | maquina            | planta        | costo_estimado_usd |
| ------- | ---------------- | ------------------ | ------------- | -----------------: |
| 23      | Calidad          | Horno 601          | Planta Centro |             702.67 |
| 30      | Falla            | Inspeccion 701     | Planta Norte  |              652.5 |
| 6       | Cambio de modelo | Empacadora 501     | Planta Centro |              571.5 |
| 13      | Calidad          | Horno 601          | Planta Centro |             521.33 |
| 15      | Falla            | Linea Ensamble 301 | Planta Bajio  |             516.67 |
| 22      | Material         | Linea Ensamble 302 | Planta Bajio  |              490.5 |
| 20      | Falla            | Inspeccion 701     | Planta Norte  |             459.17 |
| 29      | Preventivo       | Cabina Pintura 401 | Planta Centro |             452.33 |
| 31      | Cambio de modelo | CNC 201            | Planta Norte  |             423.67 |
| 36      | Cambio de modelo | Empacadora 501     | Planta Centro |             402.17 |
| 5       | Falla            | Linea Ensamble 301 | Planta Bajio  |             383.33 |
| 12      | Material         | Linea Ensamble 302 | Planta Bajio  |             345.17 |
| 3       | Calidad          | Horno 601          | Planta Centro |                340 |
| 7       | Material         | Prensa 101         | Planta Norte  |             330.67 |
| 14      | Preventivo       | Prensa 102         | Planta Norte  |              328.5 |
| 21      | Cambio de modelo | CNC 201            | Planta Norte  |             314.33 |
| 19      | Preventivo       | Cabina Pintura 401 | Planta Centro |                295 |
| 28      | Calidad          | CNC 202            | Planta Bajio  |             288.17 |
| 10      | Falla            | Inspeccion 701     | Planta Norte  |             265.83 |
| 35      | Falla            | Linea Ensamble 301 | Planta Bajio  |                250 |
| 26      | Cambio de modelo | Empacadora 501     | Planta Centro |             232.83 |
| 4       | Preventivo       | Prensa 102         | Planta Norte  |             231.17 |
| 11      | Cambio de modelo | CNC 201            | Planta Norte  |                205 |
| 2       | Material         | Linea Ensamble 302 | Planta Bajio  |             199.83 |
| 18      | Calidad          | CNC 202            | Planta Bajio  |             166.83 |
| 27      | Material         | Prensa 101         | Planta Norte  |                160 |
| 33      | Calidad          | Horno 601          | Planta Centro |             158.67 |
| 9       | Preventivo       | Cabina Pintura 401 | Planta Centro |             137.67 |
| 34      | Preventivo       | Prensa 102         | Planta Norte  |             133.83 |
| 25      | Falla            | Linea Ensamble 301 | Planta Bajio  |             116.67 |
| 1       | Cambio de modelo | CNC 201            | Planta Norte  |              95.67 |
| 17      | Material         | Prensa 101         | Planta Norte  |              74.67 |
| 16      | Cambio de modelo | Empacadora 501     | Planta Centro |               63.5 |
| 32      | Material         | Linea Ensamble 302 | Planta Bajio  |               54.5 |
| 8       | Calidad          | CNC 202            | Planta Bajio  |               45.5 |
| 24      | Preventivo       | Prensa 102         | Planta Norte  |               36.5 |


<br>

### 7. Contar órdenes por planta usando las tres tablas necesarias.

Código:
~~~
SELECT plantas.planta, COUNT(ordenes_produccion.orden_id) AS cantidad_ordenes
	FROM ordenes_produccion
	INNER JOIN plantas, maquinas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id
	AND plantas.planta_id = maquinas.planta_id
	GROUP BY plantas.planta;
~~~

<br>

Resultado:
| planta        | cantidad_ordenes |
| ------------- | ---------------: |
| Planta Bajio  |               18 |
| Planta Centro |               18 |
| Planta Norte  |               24 |

<br>

### 8. Sumar unidades reales por área.

Código:
~~~
SELECT maquinas.area, SUM(ordenes_produccion.unidades_reales) AS unidades_reales
	FROM ordenes_produccion
	INNER JOIN maquinas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id
	GROUP BY maquinas.area
	ORDER BY unidades_reales DESC;
~~~

<br>

Resultado:
| area        | unidades_reales |
| ----------- | --------------: |
| Estampado   |           13325 |
| Maquinado   |           11625 |
| Ensamble    |           10860 |
| Calidad     |            7725 |
| Tratamiento |            7215 |
| Empaque     |            6705 |
| Pintura     |            6195 |

<br>

### 9. Calcular el costo promedio de operación por región.

Código:
~~~
SELECT plantas.region, AVG(costo_operacion_usd) AS costo_promedio_operacion
	FROM ordenes_produccion
	INNER JOIN plantas, maquinas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id
	AND maquinas.planta_id = plantas.planta_id
	GROUP BY region;
~~~

<br>

Resultado:
| region | costo_promedio_operacion |
| ------ | -----------------------: |
| Centro |                   1245.5 |
| Norte  |                   991.75 |

<br>

### 10. Mostrar las 10 órdenes completadas de mayor costo con planta y máquina.

Código:
~~~
SELECT ordenes_produccion.orden_id, ordenes_produccion.producto, ordenes_produccion.costo_operacion_usd, plantas.planta, maquinas.maquina 
	FROM ordenes_produccion
	INNER JOIN maquinas, plantas
	ON ordenes_produccion.maquina_id = maquinas.maquina_id
	AND maquinas.planta_id = plantas.planta_id
	WHERE ordenes_produccion.estado = "Completada"
	ORDER BY ordenes_produccion.costo_operacion_usd DESC
	LIMIT 10;
~~~

<br>

Resultado:
| orden_id | producto   | planta        | maquina            | costo_operacion_usd |
| -------- | ---------- | ------------- | ------------------ | ------------------: |
| 29       | Eje FX     | Planta Centro | Horno 601          |                1764 |
| 59       | Eje FX     | Planta Centro | Horno 601          |                1764 |
| 10       | Panel EX   | Planta Norte  | Inspeccion 701     |              1762.5 |
| 28       | Panel EX   | Planta Centro | Empacadora 501     |                1545 |
| 58       | Panel EX   | Planta Centro | Empacadora 501     |                1545 |
| 9        | Valvula DX | Planta Centro | Horno 601          |              1543.5 |
| 39       | Valvula DX | Planta Centro | Horno 601          |              1543.5 |
| 47       | Eje FX     | Planta Centro | Cabina Pintura 401 |                1532 |
| 20       | Engrane CX | Planta Norte  | Inspeccion 701     |              1527.5 |
| 50       | Engrane CX | Planta Norte  | Inspeccion 701     |              1527.5 |
