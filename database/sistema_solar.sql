-- ================================================================
-- Script principal de base de datos
-- Proyecto: EduCosmos 4 / Sistema Solar - ODS 4
-- Motor: PostgreSQL
--
-- DATA CENTER:
--   Servidor pgAdmin: Server_Data_Center
--   Host/IP: 172.17.42.121
--   Puerto: 5432
--   Base: BD_cosmos
--   Usuario: postgres
--   Clave: 1234
--
-- IMPORTANTE:
--   Ejecutar este script estando conectado directamente a la base
--   actual, por ejemplo:
--     Server_Data_Center > Databases > BD_cosmos > Query Tool
--
--   Este archivo NO crea bases de datos y NO usa \c.
--   Crea/recrea las tablas en el esquema public de la base conectada.
-- ================================================================

CREATE SCHEMA IF NOT EXISTS public;
SET search_path TO public;

-- =================  LIMPIEZA  ===================================
-- Se usa CASCADE para permitir restaurar desde cero aunque existan
-- claves foraneas o dependencias anteriores.

DROP TABLE IF EXISTS public.puntuaciones_planeta CASCADE;
DROP TABLE IF EXISTS public.puntuaciones CASCADE;
DROP TABLE IF EXISTS public.bitacora CASCADE;
DROP TABLE IF EXISTS public.planetas CASCADE;
DROP TABLE IF EXISTS public.usuarios CASCADE;
DROP FUNCTION IF EXISTS public.actualizar_fecha_puntuacion() CASCADE;


-- =================  TABLAS  =====================================

-- ----- Usuarios: perfiles ADMIN y ESTUDIANTE ---------------------
CREATE TABLE public.usuarios (
    id              SERIAL       PRIMARY KEY,
    nombre_completo VARCHAR(120) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    clave           VARCHAR(255) NOT NULL,
    rol             VARCHAR(20)  NOT NULL DEFAULT 'ESTUDIANTE',
    estado          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO',
    fecha_registro  TIMESTAMP    NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_usuarios_rol
        CHECK (rol IN ('ADMIN','ESTUDIANTE')),
    CONSTRAINT chk_usuarios_estado
        CHECK (estado IN ('ACTIVO','BLOQUEADO'))
);

-- ----- Catalogo de planetas --------------------------------------
CREATE TABLE public.planetas (
    id          SERIAL       PRIMARY KEY,
    codigo      VARCHAR(30)  NOT NULL UNIQUE,
    nombre      VARCHAR(60)  NOT NULL UNIQUE,
    descripcion TEXT,
    estado      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO',
    orden       INTEGER      NOT NULL DEFAULT 0,
    CONSTRAINT chk_planetas_estado
        CHECK (estado IN ('ACTIVO','INACTIVO'))
);

-- ----- Puntuaciones por planeta ----------------------------------
CREATE TABLE public.puntuaciones_planeta (
    id                    SERIAL       PRIMARY KEY,
    usuario_id            INTEGER      NOT NULL REFERENCES public.usuarios(id) ON DELETE CASCADE,
    planeta_id            INTEGER      NOT NULL REFERENCES public.planetas(id) ON DELETE CASCADE,
    puntaje               INTEGER      NOT NULL DEFAULT 0,
    puntaje_maximo        INTEGER      NOT NULL DEFAULT 1,
    progreso              NUMERIC(5,2) NOT NULL DEFAULT 0,
    fecha_registro        TIMESTAMP    NOT NULL DEFAULT NOW(),
    fecha_actualizacion   TIMESTAMP    NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_puntuaciones_valores
        CHECK (puntaje >= 0 AND puntaje_maximo > 0 AND progreso >= 0),
    CONSTRAINT uq_puntuacion_usuario_planeta
        UNIQUE (usuario_id, planeta_id)
);

-- ----- Bitacora: eventos del sistema -----------------------------
CREATE TABLE public.bitacora (
    id          SERIAL       PRIMARY KEY,
    usuario_id  INTEGER      REFERENCES public.usuarios(id) ON DELETE SET NULL,
    email       VARCHAR(150),
    accion      VARCHAR(80)  NOT NULL,
    detalle     VARCHAR(255),
    ip          VARCHAR(45),
    fecha_hora  TIMESTAMP    NOT NULL DEFAULT NOW()
);


-- =================  TRIGGERS  ===================================

CREATE OR REPLACE FUNCTION public.actualizar_fecha_puntuacion()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_actualizacion = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_fecha_puntuacion
BEFORE UPDATE ON public.puntuaciones_planeta
FOR EACH ROW
EXECUTE FUNCTION public.actualizar_fecha_puntuacion();


