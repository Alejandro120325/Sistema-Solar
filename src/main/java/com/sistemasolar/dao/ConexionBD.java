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
 * 1) Archivo externo: ${catalina.base}/conf/sistema-solar/database.properties
 *    o ruta indicada con -DsistemaSolar.db.config=...
 * 2) Propiedades JVM o variables de entorno: db.url / DB_URL, db.user / DB_USER,
 *    db.password / DB_PASSWORD.
 * 3) Archivo empaquetado: src/main/resources/db.properties.
 * 4) Valores locales por defecto para desarrollo.
 */
public class ConexionBD {

    private static String url;
    private static String usuario;
    private static String clave;

    // Bloque estatico: se ejecuta una sola vez al cargar la clase.
    static {
        try {
            Properties config = new Properties();

            boolean archivoExternoCargado = cargarDesdeArchivoExterno(config);
            if (!archivoExternoCargado) {
                System.out.println("[DB] No se encontró configuración externa. Usando configuración por defecto.");
                cargarDesdeClasspath(config);
                cargarValoresLocalesPorDefecto(config);
                cargarSobrescriturasSistema(config);
            }

            url = obtenerValor(config, "db.url", null);
            usuario = obtenerValor(config, "db.user", "db.usuario");
            clave = obtenerValor(config, "db.password", "db.clave");

            validarConfiguracion();
            imprimirConfiguracion();

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

    private static boolean cargarDesdeArchivoExterno(Properties config) throws Exception {
        String ruta = System.getProperty("sistemaSolar.db.config");
        if (estaVacio(ruta)) {
            String catalinaBase = System.getProperty("catalina.base");
            if (!estaVacio(catalinaBase)) {
                ruta = catalinaBase + File.separator + "conf" + File.separator
                        + "sistema-solar" + File.separator + "database.properties";
            }
        }

        if (estaVacio(ruta)) {
            System.out.println("[DB] Leyendo configuración desde: <sin catalina.base>");
            System.out.println("[DB] Archivo existe: false");
            return false;
        }

        File archivo = new File(ruta);
        System.out.println("[DB] Leyendo configuración desde: " + archivo.getAbsolutePath());
        System.out.println("[DB] Archivo existe: " + archivo.isFile());

        if (archivo.isFile()) {
            try (InputStream in = new FileInputStream(archivo)) {
                config.load(in);
            }
            return true;
        }
        return false;
    }

    private static void cargarSobrescriturasSistema(Properties config) {
        sobrescribirSiExiste(config, "db.url", "DB_URL");
        sobrescribirSiExiste(config, "db.user", "DB_USER");
        sobrescribirSiExiste(config, "db.password", "DB_PASSWORD");
    }

    private static void sobrescribirSiExiste(Properties config, String propiedad, String variableEntorno) {
        String valor = System.getProperty(propiedad);
        if (estaVacio(valor)) {
            valor = System.getenv(variableEntorno);
        }
        if (!estaVacio(valor)) {
            config.setProperty(propiedad, valor.trim());
        }
    }

    private static void cargarValoresLocalesPorDefecto(Properties config) {
        config.putIfAbsent("db.url", "jdbc:postgresql://localhost:5432/sistema_solar");
        config.putIfAbsent("db.user", "postgres");
        config.putIfAbsent("db.password", "root");
    }

    private static String obtenerValor(Properties config, String propiedad, String propiedadAlterna) {
        String valor = config.getProperty(propiedad);
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

    private static void imprimirConfiguracion() {
        System.out.println("[DB] URL: " + url);
        System.out.println("[DB] USER: " + usuario);
        System.out.println("[DB] PASSWORD cargada: " + (estaVacio(clave) ? "no" : "sí"));
    }

    private static boolean estaVacio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}
