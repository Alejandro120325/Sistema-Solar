<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro | Sistema Solar</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="${ctx}/css/sitio.css">
</head>
<body data-bs-theme="dark" class="pagina-auth">

<!-- ACCESIBILIDAD: enlace para saltar al contenido -->
<a href="#contenido" class="skip-link">Saltar al contenido principal</a>

<nav class="navbar barra-sitio">
    <div class="container auth-nav-inner">
        <a class="navbar-brand navbar-marca" href="${ctx}/index.jsp">
            <i class="fa fa-sun-o" aria-hidden="true"></i> EduCosmos 4
        </a>
        <div class="auth-header-actions">
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
</nav>

<main id="contenido" class="container d-flex justify-content-center align-items-center py-5"
      style="min-height: calc(100vh - 70px);">
    <div class="card panel-oscuro p-4 p-md-5" style="max-width: 480px; width: 100%;">
        <div class="text-center mb-4">
            <h1 class="h3 texto-oro">Crear cuenta</h1>
            <p class="text-secondary mb-0">Regístrate como estudiante explorador</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>

        <form action="${ctx}/registrar" method="post">
            <div class="mb-3">
                <label for="nombre" class="form-label">Nombre completo</label>
                <input type="text" class="form-control" id="nombre" name="nombre"
                       value="${nombre}" placeholder="Tu nombre y apellido" required autofocus>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Correo electrónico</label>
                <input type="email" class="form-control" id="email" name="email"
                       value="${email}" placeholder="ejemplo@correo.com" required>
                <div class="form-text">Debe ser un correo electrónico válido.</div>
            </div>
            <div class="mb-3">
                <label for="clave" class="form-label">Contraseña</label>
                <div class="campo-clave">
                    <input type="password" class="form-control" id="clave" name="clave"
                           minlength="8" required>
                    <button type="button" class="toggle-clave" aria-label="Mostrar contraseña">
                        <i class="fa fa-eye" aria-hidden="true"></i>
                    </button>
                </div>
                <div class="form-text">Mínimo 8 caracteres.</div>
            </div>
            <div class="mb-4">
                <label for="claveConfirmar" class="form-label">Repetir contraseña</label>
                <div class="campo-clave">
                    <input type="password" class="form-control" id="claveConfirmar" name="claveConfirmar"
                           minlength="8" required>
                    <button type="button" class="toggle-clave" aria-label="Mostrar contraseña">
                        <i class="fa fa-eye" aria-hidden="true"></i>
                    </button>
                </div>
            </div>
            <button type="submit" class="btn btn-oro w-100 mb-3">
                <i class="fa fa-user-plus" aria-hidden="true"></i> Registrarme
            </button>
        </form>

        <p class="text-center text-secondary mb-0">
            ¿Ya tienes cuenta?
            <a href="${ctx}/login.jsp" class="texto-oro">Inicia sesión</a>
        </p>
        <p class="text-center mt-2 mb-0">
            <a href="${ctx}/index.jsp" class="text-secondary small">Volver al inicio</a>
        </p>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/js/accesibilidad.js?v=20260603"></script>
</body>
</html>
