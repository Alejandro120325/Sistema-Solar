package com.sistemasolar.controlador;

import com.sistemasolar.dao.BitacoraDAO;
import com.sistemasolar.dao.UsuarioDAO;
import com.sistemasolar.modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Procesa el inicio de sesión. Usa HttpSession para mantener al usuario
 * autenticado. Los usuarios BLOQUEADOS no pueden ingresar.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email") == null ? "" : req.getParameter("email").trim();
        String clave = req.getParameter("clave") == null ? "" : req.getParameter("clave");

        String error = null;

        try {
            if (email.isEmpty() || clave.isEmpty()) {
                error = "Ingresa tu correo y contraseña.";
            } else {
                Usuario u = usuarioDAO.validarCredenciales(email, clave);

                if (u == null) {
                    error = "Correo o contraseña incorrectos.";
                } else if (u.isBloqueado()) {
                    error = "Tu cuenta está bloqueada. Contacta con el administrador.";
                    bitacoraDAO.registrar(u.getId(), email, "ACCESO_DENEGADO",
                            "Intento de ingreso de cuenta bloqueada", req.getRemoteAddr());
                } else {
                    // Login correcto: se crea la sesión.
                    HttpSession sesion = req.getSession(true);
                    sesion.setAttribute("usuario", u);

                    bitacoraDAO.registrar(u.getId(), email, "INICIO_SESION",
                            "Ingreso al sistema (" + u.getRol() + ")", req.getRemoteAddr());

                    if (u.isAdmin()) {
                        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/index.jsp?sesion=1");
                    }
                    return;
                }
            }
        } catch (Exception e) {
            error = "Error en el servidor: " + e.getMessage();
        }

        req.setAttribute("error", error);
        req.setAttribute("email", email);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
