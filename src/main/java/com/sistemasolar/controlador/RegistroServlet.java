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
 * Procesa el registro de nuevos usuarios (perfil ESTUDIANTE).
 * Reglas: correo válido y contraseña de mínimo 8 caracteres.
 */
@WebServlet("/registrar")
public class RegistroServlet extends HttpServlet {

    private static final Pattern EMAIL =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/registro.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String nombre = limpiar(req.getParameter("nombre"));
        String email  = limpiar(req.getParameter("email"));
        String clave  = req.getParameter("clave")          == null ? "" : req.getParameter("clave");
        String clave2 = req.getParameter("claveConfirmar") == null ? "" : req.getParameter("claveConfirmar");

        String error = null;

        try {
            if (nombre.isEmpty() || email.isEmpty() || clave.isEmpty()) {
                error = "Todos los campos son obligatorios.";
            } else if (!EMAIL.matcher(email).matches()) {
                error = "Ingresa un correo electrónico válido.";
            } else if (clave.length() < 8) {
                error = "La contraseña debe tener al menos 8 caracteres.";
            } else if (!clave.equals(clave2)) {
                error = "Las contraseñas no coinciden.";
            } else if (usuarioDAO.emailExiste(email)) {
                error = "Ya existe una cuenta registrada con ese correo.";
            }

            if (error != null) {
                req.setAttribute("error", error);
                req.setAttribute("nombre", nombre);
                req.setAttribute("email", email);
                req.getRequestDispatcher("/registro.jsp").forward(req, resp);
                return;
            }

            Usuario u = new Usuario();
            u.setNombreCompleto(nombre);
            u.setEmail(email);
            u.setClave(clave);
            u.setRol("ESTUDIANTE");
            u.setEstado("ACTIVO");
            int id = usuarioDAO.registrar(u);

            // Se registra en la bitácora el nuevo usuario.
            bitacoraDAO.registrar(id, email, "REGISTRO",
                    "Nuevo estudiante registrado: " + nombre, req.getRemoteAddr());

            resp.sendRedirect(req.getContextPath() + "/login.jsp?registrado=1");

        } catch (Exception e) {
            req.setAttribute("error", "Ocurrió un error al registrar: " + e.getMessage());
            req.setAttribute("nombre", nombre);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
        }
    }

    private String limpiar(String s) {
        return s == null ? "" : s.trim();
    }
}
