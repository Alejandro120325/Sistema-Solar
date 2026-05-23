package com.sistemasolar.controlador;

import com.sistemasolar.dao.PuntuacionDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Muestra al administrador todas las puntuaciones que los alumnos
 * han obtenido en los minijuegos de los planetas.
 */
@WebServlet("/admin/puntuaciones")
public class AdminPuntuacionesServlet extends HttpServlet {

    private final PuntuacionDAO puntuacionDAO = new PuntuacionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String planeta = req.getParameter("planeta");
            req.setAttribute("planetas", puntuacionDAO.listarPlanetas());
            req.setAttribute("planetaSeleccionado", planeta == null ? "" : planeta);
            req.setAttribute("puntuaciones",
                    planeta == null || planeta.trim().isEmpty()
                            ? puntuacionDAO.listarTodas()
                            : puntuacionDAO.rankingPorPlaneta(planeta));
        } catch (Exception e) {
            req.setAttribute("error", "No se pudo cargar las puntuaciones: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/vistas/admin/puntuaciones.jsp").forward(req, resp);
    }
}
