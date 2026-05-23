<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesion | Sistema Solar</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="${ctx}/css/sitio.css">
</head>
<body data-bs-theme="dark">

<!-- ACCESIBILIDAD: enlace para saltar al contenido -->
<a href="#contenido" class="skip-link">Saltar al contenido principal</a>

<nav class="navbar barra-sitio">
    <div class="container">
        <a class="navbar-brand navbar-marca" href="${ctx}/index.jsp">
            <i class="fa fa-sun-o" aria-hidden="true"></i> SISTEMA SOLAR
        </a>
        <div class="barra-accesibilidad btn-group" role="group" aria-label="Opciones de accesibilidad">
            <button type="button" class="btn" id="acc-menos" aria-label="Reducir texto" title="Reducir texto">A-</button>
            <button type="button" class="btn" id="acc-mas" aria-label="Aumentar texto" title="Aumentar texto">A+</button>
            <button type="button" class="btn" id="acc-contraste" aria-label="Alto contraste" title="Alto contraste">
                <i class="fa fa-adjust" aria-hidden="true"></i>
            </button>
        </div>
    </div>
</nav>

<main id="contenido" class="container d-flex justify-content-center align-items-center"
      style="min-height: calc(100vh - 70px);">
    <div class="card panel-oscuro p-4 p-md-5" style="max-width: 440px; width: 100%;">
        <div class="text-center mb-4">
            <h1 class="h3 texto-oro">Iniciar Sesion</h1>
            <p class="text-secondary mb-0">Accede a tu cuenta de Explorador Solar</p>
        </div>

        <!-- Mensajes -->
        <c:if test="${param.registrado == '1'}">
            <div class="alert alert-success" role="alert">
                Cuenta creada con exito. Ya puedes iniciar sesion.
            </div>
        </c:if>
        <c:if test="${param.requerido == '1'}">
            <div class="alert alert-warning" role="alert">
                Debes iniciar sesion para acceder a esa pagina.
            </div>
        </c:if>
        <c:if test="${param.bloqueado == '1'}">
            <div class="alert alert-danger" role="alert">
                Tu cuenta esta bloqueada. Contacta con el administrador.
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>

        <form action="${ctx}/login" method="post">
            <div class="mb-3">
                <label for="email" class="form-label">Correo electronico</label>
                <input type="email" class="form-control" id="email" name="email"
                       value="${email}" placeholder="ejemplo@correo.com" required autofocus>
            </div>
            <div class="mb-4">
                <label for="clave" class="form-label">Contrasena</label>
                <div class="campo-clave">
                    <input type="password" class="form-control" id="clave" name="clave" required>
                    <button type="button" class="toggle-clave" aria-label="Mostrar contrasena">
                        <i class="fa fa-eye" aria-hidden="true"></i>
                    </button>
                </div>
            </div>
            <button type="submit" class="btn btn-oro w-100 mb-3">
                <i class="fa fa-sign-in" aria-hidden="true"></i> Entrar
            </button>
        </form>

        <p class="text-center text-secondary mb-0">
            No tienes cuenta?
            <a href="${ctx}/registro.jsp" class="texto-oro">Registrate aqui</a>
        </p>
        <p class="text-center mt-2 mb-0">
            <a href="${ctx}/index.jsp" class="text-secondary small">Volver al inicio</a>
        </p>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/js/accesibilidad.js"></script>
</body>
</html>
