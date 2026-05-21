<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema Solar | Educacion de Calidad - ODS 4</title>
    <meta name="description" content="Plataforma educativa interactiva del Sistema Solar: modelos 3D, realidad aumentada y multimedia.">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="${ctx}/css/sitio.css">
    <!-- Componente de Realidad Aumentada -->
    <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
</head>
<body data-bs-theme="dark">

<!-- ACCESIBILIDAD (elemento 1): enlace para saltar al contenido principal -->
<a href="#contenido" class="skip-link">Saltar al contenido principal</a>

<!-- ===================== BARRA DE NAVEGACION ===================== -->
<nav class="navbar navbar-expand-lg barra-sitio sticky-top">
    <div class="container">
        <a class="navbar-brand navbar-marca" href="${ctx}/index.jsp">
            <i class="fa fa-sun-o" aria-hidden="true"></i> SISTEMA SOLAR
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#menuPrincipal" aria-controls="menuPrincipal"
                aria-expanded="false" aria-label="Abrir menu de navegacion">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="menuPrincipal">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="#contenido">Inicio</a></li>
                <li class="nav-item"><a class="nav-link" href="#categorias">Categorias</a></li>
                <li class="nav-item"><a class="nav-link" href="#realidad-aumentada">Realidad Aumentada</a></li>
                <li class="nav-item"><a class="nav-link" href="#multimedia">Multimedia</a></li>
            </ul>

            <!-- ACCESIBILIDAD (elemento 2): tamano de texto y alto contraste -->
            <div class="barra-accesibilidad btn-group me-3" role="group"
                 aria-label="Opciones de accesibilidad">
                <button type="button" class="btn" id="acc-menos"
                        aria-label="Reducir tamano del texto" title="Reducir texto">A-</button>
                <button type="button" class="btn" id="acc-mas"
                        aria-label="Aumentar tamano del texto" title="Aumentar texto">A+</button>
                <button type="button" class="btn" id="acc-contraste"
                        aria-label="Activar o desactivar alto contraste" title="Alto contraste">
                    <i class="fa fa-adjust" aria-hidden="true"></i>
                </button>
            </div>

            <!-- Area de sesion -->
            <c:choose>
                <c:when test="${not empty sessionScope.usuario}">
                    <span class="navbar-text me-3 texto-oro">
                        <i class="fa fa-user-circle" aria-hidden="true"></i>
                        ${sessionScope.usuario.nombreCompleto}
                    </span>
                    <c:choose>
                        <c:when test="${sessionScope.usuario.admin}">
                            <a class="btn btn-contorno-oro btn-sm me-2" href="${ctx}/admin/dashboard">Panel</a>
                        </c:when>
                        <c:otherwise>
                            <a class="btn btn-contorno-oro btn-sm me-2" href="${ctx}/explorador.jsp">Explorador</a>
                        </c:otherwise>
                    </c:choose>
                    <a class="btn btn-oro btn-sm" href="${ctx}/logout">Salir</a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-contorno-oro btn-sm me-2" href="${ctx}/login.jsp">Entrar</a>
                    <a class="btn btn-oro btn-sm" href="${ctx}/registro.jsp">Registrarse</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<main id="contenido">

    <!-- ===================== PORTADA / HERO ===================== -->
    <section class="hero container">
        <span class="etiqueta-ods">
            <i class="fa fa-graduation-cap" aria-hidden="true"></i> ODS 4 - Educacion de Calidad
        </span>
        <h1 class="mt-3">SISTEMA SOLAR</h1>
        <p class="lead text-secondary mx-auto" style="max-width: 700px;">
            Plataforma educativa interactiva para aprender astronomia con modelos 3D,
            realidad aumentada, video, imagenes y audio. El universo, al alcance de todos.
        </p>
        <div class="mt-4">
            <a href="${ctx}/explorador.jsp" class="btn btn-oro btn-lg me-2">
                <i class="fa fa-rocket" aria-hidden="true"></i> Explorar en 3D
            </a>
            <a href="${ctx}/registro.jsp" class="btn btn-contorno-oro btn-lg">Crear una cuenta</a>
        </div>
    </section>

    <!-- ===================== CATEGORIAS (minimo 3) ===================== -->
    <section id="categorias" class="seccion container">
        <h2 class="seccion-titulo">Nuestras Categorias</h2>
        <div class="row g-4">

            <div class="col-md-4">
                <div class="card card-categoria h-100 text-center p-4">
                    <div class="icono"><i class="fa fa-globe" aria-hidden="true"></i></div>
                    <h3 class="h5 mt-3">1. Exploracion 3D</h3>
                    <p class="text-secondary">
                        Recorre el Sol y los planetas en un motor 3D interactivo,
                        con enciclopedia, estructura interna y minijuegos.
                    </p>
                    <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro mt-auto">Ingresar</a>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card card-categoria h-100 text-center p-4">
                    <div class="icono"><i class="fa fa-cube" aria-hidden="true"></i></div>
                    <h3 class="h5 mt-3">2. Realidad Aumentada</h3>
                    <p class="text-secondary">
                        Observa modelos 3D del espacio en tu propio entorno usando
                        la camara de tu celular.
                    </p>
                    <a href="#realidad-aumentada" class="btn btn-contorno-oro mt-auto">Ver en AR</a>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card card-categoria h-100 text-center p-4">
                    <div class="icono"><i class="fa fa-film" aria-hidden="true"></i></div>
                    <h3 class="h5 mt-3">3. Multimedia Educativa</h3>
                    <p class="text-secondary">
                        Aprende con video, una galeria de imagenes de los planetas
                        y audio ambiental espacial.
                    </p>
                    <a href="#multimedia" class="btn btn-contorno-oro mt-auto">Ver recursos</a>
                </div>
            </div>

        </div>
    </section>

    <!-- ===================== REALIDAD AUMENTADA ===================== -->
    <section id="realidad-aumentada" class="seccion" style="background: var(--fondo-2);">
        <div class="container">
            <h2 class="seccion-titulo">Realidad Aumentada</h2>
            <div class="row align-items-center g-4">
                <div class="col-lg-6">
                    <!-- Modelo 3D con soporte de AR (funciona en celulares Android/iOS) -->
                    <model-viewer
                            src="https://modelviewer.dev/shared-assets/models/Astronaut.glb"
                            alt="Modelo 3D de un astronauta para realidad aumentada"
                            ar
                            ar-modes="webxr scene-viewer quick-look"
                            camera-controls
                            auto-rotate
                            shadow-intensity="1">
                        <button slot="ar-button" class="btn btn-oro">
                            <i class="fa fa-mobile" aria-hidden="true"></i> Ver en mi espacio (AR)
                        </button>
                    </model-viewer>
                </div>
                <div class="col-lg-6">
                    <h3 class="h4 texto-oro">Lleva el espacio a tu habitacion</h3>
                    <p class="text-secondary">
                        Gira el modelo 3D con el mouse o el dedo. Desde un celular,
                        toca el boton <strong>"Ver en mi espacio (AR)"</strong> para
                        proyectar el modelo en el mundo real con la camara.
                    </p>
                    <ul class="text-secondary">
                        <li>Compatible con Android (Scene Viewer) e iOS (Quick Look).</li>
                        <li>No necesita instalar ninguna aplicacion.</li>
                    </ul>
                    <%-- Para usar un planeta en AR, reemplaza el atributo "src" por la
                         ruta de tu propio archivo .glb, por ejemplo: ${ctx}/modelos/tierra.glb --%>
                </div>
            </div>
        </div>
    </section>

    <!-- ===================== MULTIMEDIA ===================== -->
    <section id="multimedia" class="seccion container">
        <h2 class="seccion-titulo">Multimedia Educativa</h2>

        <div class="row g-4">
            <div class="col-lg-7">
                <h3 class="h5 texto-oro mb-3"><i class="fa fa-film" aria-hidden="true"></i> Video</h3>
                <div class="ratio ratio-16x9">
                    <video controls preload="metadata" poster="${ctx}/js/textures/stars.jpg">
                        <source src="${ctx}/videos/intro-bg.mp4" type="video/mp4">
                        Tu navegador no soporta la reproduccion de video.
                    </video>
                </div>
                <p class="small text-secondary mt-2">
                    Video introductorio al Sistema Solar.
                </p>
            </div>

            <div class="col-lg-5">
                <h3 class="h5 texto-oro mb-3"><i class="fa fa-volume-up" aria-hidden="true"></i> Audio</h3>
                <div class="card panel-oscuro p-4">
                    <p class="text-secondary mb-3">
                        El explorador 3D incluye <strong>musica ambiental espacial</strong> y
                        efectos de sonido generados en tiempo real. Actívalos con el boton de
                        audio dentro del explorador.
                    </p>
                    <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">
                        <i class="fa fa-headphones" aria-hidden="true"></i> Escuchar en el explorador
                    </a>
                </div>
            </div>
        </div>

        <h3 class="h5 texto-oro mt-5 mb-3">
            <i class="fa fa-picture-o" aria-hidden="true"></i> Galeria de imagenes
        </h3>
        <div class="row g-3 galeria">
            <div class="col-6 col-md-3">
                <img src="${ctx}/js/textures/earth.jpg" alt="Imagen de la superficie del planeta Tierra">
            </div>
            <div class="col-6 col-md-3">
                <img src="${ctx}/js/textures/mars.jpg" alt="Imagen de la superficie del planeta Marte">
            </div>
            <div class="col-6 col-md-3">
                <img src="${ctx}/js/textures/jupiter.jpg" alt="Imagen del planeta Jupiter y sus bandas de nubes">
            </div>
            <div class="col-6 col-md-3">
                <img src="${ctx}/js/textures/saturn.jpg" alt="Imagen del planeta Saturno">
            </div>
        </div>
    </section>

</main>

<!-- ===================== PIE DE PAGINA ===================== -->
<footer class="pie-sitio">
    <div class="container">
        <p class="mb-1 texto-oro">
            <i class="fa fa-sun-o" aria-hidden="true"></i> SISTEMA SOLAR
        </p>
        <p class="mb-0 small">
            Proyecto educativo - Objetivo de Desarrollo Sostenible 4: Educacion de Calidad<br>
            Universidad Politecnica Salesiana &middot; <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %>
        </p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/js/accesibilidad.js"></script>
</body>
</html>
