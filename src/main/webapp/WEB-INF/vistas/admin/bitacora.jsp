<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="activo" scope="request" value="bitacora"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bitacora | Sistema Solar</title>
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
                <h1 class="h3 texto-oro mb-0">Bitacora del Sistema</h1>
                <span class="text-secondary">Registros, inicios de sesion e interacciones de estudiantes</span>
            </div>
            <div class="barra-accesibilidad btn-group" role="group" aria-label="Opciones de accesibilidad">
                <button type="button" class="btn" id="acc-menos" aria-label="Reducir texto" title="Reducir texto">A-</button>
                <button type="button" class="btn" id="acc-mas" aria-label="Aumentar texto" title="Aumentar texto">A+</button>
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
                        <th scope="col">Usuario</th>
                        <th scope="col">Accion</th>
                        <th scope="col">Detalle</th>
                        <th scope="col">IP</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="e" items="${eventos}">
                        <tr>
                            <td><fmt:formatDate value="${e.fechaHora}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                            <td>${empty e.email ? '(invitado)' : e.email}</td>
                            <td><span class="badge bg-info text-dark">${e.accion}</span></td>
                            <td>${e.detalle}</td>
                            <td class="text-secondary small">${e.ip}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty eventos}">
                        <tr><td colspan="5" class="text-center text-secondary py-4">
                            La bitacora esta vacia.
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
