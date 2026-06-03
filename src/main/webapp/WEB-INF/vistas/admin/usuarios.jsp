<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="activo" scope="request" value="usuarios"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de usuarios | Sistema Solar</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="${ctx}/css/sitio.css">
</head>
<body data-bs-theme="dark">

<a href="#contenido" class="skip-link">Saltar al contenido principal</a>

<div class="admin-layout">
    <jsp:include page="_menu.jsp"/>

    <main class="admin-contenido" id="contenido">
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <h1 class="h3 texto-oro mb-0">Gestión de usuarios</h1>
            <div class="admin-header-actions">
                <div class="barra-accesibilidad btn-group" role="group" aria-label="Opciones de accesibilidad">
                    <button type="button" class="btn" id="acc-menos" aria-label="Reducir texto" title="Reducir texto">A-</button>
                    <button type="button" class="btn" id="acc-mas" aria-label="Aumentar texto" title="Aumentar texto">A+</button>
                </div>
                <div class="theme-selector" data-theme-selector>
                    <button type="button" class="theme-toggle"
                            aria-haspopup="true" aria-expanded="false"
                            aria-label="Seleccionar tema visual">
                        <span class="theme-swatch theme-swatch-current" data-theme-current-swatch></span>
                        <span class="theme-toggle-text" data-theme-current-label>Original</span>
                        <i class="fa fa-chevron-down theme-arrow" aria-hidden="true"></i>
                    </button>
                    <div class="theme-menu" role="menu" hidden>
                        <button type="button" role="menuitemradio" data-theme-option="original">
                            <span class="theme-swatch theme-swatch-original"></span>
                            <span>Original</span>
                        </button>
                        <button type="button" role="menuitemradio" data-theme-option="green">
                            <span class="theme-swatch theme-swatch-green"></span>
                            <span>Verde</span>
                        </button>
                        <button type="button" role="menuitemradio" data-theme-option="cyan">
                            <span class="theme-swatch theme-swatch-cyan"></span>
                            <span>Cyan</span>
                        </button>
                        <button type="button" role="menuitemradio" data-theme-option="purple">
                            <span class="theme-swatch theme-swatch-purple"></span>
                            <span>Morado</span>
                        </button>
                        <button type="button" role="menuitemradio" data-theme-option="gold">
                            <span class="theme-swatch theme-swatch-gold"></span>
                            <span>Dorado</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>

        <div class="mb-3">
            <a href="${ctx}/admin/usuarios?accion=nuevo" class="btn btn-oro">
                <i class="fa fa-user-plus" aria-hidden="true"></i> Nuevo usuario
            </a>
        </div>

        <div class="table-responsive">
            <table class="table tabla-admin align-middle">
                <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Nombre</th>
                        <th scope="col">Correo</th>
                        <th scope="col">Rol</th>
                        <th scope="col">Estado</th>
                        <th scope="col">Registro</th>
                        <th scope="col">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${usuarios}">
                        <tr>
                            <td>${u.id}</td>
                            <td>${u.nombreCompleto}</td>
                            <td>${u.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.admin}">
                                        <span class="badge bg-warning text-dark">ADMIN</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-info text-dark">ESTUDIANTE</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.bloqueado}">
                                        <span class="badge bg-danger">BLOQUEADO</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">ACTIVO</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${u.fechaRegistro}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <a href="${ctx}/admin/usuarios?accion=editar&id=${u.id}"
                                   class="btn btn-sm btn-contorno-oro" title="Editar" aria-label="Editar usuario">
                                    <i class="fa fa-pencil" aria-hidden="true"></i>
                                </a>
                                <c:if test="${u.id != sessionScope.usuario.id}">
                                    <c:choose>
                                        <c:when test="${u.bloqueado}">
                                            <a href="${ctx}/admin/usuarios?accion=activar&id=${u.id}"
                                               class="btn btn-sm btn-success" title="Activar" aria-label="Activar usuario">
                                                <i class="fa fa-check" aria-hidden="true"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${ctx}/admin/usuarios?accion=bloquear&id=${u.id}"
                                               class="btn btn-sm btn-warning" title="Bloquear" aria-label="Bloquear usuario">
                                                <i class="fa fa-ban" aria-hidden="true"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${ctx}/admin/usuarios?accion=eliminar&id=${u.id}"
                                       class="btn btn-sm btn-danger" title="Eliminar" aria-label="Eliminar usuario"
                                       onclick="return confirm('¿Seguro que deseas eliminar a ${u.nombreCompleto}?');">
                                        <i class="fa fa-trash" aria-hidden="true"></i>
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty usuarios}">
                        <tr><td colspan="7" class="text-center text-secondary py-4">
                            No hay usuarios registrados todavía.
                        </td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/js/accesibilidad.js?v=20260603"></script>
<script src="${ctx}/js/efectos.js"></script>
</body>
</html>

