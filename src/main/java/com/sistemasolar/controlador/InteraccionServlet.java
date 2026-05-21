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
 * estudiante y las guarda en la bitacora. Asi el administrador puede
 * revisar que hizo cada estudiante dentro del sistema.
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
        String detalle = req.getParameter("detalle");
        if (detalle == null || detalle.trim().isEmpty()) {
            detalle = "Interaccion en el explorador del Sistema Solar";
        }

        bitacoraDAO.registrar(u.getId(), u.getEmail(), "INTERACCION",
                detalle, req.getRemoteAddr());

        resp.setStatus(HttpServletResponse.SC_NO_CONTENT); // 204: registrado, sin cuerpo
    }
}
