# Explicar qué hace cada función - Día 03

## Qué hace cada función `COUNT`, `SUM`, `AVG`, `MIN` y `MAX`.
La función que desempeña cada una de ellas es:
- COUNT: Cuenta la cantidad de registros que se incluyen para cada columna
- SUM: Suma la cantidad de datos que se tienen en la columna indicada
- AVG: Genera el promedio de los datos contenidos en la columna indicada a analizar
- MIN: Muestra el valor más pequeño de la columna indicada
- MAX: Muestra el valor más grande de la columna indicada

## Por qué una columna seleccionada que no está agregada normalmente debe aparecer en `GROUP BY`.
Para que se puedan mostrar los datos agrupados por categorías indicadas en el query, y esto segrega las funciones y muestra el resultado para cada una de estas categorías

## Tres resultados numéricos obtenidos y qué significan para el negocio.
1. Contar órdenes por estado: Esto permite identificar las órdenes que se encuentran todavía en proceso, y son las que se tendrían que priorizar para continuar con la producción. En este caso es de 7 órdenes En Proceso.
2. Unidades totales defectuosas por planta: Esto nos permite identificar cual es la planta que está generando más defectivo y que requiere de mayor atención y recursos para corregir estas anomalías en el producto para poder sacarlas a venta. Lo ideal es trabajar primero con la Planta Norte, que contiene 673 unidades defectuosas, posteriormente sería trabajar con la Planta Bajío, con 454 unidades defectuosas.
3. Minutos de paro por máquina: Esto permite identificar las máquinas que tienen mayor afectación de eficiencia, ya sea de calidad, operación, equipos, tiempo ciclo. En este caso la máquina con mayor cantidad de minutos de paro es la 9, 5 y 3, ya que se encuentran en el Top con 380 minutos de paro; lo que se traduce en 6.33 horas de paro productivo. Sería conveniente identificar qué está generando estos paros para continuar con las correcciones.