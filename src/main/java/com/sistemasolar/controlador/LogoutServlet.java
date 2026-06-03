package com.sistemasolar.controlador;

import com.sistemasolar.dao.BitacoraDAO;
import com.sistemasolar.modelo.Usuario;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Cierra la sesión del usuario y lo devuelve a la página de inicio.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession sesion = req.getSession(false);
        if (sesion != null) {
            Usuario u = (Usuario) sesion.getAttribute("usuario");
            if (u != null) {
                bitacoraDAO.registrar(u.getId(), u.getEmail(), "CIERRE_SESION",
                        "El usuario cerró sesión", req.getRemoteAddr());
            }
            sesion.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}
