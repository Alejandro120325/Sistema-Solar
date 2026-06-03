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

    <main class="admin-contenido" id="contenido">
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <div>
                <h1 class="h3 texto-oro mb-0">Panel de administrador</h1>
                <span class="text-secondary">Bienvenido, ${sessionScope.usuario.nombreCompleto}</span>
            </div>
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

        <!-- Tarjetas de resumen -->
        <div class="row g-4 mb-4">
            <div class="col-6 col-lg-3">
                <div class="tarjeta-stat">
                    <div class="numero" data-contador="${totalUsuarios}">0</div>
                    <div class="text-secondary"><i class="fa fa-users" aria-hidden="true"></i> Usuarios totales</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="tarjeta-stat">
                    <div class="numero" data-contador="${totalEstudiantes}">0</div>
                    <div class="text-secondary"><i class="fa fa-graduation-cap" aria-hidden="true"></i> Estudiantes</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="tarjeta-stat">
                    <div class="numero" data-contador="${totalBloqueados}">0</div>
                    <div class="text-secondary"><i class="fa fa-ban" aria-hidden="true"></i> Bloqueados</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="tarjeta-stat">
                    <div class="numero" data-contador="${totalPuntuaciones}">0</div>
                    <div class="text-secondary"><i class="fa fa-trophy" aria-hidden="true"></i> Puntuaciones</div>
                </div>
            </div>
        </div>

        <!-- Accesos rápidos -->
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card panel-oscuro p-4 h-100">
                    <h2 class="h5 texto-oro"><i class="fa fa-users" aria-hidden="true"></i> Gestión de usuarios</h2>
                    <p class="text-secondary">
                        Consulta todos los usuarios, registra nuevos, actualiza su información
                        y bloquea o activa cuentas.
                    </p>
                    <a href="${ctx}/admin/usuarios" class="btn btn-oro mt-auto align-self-start">Ir a usuarios</a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card panel-oscuro p-4 h-100">
                    <h2 class="h5 texto-oro"><i class="fa fa-list-alt" aria-hidden="true"></i> Bitácora del sistema</h2>
                    <p class="text-secondary">
                        Revisa el registro de usuarios nuevos, inicios de sesión y las
                        interacciones de los estudiantes con el explorador.
                    </p>
                    <a href="${ctx}/admin/bitacora" class="btn btn-oro mt-auto align-self-start">Ir a bitácora</a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card panel-oscuro p-4 h-100">
                    <h2 class="h5 texto-oro"><i class="fa fa-trophy" aria-hidden="true"></i> Rankings por planeta</h2>
                    <p class="text-secondary">
                        Revisa los puntajes por planeta, filtra rankings y consulta el avance
                        de cada estudiante en los minijuegos.
                    </p>
                    <a href="${ctx}/admin/puntuaciones" class="btn btn-oro mt-auto align-self-start">Ver Rankings</a>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/js/accesibilidad.js?v=20260603"></script>
<script src="${ctx}/js/efectos.js"></script>
</body>
</html>

