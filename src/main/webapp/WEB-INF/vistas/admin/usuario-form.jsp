<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="activo" scope="request" value="usuarios"/>
<c:set var="esNuevo" value="${empty usuario or usuario.id == 0}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${esNuevo ? 'Nuevo' : 'Editar'} Usuario | Sistema Solar</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="${ctx}/css/sitio.css">
</head>
<body data-bs-theme="dark">

<a href="#contenido" class="skip-link">Saltar al contenido principal</a>

<div class="admin-layout">
    <jsp:include page="_menu.jsp"/>

    <div class="admin-contenido" id="contenido">
        <h1 class="h3 texto-oro mb-4">
            <c:choose>
                <c:when test="${esNuevo}"><i class="fa fa-user-plus" aria-hidden="true"></i> Nuevo Usuario</c:when>
                <c:otherwise><i class="fa fa-pencil" aria-hidden="true"></i> Editar Usuario</c:otherwise>
            </c:choose>
        </h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>

        <div class="card panel-oscuro p-4" style="max-width: 560px;">
            <form action="${ctx}/admin/usuarios" method="post">
                <input type="hidden" name="id" value="${usuario.id}">

                <div class="mb-3">
                    <label for="nombre" class="form-label">Nombre completo</label>
                    <input type="text" class="form-control" id="nombre" name="nombre"
                           value="${usuario.nombreCompleto}" required>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Correo electronico</label>
                    <input type="email" class="form-control" id="email" name="email"
                           value="${usuario.email}" required>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="rol" class="form-label">Rol</label>
                        <select class="form-select" id="rol" name="rol">
                            <option value="ESTUDIANTE"
                                ${empty usuario.rol or usuario.rol == 'ESTUDIANTE' ? 'selected' : ''}>
                                Estudiante</option>
                            <option value="ADMIN"
                                ${usuario.rol == 'ADMIN' ? 'selected' : ''}>
                                Administrador</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="estado" class="form-label">Estado</label>
                        <select class="form-select" id="estado" name="estado">
                            <option value="ACTIVO"
                                ${empty usuario.estado or usuario.estado == 'ACTIVO' ? 'selected' : ''}>
                                Activo</option>
                            <option value="BLOQUEADO"
                                ${usuario.estado == 'BLOQUEADO' ? 'selected' : ''}>
                                Bloqueado</option>
                        </select>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="clave" class="form-label">Contrasena</label>
                    <div class="campo-clave">
                        <input type="password" class="form-control" id="clave" name="clave"
                               minlength="8" ${esNuevo ? 'required' : ''}>
                        <button type="button" class="toggle-clave" aria-label="Mostrar contrasena">
                            <i class="fa fa-eye" aria-hidden="true"></i>
                        </button>
                    </div>
                    <div class="form-text">
                        <c:choose>
                            <c:when test="${esNuevo}">Minimo 8 caracteres.</c:when>
                            <c:otherwise>Dejala vacia para mantener la contrasena actual. Minimo 8 caracteres si la cambias.</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <button type="submit" class="btn btn-oro">
                    <i class="fa fa-save" aria-hidden="true"></i> Guardar
                </button>
                <a href="${ctx}/admin/usuarios" class="btn btn-contorno-oro">Cancelar</a>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/js/accesibilidad.js"></script>
</body>
</html>
