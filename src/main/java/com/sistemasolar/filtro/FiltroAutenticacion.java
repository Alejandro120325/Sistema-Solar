package com.sistemasolar.filtro;

import com.sistemasolar.modelo.Usuario;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Protege el explorador 3D y el registro de interacciones.
 * Solo entran usuarios con sesión iniciada y que no estén bloqueados.
 */
@WebFilter(urlPatterns = {"/explorador.jsp", "/interaccion", "/puntuacion"})
public class FiltroAutenticacion implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession sesion = req.getSession(false);
        Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuario") : null;

        if (usuario == null) {
            // No hay sesión: se envía al login.
            resp.sendRedirect(req.getContextPath() + "/login.jsp?requerido=1");
            return;
        }
        if (usuario.isBloqueado()) {
            // El admin lo bloqueó mientras navegaba: se cierra la sesión.
            sesion.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?bloqueado=1");
            return;
        }

        chain.doFilter(request, response);
    }
}
