# Importar la base de práctica en MySQL 8

El archivo `manufacturing_opex.db` y el script `manufacturing_opex.sql` son para SQLite. MySQL Workbench no puede importar directamente el archivo `.db` ni ejecutar instrucciones propias de SQLite como `PRAGMA`.

Para MySQL usa exclusivamente:

`database/manufacturing_opex_mysql.sql`

## Opción recomendada: ejecutar desde el editor

1. Abre MySQL Workbench y entra a `Local instance MySQL80`.
2. Selecciona **File > Open SQL Script**.
3. Abre `manufacturing_opex_mysql.sql`.
4. Ejecuta todo el script con el botón del rayo.
5. En **Schemas**, pulsa **Refresh All**.
6. Abre el esquema `manufacturing_portfolio`.

## Alternativa: Data Import

1. Abre **Server > Data Import**.
2. Selecciona **Import from Self-Contained File**.
3. Elige `manufacturing_opex_mysql.sql`.
4. Inicia la importación. El propio script crea y selecciona el esquema `manufacturing_portfolio`.

## Validación

Al finalizar, la última consulta debe mostrar:

| objeto | filas |
|---|---:|
| plantas | 3 |
| maquinas | 10 |
| ordenes_produccion | 60 |
| paros | 36 |

También debe existir la vista `vw_ordenes_opex`.

## Importante

- Conserva los archivos SQLite para los ejercicios anteriores.
- En MySQL usa el esquema `manufacturing_portfolio`, con guion bajo.
- Las consultas básicas de `SELECT`, `WHERE`, `GROUP BY`, `HAVING` y `JOIN` seguirán siendo muy similares.
- Las funciones de fecha y algunas expresiones avanzadas pueden cambiar entre SQLite y MySQL.
