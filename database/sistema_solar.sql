-- ================================================================
--  BASE DE DATOS: Sistema Solar - Educacion de Calidad (ODS 4)
--  Motor: PostgreSQL 12 o superior
-- ================================================================
--  COMO USAR ESTE SCRIPT (local):
--    1) Abre pgAdmin o la consola psql.
--    2) Crea la base de datos:   CREATE DATABASE sistema_solar;
--    3) Conectate a "sistema_solar" y ejecuta TODO este script.
--
--  COMO RESTAURAR EN EL SERVIDOR (172.17.42.121):
--    - Crea la base "sistema_solar" y ejecuta este script, o bien
--    - Restaura el respaldo .backup/.sql que generes con pg_dump.
-- ================================================================

-- Se eliminan primero por si el script se ejecuta de nuevo --------
DROP TABLE IF EXISTS bitacora;
DROP TABLE IF EXISTS usuarios;

-- ================================================================
--  TABLA: usuarios
--  Guarda los 3 perfiles. El "invitado" NO se guarda (es quien
--  navega sin iniciar sesion).
-- ================================================================
CREATE TABLE usuarios (
    id              SERIAL       PRIMARY KEY,
    nombre_completo VARCHAR(120) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    clave           VARCHAR(255) NOT NULL,                  -- hash BCrypt (~60 caracteres)
    rol             VARCHAR(20)  NOT NULL DEFAULT 'ESTUDIANTE',
    estado          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO',
    fecha_registro  TIMESTAMP    NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_rol    CHECK (rol    IN ('ADMIN','ESTUDIANTE')),
    CONSTRAINT chk_estado CHECK (estado IN ('ACTIVO','BLOQUEADO'))
);

-- ================================================================
--  TABLA: bitacora
--  Registra los eventos: nuevos registros, inicios de sesion e
--  interacciones de los estudiantes con el sistema.
-- ================================================================
CREATE TABLE bitacora (
    id          SERIAL       PRIMARY KEY,
    usuario_id  INTEGER      REFERENCES usuarios(id) ON DELETE SET NULL,
    email       VARCHAR(150),
    accion      VARCHAR(80)  NOT NULL,
    detalle     VARCHAR(255),
    ip          VARCHAR(45),
    fecha_hora  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Indices para acelerar las consultas mas frecuentes -------------
CREATE INDEX idx_usuarios_email ON usuarios (email);
CREATE INDEX idx_bitacora_fecha ON bitacora (fecha_hora DESC);

-- ================================================================
--  USUARIO ADMINISTRADOR
--  La aplicacion crea automaticamente el administrador la primera
--  vez que arranca (ver clase InicializadorApp.java), con:
--        email: admin@sistemasolar.com
--        clave: admin12345
--
--  No hace falta insertarlo aqui. Si igual quieres crearlo por SQL,
--  necesitas el hash BCrypt de la clave (no se puede poner en texto
--  plano porque la app compara contra un hash).
-- ================================================================
