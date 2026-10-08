-- Manufacturing OPEX practice database
-- Compatible with MySQL 8.0

CREATE DATABASE IF NOT EXISTS manufacturing_portfolio
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE manufacturing_portfolio;

SET FOREIGN_KEY_CHECKS = 0;

DROP VIEW IF EXISTS vw_ordenes_opex;
DROP TABLE IF EXISTS paros;
DROP TABLE IF EXISTS ordenes_produccion;
DROP TABLE IF EXISTS maquinas;
DROP TABLE IF EXISTS plantas;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE plantas (
    planta_id INT PRIMARY KEY,
    planta VARCHAR(100) NOT NULL UNIQUE,
    ciudad VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE maquinas (
    maquina_id INT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    maquina VARCHAR(100) NOT NULL,
    planta_id INT NOT NULL,
    area VARCHAR(50) NOT NULL,
    criticidad ENUM('Alta', 'Media', 'Baja') NOT NULL,
    estado ENUM('Activa', 'Mantenimiento', 'Fuera de servicio') NOT NULL,
    costo_hora_usd DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_maquinas_costo_hora CHECK (costo_hora_usd > 0),
    CONSTRAINT fk_maquinas_plantas
      FOREIGN KEY (planta_id) REFERENCES plantas(planta_id)
) ENGINE = InnoDB;

CREATE TABLE ordenes_produccion (
    orden_id INT PRIMARY KEY,
    fecha DATE NOT NULL,
    maquina_id INT NOT NULL,
    producto VARCHAR(100) NOT NULL,
    turno ENUM('A', 'B', 'C') NOT NULL,
    unidades_plan INT NOT NULL,
    unidades_reales INT NOT NULL,
    unidades_defectuosas INT NOT NULL,
    horas_operacion DECIMAL(6,2) NOT NULL,
    costo_operacion_usd DECIMAL(12,2) NOT NULL,
    estado ENUM('Completada', 'En proceso', 'Cancelada') NOT NULL,
    CONSTRAINT fk_ordenes_maquinas
      FOREIGN KEY (maquina_id) REFERENCES maquinas(maquina_id)
) ENGINE = InnoDB;

CREATE TABLE paros (
    paro_id INT PRIMARY KEY,
    fecha DATE NOT NULL,
    maquina_id INT NOT NULL,
    tipo ENUM('Falla', 'Cambio de modelo', 'Material', 'Calidad', 'Preventivo') NOT NULL,
    minutos INT NOT NULL,
    costo_estimado_usd DECIMAL(12,2) NOT NULL,
    responsable VARCHAR(100) NOT NULL,
    comentario VARCHAR(255) NULL,
    CONSTRAINT chk_paros_minutos CHECK (minutos >= 0),
    CONSTRAINT chk_paros_costo CHECK (costo_estimado_usd >= 0),
    CONSTRAINT fk_paros_maquinas
      FOREIGN KEY (maquina_id) REFERENCES maquinas(maquina_id)
) ENGINE = InnoDB;

INSERT INTO plantas (planta_id, planta, ciudad, region) VALUES
    (1, 'Planta Norte', 'Monterrey', 'Norte'),
    (2, 'Planta Bajio', 'Queretaro', 'Centro'),
    (3, 'Planta Centro', 'Puebla', 'Centro');

INSERT INTO maquinas
    (maquina_id, codigo, maquina, planta_id, area, criticidad, estado, costo_hora_usd)
VALUES
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

INSERT INTO ordenes_produccion
    (orden_id, fecha, maquina_id, producto, turno, unidades_plan,
     unidades_reales, unidades_defectuosas, horas_operacion,
     costo_operacion_usd, estado)
WITH RECURSIVE n(i) AS (
    SELECT 1
    UNION ALL
    SELECT i + 1 FROM n WHERE i < 60
)
SELECT
    i,
    DATE_ADD('2026-08-01', INTERVAL MOD(i - 1, 30) DAY),
    MOD(i - 1, 10) + 1,
    CASE MOD(i, 6)
        WHEN 0 THEN 'Carcasa AX'
        WHEN 1 THEN 'Soporte BX'
        WHEN 2 THEN 'Engrane CX'
        WHEN 3 THEN 'Valvula DX'
        WHEN 4 THEN 'Panel EX'
        ELSE 'Eje FX'
    END,
    CASE MOD(i, 3) WHEN 0 THEN 'A' WHEN 1 THEN 'B' ELSE 'C' END,
    700 + MOD(i, 9) * 100,
    650 + MOD(i, 11) * 85,
    CASE WHEN MOD(i, 13) = 0 THEN 72 ELSE MOD(i * 7, 48) END,
    5.5 + MOD(i, 6) * 0.5,
    ROUND((5.5 + MOD(i, 6) * 0.5) *
          (90 + (MOD(i - 1, 10) + 1) * 14.5), 2),
    CASE
        WHEN MOD(i, 17) = 0 THEN 'Cancelada'
        WHEN MOD(i, 8) = 0 THEN 'En proceso'
        ELSE 'Completada'
    END
FROM n;

INSERT INTO paros
    (paro_id, fecha, maquina_id, tipo, minutos,
     costo_estimado_usd, responsable, comentario)
WITH RECURSIVE n(i) AS (
    SELECT 1
    UNION ALL
    SELECT i + 1 FROM n WHERE i < 36
)
SELECT
    i,
    DATE_ADD('2026-08-01', INTERVAL MOD(i * 2, 30) DAY),
    MOD(i * 3 - 1, 10) + 1,
    CASE MOD(i, 5)
        WHEN 0 THEN 'Falla'
        WHEN 1 THEN 'Cambio de modelo'
        WHEN 2 THEN 'Material'
        WHEN 3 THEN 'Calidad'
        ELSE 'Preventivo'
    END,
    15 + MOD(i, 8) * 20,
    ROUND((15 + MOD(i, 8) * 20) / 60.0 *
          (110 + (MOD(i * 3 - 1, 10) + 1) * 18), 2),
    CASE MOD(i, 4)
        WHEN 0 THEN 'Mantenimiento'
        WHEN 1 THEN 'Produccion'
        WHEN 2 THEN 'Calidad'
        ELSE 'Logistica'
    END,
    CASE
        WHEN MOD(i, 6) = 0 THEN NULL
        WHEN MOD(i, 2) = 0 THEN 'Requiere seguimiento'
        ELSE 'Evento cerrado'
    END
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
    ROUND(100.0 * o.unidades_reales / NULLIF(o.unidades_plan, 0), 2) AS cumplimiento_pct,
    ROUND(100.0 * o.unidades_defectuosas / NULLIF(o.unidades_reales, 0), 2) AS defectos_pct,
    o.horas_operacion,
    o.costo_operacion_usd,
    o.estado
FROM ordenes_produccion AS o
INNER JOIN maquinas AS m ON m.maquina_id = o.maquina_id
INNER JOIN plantas AS p ON p.planta_id = m.planta_id;

-- Verification: expected counts are 3, 10, 60 and 36.
SELECT 'plantas' AS objeto, COUNT(*) AS filas FROM plantas
UNION ALL
SELECT 'maquinas', COUNT(*) FROM maquinas
UNION ALL
SELECT 'ordenes_produccion', COUNT(*) FROM ordenes_produccion
UNION ALL
SELECT 'paros', COUNT(*) FROM paros;

