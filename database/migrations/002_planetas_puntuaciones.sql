-- ================================================================
-- Migracion 002: normalizar puntuaciones por planeta
-- Ejecutar sobre una base ya existente conectada en pgAdmin.
-- Data Center: conectar a BD_cosmos y ejecutar en esquema public.
-- Si vas a empezar desde cero, usa database/sistema_solar.sql.
-- ================================================================

SET search_path TO public;

CREATE TABLE IF NOT EXISTS planetas (
    id          SERIAL       PRIMARY KEY,
    codigo      VARCHAR(30)  NOT NULL UNIQUE,
    nombre      VARCHAR(60)  NOT NULL UNIQUE,
    descripcion TEXT,
    estado      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO',
    orden       INTEGER      NOT NULL DEFAULT 0,
    CONSTRAINT chk_planeta_estado CHECK (estado IN ('ACTIVO','INACTIVO'))
);

INSERT INTO planetas (codigo, nombre, descripcion, orden) VALUES
  ('sun',     'Sol',      'Estrella central del Sistema Solar.', 0),
  ('mercury', 'Mercurio', 'Planeta rocoso mas cercano al Sol.', 1),
  ('venus',   'Venus',    'Planeta rocoso con atmosfera densa.', 2),
  ('earth',   'Tierra',   'Nuestro hogar: agua, vida y atmosfera protectora.', 3),
  ('mars',    'Marte',    'Planeta rojo con volcanes y antiguos valles.', 4),
  ('jupiter', 'Jupiter',  'Gigante gaseoso y planeta mas grande del sistema.', 5),
  ('saturn',  'Saturno',  'Gigante gaseoso conocido por sus anillos.', 6),
  ('uranus',  'Urano',    'Gigante de hielo con eje de rotacion inclinado.', 7),
  ('neptune', 'Neptuno',  'Gigante de hielo con vientos extremos.', 8),
  ('pluto',   'Pluton',   'Planeta enano del cinturon de Kuiper.', 9)
ON CONFLICT (codigo) DO UPDATE
SET nombre = EXCLUDED.nombre,
    descripcion = EXCLUDED.descripcion,
    orden = EXCLUDED.orden;

CREATE TABLE IF NOT EXISTS puntuaciones_planeta (
    id              SERIAL    PRIMARY KEY,
    planeta_id      INTEGER   NOT NULL REFERENCES planetas(id) ON DELETE CASCADE,
    usuario_id      INTEGER   NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    puntaje         INTEGER   NOT NULL DEFAULT 0,
    puntaje_maximo  INTEGER   NOT NULL DEFAULT 1,
    progreso        NUMERIC(5,2) NOT NULL DEFAULT 0,
    fecha_registro  TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_puntaje_valido CHECK (puntaje >= 0 AND puntaje_maximo > 0),
    CONSTRAINT uq_puntuacion_usuario_planeta UNIQUE (usuario_id, planeta_id)
);

CREATE OR REPLACE FUNCTION actualizar_fecha_puntuacion()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_actualizacion = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_actualizar_fecha_puntuacion ON puntuaciones_planeta;
CREATE TRIGGER trg_actualizar_fecha_puntuacion
BEFORE UPDATE ON puntuaciones_planeta
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_puntuacion();

-- Migrar datos antiguos si existe la tabla puntuaciones.
DO $$
BEGIN
    IF to_regclass('public.puntuaciones') IS NOT NULL THEN
        INSERT INTO puntuaciones_planeta (usuario_id, planeta_id, puntaje, puntaje_maximo, progreso, fecha_registro, fecha_actualizacion)
        SELECT old.usuario_id,
               p.id,
               old.puntaje,
               old.puntaje_maximo,
               ROUND((old.puntaje::numeric / GREATEST(old.puntaje_maximo, 1)) * 100, 2),
               old.fecha_hora,
               old.fecha_hora
        FROM puntuaciones old
        JOIN planetas p ON LOWER(p.nombre) = LOWER(old.planeta) OR LOWER(p.codigo) = LOWER(old.planeta)
        WHERE old.usuario_id IS NOT NULL
        ON CONFLICT (usuario_id, planeta_id) DO UPDATE
        SET puntaje = GREATEST(puntuaciones_planeta.puntaje, EXCLUDED.puntaje),
            puntaje_maximo = EXCLUDED.puntaje_maximo,
            progreso = GREATEST(puntuaciones_planeta.progreso, EXCLUDED.progreso),
            fecha_actualizacion = NOW();
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_planetas_estado_orden ON planetas (estado, orden);
CREATE INDEX IF NOT EXISTS idx_puntuaciones_planeta_ranking
    ON puntuaciones_planeta (planeta_id, puntaje DESC, fecha_actualizacion ASC);
CREATE INDEX IF NOT EXISTS idx_puntuaciones_usuario
    ON puntuaciones_planeta (usuario_id, planeta_id);
