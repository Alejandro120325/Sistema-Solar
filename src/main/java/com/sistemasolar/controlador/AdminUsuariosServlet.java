package com.sistemasolar.controlador;

import com.sistemasolar.dao.BitacoraDAO;
import com.sistemasolar.dao.UsuarioDAO;
import com.sistemasolar.modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;

/**
 * Gestion de usuarios para el administrador: listar, crear, actualizar,
 * bloquear/activar y eliminar. Cada accion queda en la bitacora.
 */
@WebServlet("/admin/usuarios")
public class AdminUsuariosServlet extends HttpServlet {

    private static final String VISTA_LISTA = "/WEB-INF/vistas/admin/usuarios.jsp";
    private static final String VISTA_FORM  = "/WEB-INF/vistas/admin/usuario-form.jsp";
    private static final Pattern EMAIL =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();

    /** Maneja: listar, mostrar formulario, bloquear, activar y eliminar. */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");

        try {
            if ("nuevo".equals(accion)) {
                req.getRequestDispatcher(VISTA_FORM).forward(req, resp);
                return;
            }
            if ("editar".equals(accion)) {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("usuario", usuarioDAO.buscarPorId(id));
                req.getRequestDispatcher(VISTA_FORM).forward(req, resp);
                return;
            }
            if ("bloquear".equals(accion) || "activar".equals(accion)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String estado = "bloquear".equals(accion) ? "BLOQUEADO" : "ACTIVO";
                usuarioDAO.cambiarEstado(id, estado);
                Usuario afectado = usuarioDAO.buscarPorId(id);
                registrarAccion(req,
                        "bloquear".equals(accion) ? "BLOQUEO_USUARIO" : "ACTIVACION_USUARIO",
                        "Usuario " + (afectado != null ? afectado.getEmail() : id) + " -> " + estado);
                resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
                return;
            }
            if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Usuario afectado = usuarioDAO.buscarPorId(id);
                usuarioDAO.eliminar(id);
                registrarAccion(req, "ELIMINACION_USUARIO",
                        "Usuario eliminado: " + (afectado != null ? afectado.getEmail() : id));
                resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
                return;
            }

            // Sin accion: se muestra la lista de usuarios.
            req.setAttribute("usuarios", usuarioDAO.listarTodos());
            req.getRequestDispatcher(VISTA_LISTA).forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            try {
                req.setAttribute("usuarios", usuarioDAO.listarTodos());
            } catch (Exception ignore) {
                // si ni siquiera se puede listar, se muestra solo el error
            }
            req.getRequestDispatcher(VISTA_LISTA).forward(req, resp);
        }
    }

    /** Maneja el guardado del formulario: crea o actualiza un usuario. */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String idParam = req.getParameter("id");
        String nombre  = limpiar(req.getParameter("nombre"));
        String email   = limpiar(req.getParameter("email"));
        String clave   = req.getParameter("clave");
        String rol     = req.getParameter("rol");
        String estado  = req.getParameter("estado");

        boolean esNuevo = idParam == null || idParam.trim().isEmpty() || "0".equals(idParam.trim());

        try {
            if (nombre.isEmpty() || email.isEmpty() || rol == null || estado == null) {
                throw new IllegalArgumentException("Completa todos los campos obligatorios.");
            }
            if (!EMAIL.matcher(email).matches()) {
                throw new IllegalArgumentException("Ingresa un correo electronico valido.");
            }
            if (!"ADMIN".equals(rol) && !"ESTUDIANTE".equals(rol)) {
                throw new IllegalArgumentException("Rol no valido.");
            }
            if (!"ACTIVO".equals(estado) && !"BLOQUEADO".equals(estado)) {
                throw new IllegalArgumentException("Estado no valido.");
            }

            if (esNuevo) {
                if (clave == null || clave.length() < 8) {
                    throw new IllegalArgumentException("La contrasena debe tener al menos 8 caracteres.");
                }
                if (usuarioDAO.emailExiste(email)) {
                    throw new IllegalArgumentException("Ya existe un usuario con ese correo.");
                }
                Usuario u = new Usuario();
                u.setNombreCompleto(nombre);
                u.setEmail(email);
                u.setClave(clave);
                u.setRol(rol);
                u.setEstado(estado);
                usuarioDAO.registrar(u);
                registrarAccion(req, "CREACION_USUARIO",
                        "Admin creo el usuario: " + email + " (" + rol + ")");
            } else {
                int id = Integer.parseInt(idParam.trim());
                if (usuarioDAO.emailExisteParaOtro(email, id)) {
                    throw new IllegalArgumentException("Ya existe otro usuario con ese correo.");
                }
                Usuario u = new Usuario();
                u.setId(id);
                u.setNombreCompleto(nombre);
                u.setEmail(email);
                u.setRol(rol);
                u.setEstado(estado);
                usuarioDAO.actualizar(u);

                // La contrasena solo se cambia si el admin escribio una nueva.
                if (clave != null && !clave.isEmpty()) {
                    if (clave.length() < 8) {
                        throw new IllegalArgumentException("La nueva contrasena debe tener al menos 8 caracteres.");
                    }
                    usuarioDAO.actualizarClave(id, clave);
                }
                registrarAccion(req, "ACTUALIZACION_USUARIO",
                        "Admin actualizo el usuario: " + email);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");

        } catch (Exception e) {
            // Se vuelve a mostrar el formulario con el error y los datos escritos.
            req.setAttribute("error", e.getMessage());
            Usuario form = new Usuario();
            if (!esNuevo) {
                try { form.setId(Integer.parseInt(idParam.trim())); } catch (Exception ignore) { }
            }
            form.setNombreCompleto(nombre);
            form.setEmail(email);
            form.setRol(rol);
            form.setEstado(estado);
            req.setAttribute("usuario", form);
            req.getRequestDispatcher(VISTA_FORM).forward(req, resp);
        }
    }

    /** Registra en la bitacora una accion realizada por el administrador. */
    private void registrarAccion(HttpServletRequest req, String accion, String detalle) {
        Usuario admin = (Usuario) req.getSession().getAttribute("usuario");
        Integer adminId = admin != null ? admin.getId() : null;
        String adminEmail = admin != null ? admin.getEmail() : null;
        bitacoraDAO.registrar(adminId, adminEmail, accion, detalle, req.getRemoteAddr());
    }

    private String limpiar(String s) {
        return s == null ? "" : s.trim();
    }
}
