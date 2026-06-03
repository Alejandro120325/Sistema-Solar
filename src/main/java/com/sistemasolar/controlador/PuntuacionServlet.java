package com.sistemasolar.controlador;

import com.sistemasolar.dao.BitacoraDAO;
import com.sistemasolar.dao.PuntuacionDAO;
import com.sistemasolar.modelo.Puntuacion;
import com.sistemasolar.modelo.Usuario;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.Normalizer;
import java.util.HashMap;
import java.util.Map;

/**
 * Recibe (por fetch desde los minijuegos del explorador 3D) el puntaje
 * que obtuvo el alumno y lo guarda en la tabla "puntuaciones_planeta".
 * También deja constancia del resultado en la bitácora.
 */
@WebServlet("/puntuacion")
public class PuntuacionServlet extends HttpServlet {

    private final PuntuacionDAO puntuacionDAO = new PuntuacionDAO();
    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();
    private static final Map<String, String> CODIGOS_PLANETA = new HashMap<>();

    static {
        CODIGOS_PLANETA.put("sol", "sun");
        CODIGOS_PLANETA.put("mercurio", "mercury");
        CODIGOS_PLANETA.put("venus", "venus");
        CODIGOS_PLANETA.put("tierra", "earth");
        CODIGOS_PLANETA.put("marte", "mars");
        CODIGOS_PLANETA.put("jupiter", "jupiter");
        CODIGOS_PLANETA.put("saturno", "saturn");
        CODIGOS_PLANETA.put("urano", "uranus");
        CODIGOS_PLANETA.put("neptuno", "neptune");
        CODIGOS_PLANETA.put("pluton", "pluto");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession sesion = req.getSession(false);
        if (sesion == null || sesion.getAttribute("usuario") == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        Usuario u = (Usuario) sesion.getAttribute("usuario");

        String planeta = req.getParameter("planeta");
        int puntaje, maximo;
        try {
            puntaje = Integer.parseInt(req.getParameter("puntaje"));
            maximo  = Integer.parseInt(req.getParameter("maximo"));
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        if (planeta == null || planeta.trim().isEmpty()) planeta = "Desconocido";
        if (puntaje < 0) puntaje = 0;
        if (maximo  < 1) maximo  = 1;

        String codigoPlaneta = normalizarPlaneta(planeta);

        // 1) Se guarda en la tabla de puntuaciones
        puntuacionDAO.registrar(new Puntuacion(u.getId(), u.getEmail(), codigoPlaneta, puntaje, maximo));

        // 2) También se registra en la bitácora como interacción del estudiante
        bitacoraDAO.registrar(u.getId(), u.getEmail(), "MINIJUEGO",
                "Minijuego de " + planeta + ": " + puntaje + " de " + maximo + " puntos",
                req.getRemoteAddr());

        resp.setStatus(HttpServletResponse.SC_NO_CONTENT); // 204: registrado
    }

    private String normalizarPlaneta(String valor) {
        String limpio = Normalizer.normalize(valor.trim().toLowerCase(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "");
        return CODIGOS_PLANETA.getOrDefault(limpio, limpio);
    }
}
