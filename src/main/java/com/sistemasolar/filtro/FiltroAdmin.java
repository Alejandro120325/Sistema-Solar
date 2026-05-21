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
 * Protege TODO el panel de administrador (/admin/*).
 * Solo entra un usuario con sesion iniciada y rol ADMIN.
 */
@WebFilter("/admin/*")
public class FiltroAdmin implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession sesion = req.getSession(false);
        Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?requerido=1");
            return;
        }
        if (usuario.isBloqueado()) {
            sesion.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?bloqueado=1");
            return;
        }
        if (!usuario.isAdmin()) {
            // Es estudiante: no puede ver el panel, se le envia al explorador.
            resp.sendRedirect(req.getContextPath() + "/explorador.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}
