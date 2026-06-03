<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%-- Menú lateral compartido por todas las páginas del panel de administrador.
     La página que lo incluye define la variable "activo" para resaltar la opción. --%>
<aside class="admin-menu">
    <div class="px-4 mb-4">
        <span class="navbar-marca"><i class="fa fa-sun-o" aria-hidden="true"></i> EduCosmos 4</span>
        <div class="small text-secondary mt-1">Panel de administrador</div>
    </div>
    <nav aria-label="Menú de administración">
        <a href="${ctx}/admin/dashboard" class="${activo == 'dashboard' ? 'activo' : ''}">
            <i class="fa fa-tachometer" aria-hidden="true"></i> Inicio
        </a>
        <a href="${ctx}/admin/usuarios" class="${activo == 'usuarios' ? 'activo' : ''}">
            <i class="fa fa-users" aria-hidden="true"></i> Gestión de usuarios
        </a>
        <a href="${ctx}/admin/bitacora" class="${activo == 'bitacora' ? 'activo' : ''}">
            <i class="fa fa-list-alt" aria-hidden="true"></i> Bitácora
        </a>
        <a href="${ctx}/admin/puntuaciones" class="${activo == 'puntuaciones' ? 'activo' : ''}">
            <i class="fa fa-trophy" aria-hidden="true"></i> Puntuaciones
        </a>
        <a href="${ctx}/index.jsp">
            <i class="fa fa-home" aria-hidden="true"></i> Ver el sitio
        </a>
        <a href="${ctx}/logout">
            <i class="fa fa-sign-out" aria-hidden="true"></i> Cerrar sesión
        </a>
    </nav>
</aside>
