package com.sistemasolar.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Entrega conexiones a la base de datos PostgreSQL.
 * Los datos de conexion se leen del archivo: src/main/resources/db.properties
 */
public class ConexionBD {

    private static String url;
    private static String usuario;
    private static String clave;

    // Bloque estatico: se ejecuta UNA sola vez al cargar la clase.
    static {
        try (InputStream in = ConexionBD.class.getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (in == null) {
                throw new RuntimeException("No se encontro el archivo db.properties");
            }
            Properties config = new Properties();
            config.load(in);

            url     = config.getProperty("db.url");
            usuario = config.getProperty("db.usuario");
            clave   = config.getProperty("db.clave");

            // Carga el driver JDBC de PostgreSQL.
            Class.forName("org.postgresql.Driver");

        } catch (Exception e) {
            throw new RuntimeException("Error al inicializar la conexion a la BD", e);
        }
    }

    /** Devuelve una nueva conexion a la base de datos. Recuerda cerrarla (try-with-resources). */
    public static Connection getConexion() throws SQLException {
        return DriverManager.getConnection(url, usuario, clave);
    }
}
