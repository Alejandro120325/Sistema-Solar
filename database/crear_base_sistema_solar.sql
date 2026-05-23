-- Ejecutar conectado a la base "postgres" como usuario postgres.
-- Usuario local: postgres
-- Clave local: root

CREATE DATABASE sistema_solar
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Luego conectate a la base sistema_solar y ejecuta:
-- database/sistema_solar.sql