-- =================  INDICES  =====================================

CREATE INDEX idx_usuarios_email
    ON public.usuarios (LOWER(email));

CREATE INDEX idx_bitacora_fecha
    ON public.bitacora (fecha_hora DESC);

CREATE INDEX idx_bitacora_usuario
    ON public.bitacora (usuario_id, fecha_hora DESC);

CREATE INDEX idx_planetas_estado_orden
    ON public.planetas (estado, orden);

CREATE INDEX idx_puntuaciones_planeta_ranking
    ON public.puntuaciones_planeta (planeta_id, puntaje DESC, fecha_actualizacion ASC);

CREATE INDEX idx_puntuaciones_usuario
    ON public.puntuaciones_planeta (usuario_id, planeta_id);


-- =================  DATOS INICIALES  ============================
-- Nota academica: las claves se guardan en texto plano para facilitar
-- revision directa durante la evaluacion del proyecto.

INSERT INTO public.usuarios (nombre_completo, email, clave, rol, estado)
VALUES ('admin', 'admin@gmail.com', 'Admin123', 'ADMIN', 'ACTIVO')
ON CONFLICT (email) DO UPDATE
SET nombre_completo = EXCLUDED.nombre_completo,
    clave = EXCLUDED.clave,
    rol = EXCLUDED.rol,
    estado = EXCLUDED.estado;

INSERT INTO public.planetas (codigo, nombre, descripcion, estado, orden) VALUES
  ('sun',     'Sol',      'Estrella central del Sistema Solar.', 'ACTIVO', 0),
  ('mercury', 'Mercurio', 'Planeta rocoso mas cercano al Sol.', 'ACTIVO', 1),
  ('venus',   'Venus',    'Planeta rocoso con atmosfera densa.', 'ACTIVO', 2),
  ('earth',   'Tierra',   'Nuestro hogar: agua, vida y atmosfera protectora.', 'ACTIVO', 3),
  ('mars',    'Marte',    'Planeta rojo con volcanes y antiguos valles.', 'ACTIVO', 4),
  ('jupiter', 'Jupiter',  'Gigante gaseoso y planeta mas grande del sistema.', 'ACTIVO', 5),
  ('saturn',  'Saturno',  'Gigante gaseoso conocido por sus anillos.', 'ACTIVO', 6),
  ('uranus',  'Urano',    'Gigante de hielo con eje de rotacion inclinado.', 'ACTIVO', 7),
  ('neptune', 'Neptuno',  'Gigante de hielo con vientos extremos.', 'ACTIVO', 8),
  ('pluto',   'Pluton',   'Planeta enano del cinturon de Kuiper.', 'ACTIVO', 9)
ON CONFLICT (codigo) DO UPDATE
SET nombre = EXCLUDED.nombre,
    descripcion = EXCLUDED.descripcion,
    estado = EXCLUDED.estado,
    orden = EXCLUDED.orden;

INSERT INTO public.bitacora (usuario_id, email, accion, detalle, ip)
SELECT u.id,
       u.email,
       'CONFIGURACION_INICIAL',
       'Administrador inicial creado o verificado para BD_cosmos',
       '127.0.0.1'
FROM public.usuarios u
WHERE LOWER(u.email) = LOWER('admin@gmail.com')
  AND NOT EXISTS (
      SELECT 1
      FROM public.bitacora b
      WHERE LOWER(b.email) = LOWER('admin@gmail.com')
        AND b.accion = 'CONFIGURACION_INICIAL'
  );


-- =================  CONSULTAS DE VERIFICACION  ==================
-- Ejecutar manualmente despues de restaurar si deseas comprobar datos:
--
-- SELECT * FROM public.usuarios;
-- SELECT * FROM public.planetas ORDER BY orden;
-- SELECT * FROM public.bitacora ORDER BY fecha_hora DESC;
--
-- Ranking por planeta:
-- SELECT u.nombre_completo AS alumno, u.email, pp.puntaje, pp.puntaje_maximo,
--        pp.progreso, pp.fecha_actualizacion
-- FROM public.puntuaciones_planeta pp
-- JOIN public.usuarios u ON u.id = pp.usuario_id
-- JOIN public.planetas p ON p.id = pp.planeta_id
-- WHERE p.codigo = 'earth'
-- ORDER BY pp.puntaje DESC, pp.fecha_actualizacion ASC;

