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
 * Recibe (por fetch desde el explorador 3D) las interacciones del
 * estudiante y las guarda en la bitácora. Así el administrador puede
 * revisar qué hizo cada estudiante dentro del sistema.
 */
@WebServlet("/interaccion")
public class InteraccionServlet extends HttpServlet {

    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession sesion = req.getSession(false);
        if (sesion == null || sesion.getAttribute("usuario") == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Usuario u = (Usuario) sesion.getAttribute("usuario");
        String accion = normalizarAccion(req.getParameter("accion"));
        String detalle = req.getParameter("detalle");
        if (detalle == null || detalle.trim().isEmpty()) {
            detalle = "Interacción en el sistema";
        }

        bitacoraDAO.registrar(u.getId(), u.getEmail(), accion,
                detalle, req.getRemoteAddr());

        resp.setStatus(HttpServletResponse.SC_NO_CONTENT); // 204: registrado, sin cuerpo
    }

    private String normalizarAccion(String accion) {
        if (accion == null || accion.trim().isEmpty()) {
            return "INTERACCION";
        }

        String valor = accion.trim().toUpperCase();
        switch (valor) {
            case "INGRESO_EXPLORADOR":
            case "INGRESO_REALIDAD_AUMENTADA":
            case "INGRESO_MULTIMEDIA":
            case "INTERACCION":
                return valor;
            default:
                return "INTERACCION";
        }
    }
}
