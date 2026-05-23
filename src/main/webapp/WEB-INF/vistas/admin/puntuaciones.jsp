<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="activo" scope="request" value="puntuaciones"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Puntuaciones | Sistema Solar</title>
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
                <h1 class="h3 texto-oro mb-0">Puntuaciones de Minijuegos</h1>
                <span class="text-secondary">Resultados que obtienen los alumnos al jugar en cada planeta</span>
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

        <div class="table-responsive">
            <table class="table tabla-admin align-middle">
                <thead>
                    <tr>
                        <th scope="col">Fecha y hora</th>
                        <th scope="col">Alumno</th>
                        <th scope="col">Planeta</th>
                        <th scope="col">Puntaje obtenido</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${puntuaciones}">
                        <tr>
                            <td><fmt:formatDate value="${p.fechaHora}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                            <td>${empty p.email ? '(desconocido)' : p.email}</td>
                            <td><span class="badge bg-info text-dark">${p.planeta}</span></td>
                            <td><strong class="texto-oro">${p.puntaje} de ${p.puntajeMaximo}</strong> puntos</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty puntuaciones}">
                        <tr><td colspan="4" class="text-center text-secondary py-4">
                            Todavia no hay puntuaciones registradas.
                        </td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/js/accesibilidad.js"></script>
<script src="${ctx}/js/efectos.js"></script>
</body>
</html>
