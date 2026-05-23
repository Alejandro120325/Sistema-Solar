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
                <h1 class="h3 texto-oro mb-0">Ranking por Planeta</h1>
                <span class="text-secondary">Consulta alumnos, planetas y puntuaciones sin duplicados</span>
            </div>
            <div class="barra-accesibilidad btn-group" role="group" aria-label="Opciones de accesibilidad">
                <button type="button" class="btn" id="acc-menos" aria-label="Reducir texto" title="Reducir texto">A-</button>
                <button type="button" class="btn" id="acc-mas" aria-label="Aumentar texto" title="Aumentar texto">A+</button>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>

        <div class="card panel-oscuro p-3 p-md-4 mb-4">
            <form method="get" action="${ctx}/admin/puntuaciones" class="row g-3 align-items-end">
                <div class="col-md-8">
                    <label for="planeta" class="form-label">Filtrar ranking por planeta</label>
                    <select class="form-select" id="planeta" name="planeta">
                        <option value="">Todos los planetas</option>
                        <c:forEach var="pl" items="${planetas}">
                            <c:choose>
                                <c:when test="${planetaSeleccionado == pl.codigo}">
                                    <option value="${pl.codigo}" selected>${pl.nombre}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${pl.codigo}">${pl.nombre}</option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4 d-flex gap-2">
                    <button class="btn btn-oro flex-fill" type="submit">Consultar</button>
                    <a class="btn btn-contorno-oro" href="${ctx}/admin/puntuaciones">Limpiar</a>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table tabla-admin align-middle">
                <thead>
                    <tr>
                        <th scope="col">Actualizado</th>
                        <th scope="col">Alumno</th>
                        <th scope="col">Planeta</th>
                        <th scope="col">Puntaje obtenido</th>
                        <th scope="col">Progreso</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${puntuaciones}">
                        <tr>
                            <td><fmt:formatDate value="${p.fechaHora}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                            <td>
                                <strong>${empty p.usuarioNombre ? '(desconocido)' : p.usuarioNombre}</strong><br>
                                <span class="text-secondary small">${p.email}</span>
                            </td>
                            <td><span class="badge bg-info text-dark">${p.planetaNombre}</span></td>
                            <td><strong class="texto-oro">${p.puntaje} de ${p.puntajeMaximo}</strong> puntos</td>
                            <td>
                                <div class="progress barra-progreso" role="progressbar" aria-label="Progreso del alumno"
                                     aria-valuenow="${p.progreso}" aria-valuemin="0" aria-valuemax="100">
                                    <div class="progress-bar" style="width: ${p.progreso}%">${p.progreso}%</div>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty puntuaciones}">
                        <tr><td colspan="5" class="text-center text-secondary py-5 estado-vacio">
                            <i class="fa fa-line-chart" aria-hidden="true"></i>
                            <span>Todavia no hay puntuaciones registradas para esta consulta.</span>
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
