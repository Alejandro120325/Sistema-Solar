package com.sistemasolar.dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Entrega conexiones a la base de datos PostgreSQL.
 * Configuracion, de mayor a menor prioridad:
 * 1) Propiedades JVM o variables de entorno: db.url / DB_URL, db.user / DB_USER,
 *    db.password / DB_PASSWORD.
 * 2) Archivo externo: ${catalina.base}/conf/sistema-solar/database.properties
 *    o ruta indicada con -DsistemaSolar.db.config=...
 * 3) Archivo empaquetado: src/main/resources/db.properties.
 */
public class ConexionBD {

    private static String url;
    private static String usuario;
    private static String clave;

    // Bloque estatico: se ejecuta una sola vez al cargar la clase.
    static {
        try {
            Properties config = new Properties();

            cargarDesdeClasspath(config);
            cargarDesdeArchivoExterno(config);

            url = obtenerValor(config, "db.url", "DB_URL", null);
            usuario = obtenerValor(config, "db.user", "DB_USER", "db.usuario");
            clave = obtenerValor(config, "db.password", "DB_PASSWORD", "db.clave");

            validarConfiguracion();

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

    private static void cargarDesdeClasspath(Properties config) throws Exception {
        try (InputStream in = ConexionBD.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            if (in != null) {
                config.load(in);
            }
        }
    }

    private static void cargarDesdeArchivoExterno(Properties config) throws Exception {
        String ruta = System.getProperty("sistemaSolar.db.config");
        if (estaVacio(ruta)) {
            String catalinaBase = System.getProperty("catalina.base");
            if (!estaVacio(catalinaBase)) {
                ruta = catalinaBase + File.separator + "conf" + File.separator
                        + "sistema-solar" + File.separator + "database.properties";
            }
        }

        if (estaVacio(ruta)) {
            return;
        }

        File archivo = new File(ruta);
        if (archivo.isFile()) {
            try (InputStream in = new FileInputStream(archivo)) {
                config.load(in);
            }
        }
    }

    private static String obtenerValor(Properties config, String propiedad,
                                       String variableEntorno, String propiedadAlterna) {
        String valor = System.getProperty(propiedad);
        if (estaVacio(valor)) {
            valor = System.getenv(variableEntorno);
        }
        if (estaVacio(valor)) {
            valor = config.getProperty(propiedad);
        }
        if (estaVacio(valor) && propiedadAlterna != null) {
            valor = config.getProperty(propiedadAlterna);
        }
        return valor == null ? null : valor.trim();
    }

    private static void validarConfiguracion() {
        if (estaVacio(url) || estaVacio(usuario) || clave == null) {
            throw new IllegalStateException("Configuracion de BD incompleta. "
                    + "Revisa db.url, db.user y db.password.");
        }
    }

    private static boolean estaVacio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}
