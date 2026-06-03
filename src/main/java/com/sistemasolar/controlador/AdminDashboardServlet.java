package com.sistemasolar.controlador;

import com.sistemasolar.dao.BitacoraDAO;
import com.sistemasolar.dao.PuntuacionDAO;
import com.sistemasolar.dao.UsuarioDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Página principal del panel de administrador: muestra un resumen
 * con la cantidad de usuarios, estudiantes, bloqueados y eventos.
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();
    private final PuntuacionDAO puntuacionDAO = new PuntuacionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("totalUsuarios",    usuarioDAO.contar(null, null));
            req.setAttribute("totalEstudiantes", usuarioDAO.contar("rol", "ESTUDIANTE"));
            req.setAttribute("totalBloqueados",  usuarioDAO.contar("estado", "BLOQUEADO"));
            req.setAttribute("totalBitacora",    bitacoraDAO.contar());
            req.setAttribute("totalPuntuaciones", puntuacionDAO.contar());
        } catch (Exception e) {
            req.setAttribute("error", "No se pudo cargar el resumen: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/vistas/admin/dashboard.jsp").forward(req, resp);
    }
}
