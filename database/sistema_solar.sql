-- ================================================================
--  BASE DE DATOS: Sistema Solar - Educacion de Calidad (ODS 4)
--  Motor: PostgreSQL
-- ================================================================
--  COMO USAR ESTE SCRIPT
--
--  PASO 1 - Crear la base de datos:
--     * En pgAdmin: clic derecho en "Databases" -> Create -> Database
--                   -> Database: sistema_solar -> Save
--     * O en la consola psql:   CREATE DATABASE sistema_solar;
--
--  PASO 2 - Conectarse a la base "sistema_solar" y ejecutar TODO
--           el resto de este script (desde la linea de abajo).
-- ================================================================

-- Si usas la consola psql puedes descomentar esta linea:
-- CREATE DATABASE sistema_solar;


-- =================  TABLAS  =====================================

-- Se eliminan primero por si el script se ejecuta nuevamente
DROP TABLE IF EXISTS puntuaciones;
DROP TABLE IF EXISTS bitacora;
DROP TABLE IF EXISTS usuarios;

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

-- ----- Tabla de puntuaciones (resultados de los minijuegos) ------
--  Guarda el puntaje que obtiene cada alumno al jugar el minijuego
--  de un planeta. Ejemplo: Tierra -> 5 de 8 puntos.
CREATE TABLE puntuaciones (
    id              SERIAL       PRIMARY KEY,
    usuario_id      INTEGER      REFERENCES usuarios(id) ON DELETE CASCADE,
    email           VARCHAR(150),
    planeta         VARCHAR(40)  NOT NULL,
    puntaje         INTEGER      NOT NULL,
    puntaje_maximo  INTEGER      NOT NULL,
    fecha_hora      TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- ----- Indices para acelerar las consultas -----------------------
CREATE INDEX idx_usuarios_email      ON usuarios (email);
CREATE INDEX idx_bitacora_fecha      ON bitacora (fecha_hora DESC);
CREATE INDEX idx_puntuaciones_usuario ON puntuaciones (usuario_id);


-- =================  DATOS INICIALES  ============================
--  Nota: en este proyecto academico las contrasenas se guardan en
--  TEXTO PLANO para poder revisarlas en la base de datos local.

-- ----- Usuario ADMINISTRADOR -------------------------------------
INSERT INTO usuarios (nombre_completo, email, clave, rol, estado)
VALUES ('admin', 'admin@gmail.com', 'Admin123', 'ADMIN', 'ACTIVO');

-- ----- Usuario ESTUDIANTE (persona de ejemplo) -------------------
INSERT INTO usuarios (nombre_completo, email, clave, rol, estado)
VALUES ('Valentina Rojas', 'valentina.rojas@gmail.com', 'Valentina123', 'ESTUDIANTE', 'ACTIVO');

-- ----- Eventos de ejemplo en la bitacora -------------------------
INSERT INTO bitacora (usuario_id, email, accion, detalle, ip) VALUES
  (1, 'admin@gmail.com',           'INICIO_SESION', 'Ingreso al sistema (ADMIN)',                  '127.0.0.1'),
  (2, 'valentina.rojas@gmail.com', 'REGISTRO',      'Nuevo estudiante registrado: Valentina Rojas','127.0.0.1');

-- ----- Puntuaciones de ejemplo -----------------------------------
INSERT INTO puntuaciones (usuario_id, email, planeta, puntaje, puntaje_maximo) VALUES
  (2, 'valentina.rojas@gmail.com', 'Tierra', 5, 8),
  (2, 'valentina.rojas@gmail.com', 'Sol',    4, 5);


-- =================  VERIFICACION  ===============================
SELECT id, nombre_completo, email, clave, rol, estado FROM usuarios ORDER BY id;

-- Puntuaciones: se veran como "planeta | puntaje | puntaje_maximo"
SELECT u.nombre_completo AS alumno, p.planeta, p.puntaje, p.puntaje_maximo, p.fecha_hora
FROM puntuaciones p
JOIN usuarios u ON u.id = p.usuario_id
ORDER BY p.fecha_hora DESC;
