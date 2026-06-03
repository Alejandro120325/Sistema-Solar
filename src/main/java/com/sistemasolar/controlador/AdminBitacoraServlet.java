package com.sistemasolar.controlador;

import com.sistemasolar.dao.BitacoraDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Muestra la bitácora completa del sistema para el administrador:
 * registros de usuarios nuevos, inicios de sesión e interacciones.
 */
@WebServlet("/admin/bitacora")
public class AdminBitacoraServlet extends HttpServlet {

    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("eventos", bitacoraDAO.listarTodas());
        } catch (Exception e) {
            req.setAttribute("error", "No se pudo cargar la bitácora: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/vistas/admin/bitacora.jsp").forward(req, resp);
    }
}
