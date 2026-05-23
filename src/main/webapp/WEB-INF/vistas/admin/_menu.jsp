<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%-- Menu lateral compartido por todas las paginas del panel de administrador.
     La pagina que lo incluye define la variable "activo" para resaltar la opcion. --%>
<aside class="admin-menu">
    <div class="px-4 mb-4">
        <span class="navbar-marca"><i class="fa fa-sun-o" aria-hidden="true"></i> SISTEMA SOLAR</span>
        <div class="small text-secondary mt-1">Panel de Administrador</div>
    </div>
    <nav aria-label="Menu de administracion">
        <a href="${ctx}/admin/dashboard" class="${activo == 'dashboard' ? 'activo' : ''}">
            <i class="fa fa-tachometer" aria-hidden="true"></i> Inicio
        </a>
        <a href="${ctx}/admin/usuarios" class="${activo == 'usuarios' ? 'activo' : ''}">
            <i class="fa fa-users" aria-hidden="true"></i> Gestion de Usuarios
        </a>
        <a href="${ctx}/admin/bitacora" class="${activo == 'bitacora' ? 'activo' : ''}">
            <i class="fa fa-list-alt" aria-hidden="true"></i> Bitacora
        </a>
        <a href="${ctx}/admin/puntuaciones" class="${activo == 'puntuaciones' ? 'activo' : ''}">
            <i class="fa fa-trophy" aria-hidden="true"></i> Puntuaciones
        </a>
        <a href="${ctx}/index.jsp">
            <i class="fa fa-home" aria-hidden="true"></i> Ver el sitio
        </a>
        <a href="${ctx}/logout">
            <i class="fa fa-sign-out" aria-hidden="true"></i> Cerrar sesion
        </a>
    </nav>
</aside>
