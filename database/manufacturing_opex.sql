PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS vw_ordenes_opex;
DROP TABLE IF EXISTS paros;
DROP TABLE IF EXISTS ordenes_produccion;
DROP TABLE IF EXISTS maquinas;
DROP TABLE IF EXISTS plantas;

CREATE TABLE plantas (
    planta_id INTEGER PRIMARY KEY,
    planta TEXT NOT NULL UNIQUE,
    ciudad TEXT NOT NULL,
    region TEXT NOT NULL
);

CREATE TABLE maquinas (
    maquina_id INTEGER PRIMARY KEY,
    codigo TEXT NOT NULL UNIQUE,
    maquina TEXT NOT NULL,
    planta_id INTEGER NOT NULL REFERENCES plantas(planta_id),
    area TEXT NOT NULL,
    criticidad TEXT NOT NULL CHECK (criticidad IN ('Alta', 'Media', 'Baja')),
    estado TEXT NOT NULL CHECK (estado IN ('Activa', 'Mantenimiento', 'Fuera de servicio')),
    costo_hora_usd REAL NOT NULL CHECK (costo_hora_usd > 0)
);

CREATE TABLE ordenes_produccion (
    orden_id INTEGER PRIMARY KEY,
    fecha TEXT NOT NULL,
    maquina_id INTEGER NOT NULL REFERENCES maquinas(maquina_id),
    producto TEXT NOT NULL,
    turno TEXT NOT NULL CHECK (turno IN ('A', 'B', 'C')),
    unidades_plan INTEGER NOT NULL,
    unidades_reales INTEGER NOT NULL,
    unidades_defectuosas INTEGER NOT NULL,
    horas_operacion REAL NOT NULL,
    costo_operacion_usd REAL NOT NULL,
    estado TEXT NOT NULL CHECK (estado IN ('Completada', 'En proceso', 'Cancelada'))
);

CREATE TABLE paros (
    paro_id INTEGER PRIMARY KEY,
    fecha TEXT NOT NULL,
    maquina_id INTEGER NOT NULL REFERENCES maquinas(maquina_id),
    tipo TEXT NOT NULL CHECK (tipo IN ('Falla', 'Cambio de modelo', 'Material', 'Calidad', 'Preventivo')),
    minutos INTEGER NOT NULL CHECK (minutos >= 0),
    costo_estimado_usd REAL NOT NULL CHECK (costo_estimado_usd >= 0),
    responsable TEXT NOT NULL,
    comentario TEXT
);

INSERT INTO plantas VALUES
    (1, 'Planta Norte', 'Monterrey', 'Norte'),
    (2, 'Planta Bajio', 'Queretaro', 'Centro'),
    (3, 'Planta Centro', 'Puebla', 'Centro');

INSERT INTO maquinas VALUES
    (1, 'PRE-101', 'Prensa 101', 1, 'Estampado', 'Alta', 'Activa', 185.00),
    (2, 'PRE-102', 'Prensa 102', 1, 'Estampado', 'Media', 'Mantenimiento', 160.00),
    (3, 'CNC-201', 'CNC 201', 1, 'Maquinado', 'Alta', 'Activa', 220.00),
    (4, 'CNC-202', 'CNC 202', 2, 'Maquinado', 'Media', 'Activa', 195.00),
    (5, 'ENS-301', 'Linea Ensamble 301', 2, 'Ensamble', 'Alta', 'Activa', 145.00),
    (6, 'ENS-302', 'Linea Ensamble 302', 2, 'Ensamble', 'Baja', 'Activa', 125.00),
    (7, 'PIN-401', 'Cabina Pintura 401', 3, 'Pintura', 'Alta', 'Fuera de servicio', 205.00),
    (8, 'EMP-501', 'Empacadora 501', 3, 'Empaque', 'Media', 'Activa', 110.00),
    (9, 'HOR-601', 'Horno 601', 3, 'Tratamiento', 'Alta', 'Activa', 250.00),
    (10, 'INS-701', 'Inspeccion 701', 1, 'Calidad', 'Baja', 'Activa', 95.00);

WITH RECURSIVE n(i) AS (
    SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 60
)
INSERT INTO ordenes_produccion
SELECT
    i,
    date('2026-08-01', printf('+%d days', (i - 1) % 30)),
    ((i - 1) % 10) + 1,
    CASE i % 6
        WHEN 0 THEN 'Carcasa AX'
        WHEN 1 THEN 'Soporte BX'
        WHEN 2 THEN 'Engrane CX'
        WHEN 3 THEN 'Valvula DX'
        WHEN 4 THEN 'Panel EX'
        ELSE 'Eje FX'
    END,
    CASE i % 3 WHEN 0 THEN 'A' WHEN 1 THEN 'B' ELSE 'C' END,
    700 + (i % 9) * 100,
    650 + (i % 11) * 85,
    CASE WHEN i % 13 = 0 THEN 72 ELSE (i * 7) % 48 END,
    5.5 + (i % 6) * 0.5,
    ROUND((5.5 + (i % 6) * 0.5) * (90 + (((i - 1) % 10) + 1) * 14.5), 2),
    CASE WHEN i % 17 = 0 THEN 'Cancelada' WHEN i % 8 = 0 THEN 'En proceso' ELSE 'Completada' END
FROM n;

WITH RECURSIVE n(i) AS (
    SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 36
)
INSERT INTO paros
SELECT
    i,
    date('2026-08-01', printf('+%d days', (i * 2) % 30)),
    ((i * 3 - 1) % 10) + 1,
    CASE i % 5 WHEN 0 THEN 'Falla' WHEN 1 THEN 'Cambio de modelo' WHEN 2 THEN 'Material' WHEN 3 THEN 'Calidad' ELSE 'Preventivo' END,
    15 + (i % 8) * 20,
    ROUND((15 + (i % 8) * 20) / 60.0 * (110 + (((i * 3 - 1) % 10) + 1) * 18), 2),
    CASE i % 4 WHEN 0 THEN 'Mantenimiento' WHEN 1 THEN 'Produccion' WHEN 2 THEN 'Calidad' ELSE 'Logistica' END,
    CASE WHEN i % 6 = 0 THEN NULL WHEN i % 2 = 0 THEN 'Requiere seguimiento' ELSE 'Evento cerrado' END
FROM n;

CREATE VIEW vw_ordenes_opex AS
SELECT
    o.orden_id,
    o.fecha,
    p.planta,
    p.region,
    m.codigo AS maquina_codigo,
    m.maquina,
    m.area,
    m.criticidad,
    o.producto,
    o.turno,
    o.unidades_plan,
    o.unidades_reales,
    o.unidades_defectuosas,
    ROUND(100.0 * o.unidades_reales / o.unidades_plan, 2) AS cumplimiento_pct,
    ROUND(100.0 * o.unidades_defectuosas / NULLIF(o.unidades_reales, 0), 2) AS defectos_pct,
    o.horas_operacion,
    o.costo_operacion_usd,
    o.estado
FROM ordenes_produccion o
JOIN maquinas m ON m.maquina_id = o.maquina_id
JOIN plantas p ON p.planta_id = m.planta_id;

