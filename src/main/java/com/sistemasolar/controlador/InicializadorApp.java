package com.sistemasolar.controlador;

import com.sistemasolar.dao.UsuarioDAO;
import com.sistemasolar.modelo.Usuario;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * Se ejecuta automaticamente cuando arranca la aplicacion en Tomcat.
 * Si todavia no existe un administrador, lo crea con credenciales por
 * defecto para que siempre se pueda entrar al panel.
 *
 *   Administrador por defecto:
 *       email: admin@sistemasolar.com
 *       clave: admin12345
 */
@WebListener
public class InicializadorApp implements ServletContextListener {

    private static final String ADMIN_EMAIL = "admin@sistemasolar.com";
    private static final String ADMIN_CLAVE = "admin12345";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            UsuarioDAO dao = new UsuarioDAO();
            if (!dao.emailExiste(ADMIN_EMAIL)) {
                Usuario admin = new Usuario();
                admin.setNombreCompleto("Administrador del Sistema");
                admin.setEmail(ADMIN_EMAIL);
                admin.setClave(ADMIN_CLAVE);
                admin.setRol("ADMIN");
                admin.setEstado("ACTIVO");
                dao.registrar(admin);
                System.out.println(">> [Sistema Solar] Administrador creado: "
                        + ADMIN_EMAIL + " / " + ADMIN_CLAVE);
            } else {
                System.out.println(">> [Sistema Solar] Administrador ya existe. Todo listo.");
            }
        } catch (Exception e) {
            System.err.println(">> [Sistema Solar] AVISO: no se pudo verificar el administrador.");
            System.err.println(">> Verifica que PostgreSQL este encendido y que hayas ejecutado");
            System.err.println(">> el script database/sistema_solar.sql.");
            System.err.println(">> Detalle: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Sin acciones al detener la aplicacion.
    }
}
