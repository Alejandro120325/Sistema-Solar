-- ================================================================
-- Crear base de datos para pruebas locales o VM
-- Proyecto: EduCosmos 4 / Sistema Solar
-- Motor: PostgreSQL
-- ================================================================
--
-- ESCENARIO LOCAL / VM
-- Ejecutar este archivo conectado a la base "postgres" con un usuario
-- que tenga permiso CREATEDB.
--
-- PC local:
--   host: localhost
--   puerto: 5432
--   usuario: postgres
--   clave: root
--   base a crear: sistema_solar
--
-- VM local:
--   host: localhost
--   puerto: 5432
--   usuario: postgres
--   clave: 1234
--   base a crear: sistema_solar
--
-- Luego conectarse a "sistema_solar" y ejecutar:
--   database/sistema_solar.sql
--
-- ESCENARIO DATA CENTER
-- La base final ya existe y se llama:
--   BD_cosmos
--
-- En Data Center NO ejecutes CREATE DATABASE.
-- En pgAdmin entra a:
--   Server_Data_Center > Databases > BD_cosmos
--
-- Luego abre Query Tool conectado a BD_cosmos y ejecuta:
--   database/sistema_solar.sql
-- ================================================================

CREATE DATABASE sistema_solar
    WITH
    ENCODING = 'UTF8'
    TEMPLATE = template0
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

