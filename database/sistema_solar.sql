-- ================================================================
--  BASE DE DATOS: Sistema Solar - Educacion de Calidad (ODS 4)
--  Motor: PostgreSQL
--  Usuario local sugerido: postgres
--  Clave local sugerida: root
-- ================================================================
--
--  OPCION A - Desde pgAdmin:
--     1. Crear database: sistema_solar
--     2. Abrir Query Tool conectado a sistema_solar
--     3. Ejecutar desde la seccion "TABLAS" hacia abajo
--
--  OPCION B - Desde psql como usuario postgres:
--     psql -U postgres -c "CREATE DATABASE sistema_solar;"
--     psql -U postgres -d sistema_solar -f database/sistema_solar.sql
--
--  IMPORTANTE:
--  PostgreSQL no permite CREATE DATABASE dentro de una transaccion.
--  Por eso la linea siguiente queda comentada para pgAdmin.
-- ================================================================

-- CREATE DATABASE sistema_solar;


-- =================  TABLAS  =====================================

DROP TABLE IF EXISTS puntuaciones_planeta CASCADE;
DROP TABLE IF EXISTS puntuaciones CASCADE;
DROP TABLE IF EXISTS bitacora CASCADE;
DROP TABLE IF EXISTS planetas CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- ----- Tabla de usuarios (perfiles ADMIN y ESTUDIANTE) -----------
CREATE TABLE usuarios (
    id              SERIAL       PRIMARY KEY,
    nombre_completo VARCHAR(120) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    clave           VARCHAR(255) NOT NULL,
    rol             VARCHAR(20)  NOT NULL DEFAULT 'ESTUDIANTE',
    estado          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO',
    fecha_registro  TIMESTAMP    NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_rol    CHECK (rol    IN ('ADMIN','ESTUDIANTE')),
    CONSTRAINT chk_estado CHECK (estado IN ('ACTIVO','BLOQUEADO'))
);

-- ----- Catalogo de planetas --------------------------------------
CREATE TABLE planetas (
    id          SERIAL       PRIMARY KEY,
    codigo      VARCHAR(30)  NOT NULL UNIQUE,
    nombre      VARCHAR(60)  NOT NULL UNIQUE,
    descripcion TEXT,
    estado      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO',
    orden       INTEGER      NOT NULL DEFAULT 0,
    CONSTRAINT chk_planeta_estado CHECK (estado IN ('ACTIVO','INACTIVO'))
);

-- ----- Puntuaciones por planeta ----------------------------------
--  Un usuario puede tener puntuacion en varios planetas.
--  Un planeta puede tener puntuaciones de muchos usuarios.
--  Se evita duplicar resultados del mismo usuario en el mismo planeta:
--  si vuelve a jugar, se actualiza su mejor/ultimo resultado.
CREATE TABLE puntuaciones_planeta (
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

CREATE TRIGGER trg_actualizar_fecha_puntuacion
BEFORE UPDATE ON puntuaciones_planeta
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_puntuacion();

-- ----- Tabla de bitacora (registro de eventos) -------------------
CREATE TABLE bitacora (
    id          SERIAL       PRIMARY KEY,
    usuario_id  INTEGER      REFERENCES usuarios(id) ON DELETE SET NULL,
    email       VARCHAR(150),
    accion      VARCHAR(80)  NOT NULL,
    detalle     VARCHAR(255),
    ip          VARCHAR(45),
    fecha_hora  TIMESTAMP    NOT NULL DEFAULT NOW()
);


-- =================  INDICES  =====================================

CREATE INDEX idx_usuarios_email ON usuarios (LOWER(email));
CREATE INDEX idx_bitacora_fecha ON bitacora (fecha_hora DESC);
CREATE INDEX idx_planetas_estado_orden ON planetas (estado, orden);
CREATE INDEX idx_puntuaciones_planeta_ranking
    ON puntuaciones_planeta (planeta_id, puntaje DESC, fecha_actualizacion ASC);
CREATE INDEX idx_puntuaciones_usuario
    ON puntuaciones_planeta (usuario_id, planeta_id);


-- =================  DATOS INICIALES  ============================
--  Nota academica: las contrasenas se guardan en texto plano para
--  facilitar revision directa en PostgreSQL.

INSERT INTO usuarios (nombre_completo, email, clave, rol, estado) VALUES
  ('admin',            'admin@gmail.com',              'Admin123',      'ADMIN',      'ACTIVO'),
  ('Valentina Rojas',  'valentina.rojas@gmail.com',    'Valentina123',  'ESTUDIANTE', 'ACTIVO');

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
  ('pluto',   'Pluton',   'Planeta enano del cinturon de Kuiper.', 9);

INSERT INTO puntuaciones_planeta (usuario_id, planeta_id, puntaje, puntaje_maximo, progreso)
SELECT u.id, p.id, 5, 8, 62.50
FROM usuarios u, planetas p
WHERE u.email = 'valentina.rojas@gmail.com' AND p.codigo = 'earth';

INSERT INTO puntuaciones_planeta (usuario_id, planeta_id, puntaje, puntaje_maximo, progreso)
SELECT u.id, p.id, 4, 5, 80.00
FROM usuarios u, planetas p
WHERE u.email = 'valentina.rojas@gmail.com' AND p.codigo = 'sun';

INSERT INTO bitacora (usuario_id, email, accion, detalle, ip) VALUES
  (1, 'admin@gmail.com',           'INICIO_SESION', 'Ingreso al sistema (ADMIN)',                  '127.0.0.1'),
  (2, 'valentina.rojas@gmail.com', 'REGISTRO',      'Nuevo estudiante registrado: Valentina Rojas','127.0.0.1');


-- =================  CONSULTAS UTILES  ===========================

-- Obtener todos los planetas activos
SELECT id, codigo, nombre, descripcion, estado
FROM planetas
WHERE estado = 'ACTIVO'
ORDER BY orden;

-- Obtener usuarios y puntuaciones por planeta
SELECT p.nombre AS planeta, u.nombre_completo AS alumno, u.email,
       pp.puntaje, pp.puntaje_maximo, pp.progreso, pp.fecha_actualizacion
FROM puntuaciones_planeta pp
JOIN planetas p ON p.id = pp.planeta_id
JOIN usuarios u ON u.id = pp.usuario_id
ORDER BY p.orden, pp.puntaje DESC;

-- Ranking de un planeta por codigo, ordenado por puntuacion descendente
SELECT u.nombre_completo AS alumno, u.email, pp.puntaje, pp.puntaje_maximo,
       pp.progreso, pp.fecha_actualizacion
FROM puntuaciones_planeta pp
JOIN usuarios u ON u.id = pp.usuario_id
JOIN planetas p ON p.id = pp.planeta_id
WHERE p.codigo = 'earth'
ORDER BY pp.puntaje DESC, pp.fecha_actualizacion ASC;

-- Puntuacion de un alumno especifico dentro de un planeta
SELECT p.nombre AS planeta, u.email, pp.puntaje, pp.puntaje_maximo,
       pp.progreso, pp.fecha_actualizacion
FROM puntuaciones_planeta pp
JOIN planetas p ON p.id = pp.planeta_id
JOIN usuarios u ON u.id = pp.usuario_id
WHERE p.codigo = 'earth'
  AND LOWER(u.email) = LOWER('valentina.rojas@gmail.com');
