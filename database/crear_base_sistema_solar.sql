-- ================================================================
-- Crear base de datos para Sistema Solar
-- Ejecutar conectado a la base "postgres" con un usuario que tenga
-- permiso CREATEDB.
--
-- Local:
--   usuario: postgres
--   clave: root
--
-- VM 172.17.42.138:
--   usuario: postgres
--   clave: 1234
--
-- Servidor docente:
--   usar las credenciales entregadas para PostgreSQL.
--
-- Nota:
--   PostgreSQL no soporta CREATE DATABASE IF NOT EXISTS.
--   Si la base sistema_solar ya existe, no ejecutes este archivo
--   otra vez; entra directamente a sistema_solar y ejecuta
--   database/sistema_solar.sql.
-- ================================================================

CREATE DATABASE sistema_solar
    WITH
    ENCODING = 'UTF8'
    TEMPLATE = template0
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Luego conectate a la base sistema_solar y ejecuta:
-- database/sistema_solar.sql
