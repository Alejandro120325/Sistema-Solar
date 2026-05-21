<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="activo" scope="request" value="dashboard"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administrador | Sistema Solar</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="${ctx}/css/sitio.css">
</head>
<body data-bs-theme="dark">

<a href="#contenido" class="skip-link">Saltar al contenido principal</a>

<div class="admin-layout">
    <jsp:include page="_menu.jsp"/>

    <div class="admin-contenido" id="contenido">
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <div>
                <h1 class="h3 texto-oro mb-0">Panel de Administrador</h1>
                <span class="text-secondary">Bienvenido, ${sessionScope.usuario.nombreCompleto}</span>
            </div>
            <div class="barra-accesibilidad btn-group" role="group" aria-label="Opciones de accesibilidad">
                <button type="button" class="btn" id="acc-menos" aria-label="Reducir texto" title="Reducir texto">A-</button>
                <button type="button" class="btn" id="acc-mas" aria-label="Aumentar texto" title="Aumentar texto">A+</button>
                <button type="button" class="btn" id="acc-contraste" aria-label="Alto contraste" title="Alto contraste">
                    <i class="fa fa-adjust" aria-hidden="true"></i>
                </button>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>

        <!-- Tarjetas de resumen -->
        <div class="row g-4 mb-4">
            <div class="col-6 col-lg-3">
                <div class="tarjeta-stat">
                    <div class="numero">${totalUsuarios}</div>
                    <div class="text-secondary"><i class="fa fa-users" aria-hidden="true"></i> Usuarios totales</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="tarjeta-stat">
                    <div class="numero">${totalEstudiantes}</div>
                    <div class="text-secondary"><i class="fa fa-graduation-cap" aria-hidden="true"></i> Estudiantes</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="tarjeta-stat">
                    <div class="numero">${totalBloqueados}</div>
                    <div class="text-secondary"><i class="fa fa-ban" aria-hidden="true"></i> Bloqueados</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="tarjeta-stat">
                    <div class="numero">${totalBitacora}</div>
                    <div class="text-secondary"><i class="fa fa-list-alt" aria-hidden="true"></i> Eventos en bitacora</div>
                </div>
            </div>
        </div>

        <!-- Accesos rapidos -->
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card panel-oscuro p-4 h-100">
                    <h2 class="h5 texto-oro"><i class="fa fa-users" aria-hidden="true"></i> Gestion de Usuarios</h2>
                    <p class="text-secondary">
                        Consulta todos los usuarios, registra nuevos, actualiza su informacion
                        y bloquea o activa cuentas.
                    </p>
                    <a href="${ctx}/admin/usuarios" class="btn btn-oro mt-auto align-self-start">Ir a Usuarios</a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card panel-oscuro p-4 h-100">
                    <h2 class="h5 texto-oro"><i class="fa fa-list-alt" aria-hidden="true"></i> Bitacora del Sistema</h2>
                    <p class="text-secondary">
                        Revisa el registro de usuarios nuevos, inicios de sesion y las
                        interacciones de los estudiantes con el explorador.
                    </p>
                    <a href="${ctx}/admin/bitacora" class="btn btn-oro mt-auto align-self-start">Ir a Bitacora</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/js/accesibilidad.js"></script>
</body>
</html>
