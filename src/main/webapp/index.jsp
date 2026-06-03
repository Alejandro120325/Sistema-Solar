<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema Solar | Educación de Calidad - ODS 4</title>
    <meta name="description" content="Plataforma educativa interactiva del Sistema Solar: modelos 3D, realidad aumentada y multimedia.">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="${ctx}/css/sitio.css">
    <link rel="stylesheet" href="${ctx}/css/orbital-final.css?v=20260603-galleryspin-max">
    <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
</head>
<body data-bs-theme="dark">

<!-- ACCESIBILIDAD (elemento 1): enlace para saltar al contenido -->
<a href="#contenido" class="skip-link">Saltar al contenido principal</a>

<!-- ===================== BARRA DE NAVEGACIÓN ===================== -->
<nav class="navbar navbar-expand-lg barra-sitio sticky-top">
    <div class="container">
        <a class="navbar-brand navbar-marca" href="${ctx}/index.jsp">
            <i class="fa fa-sun-o" aria-hidden="true"></i> EduCosmos 4
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#menuPrincipal" aria-controls="menuPrincipal"
                aria-expanded="false" aria-label="Abrir menú de navegación">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="menuPrincipal">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item"><a class="nav-link" href="#contenido">Inicio</a></li>
                <li class="nav-item"><a class="nav-link" href="#categorias">Categorías</a></li>
                <li class="nav-item"><a class="nav-link" href="#realidad-aumentada"
                                        data-bitacora-accion="INGRESO_REALIDAD_AUMENTADA"
                                        data-bitacora-detalle="Ingreso a la sección de realidad aumentada">Realidad Aumentada</a></li>
                <li class="nav-item"><a class="nav-link" href="#multimedia"
                                        data-bitacora-accion="INGRESO_MULTIMEDIA"
                                        data-bitacora-detalle="Ingreso a la sección multimedia educativa">Multimedia</a></li>
            </ul>

            <div class="d-flex align-items-center nav-acciones">
                <!-- ACCESIBILIDAD (elemento 2): tamaño de texto ajustable -->
                <div class="barra-accesibilidad btn-group" role="group"
                     aria-label="Opciones de accesibilidad">
                    <button type="button" class="btn" id="acc-menos"
                            aria-label="Reducir tamaño del texto" title="Reducir texto">A-</button>
                    <button type="button" class="btn" id="acc-mas"
                            aria-label="Aumentar tamaño del texto" title="Aumentar texto">A+</button>
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

                <c:choose>
                    <c:when test="${not empty sessionScope.usuario}">
                        <span class="navbar-text texto-oro">
                            <i class="fa fa-user-circle" aria-hidden="true"></i>
                            ${sessionScope.usuario.nombreCompleto}
                        </span>
                        <c:choose>
                            <c:when test="${sessionScope.usuario.admin}">
                                <a class="btn btn-contorno-oro btn-sm" href="${ctx}/admin/dashboard">Panel</a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn btn-contorno-oro btn-sm" href="${ctx}/explorador.jsp">Explorador</a>
                            </c:otherwise>
                        </c:choose>
                        <a class="btn btn-oro btn-sm" href="${ctx}/logout">Salir</a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn btn-contorno-oro btn-sm" href="${ctx}/login.jsp">Entrar</a>
                        <a class="btn btn-oro btn-sm" href="${ctx}/registro.jsp">Registrarse</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<main id="contenido">
    <c:if test="${param.sesion == '1'}">
        <div class="container pt-4">
            <div class="alert alert-success alerta-sesion" role="status">
                Sesión iniciada correctamente. Puedes entrar al explorador cuando estés listo.
            </div>
        </div>
    </c:if>

    <!-- ===================== HERO ===================== -->
    <section class="hero">
        <div class="hero-espacio" aria-hidden="true">
            <div class="orbita orbita-1"></div>
            <div class="orbita orbita-2"></div>
        </div>
        <div class="container hero-inner">
            <div class="hero-copy">
                <span class="hero-eyebrow">ODS 4 &middot; Educación de Calidad</span>
                <h1 class="hero-titulo">Sistema Solar</h1>
                <p class="hero-sub">
                    Una plataforma educativa para explorar el universo con modelos 3D,
                    realidad aumentada y contenido multimedia, con la precisión y la
                    elegancia de un observatorio profesional.
                </p>
                <div class="hero-acciones">
                    <a href="${ctx}/explorador.jsp" class="btn btn-oro btn-lg">Explorar en 3D</a>
                    <a href="${ctx}/registro.jsp" class="btn btn-contorno-oro btn-lg">Crear una cuenta</a>
                </div>
            </div>
            <div class="hero-visual hero-orbital" aria-label="Planeta Tierra">
                <div class="hero-earth-horizon" aria-hidden="true">
                    <div class="hero-earth-glow"></div>
                    <div class="hero-earth-planet">
                        <span class="planet-texture" style="background-image: url('${ctx}/js/textures/earth.jpg')"></span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===================== FRANJA DE ESTADISTICAS ===================== -->
    <section class="franja-stats" id="franja">
        <div class="container">
            <div class="row g-4">
                <div class="col-6 col-lg-3">
                    <div class="stat">
                        <span class="stat-num" data-contador="8">0</span>
                        <span class="stat-lbl">Planetas en 3D</span>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat">
                        <span class="stat-num" data-contador="3">0</span>
                        <span class="stat-lbl">Categorías educativas</span>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat">
                        <span class="stat-num" data-contador="11">0</span>
                        <span class="stat-lbl">Texturas en alta resolución</span>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat">
                        <span class="stat-num" data-contador="100" data-sufijo="%">0</span>
                        <span class="stat-lbl">Experiencia interactiva</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===================== CATEGORÍAS ===================== -->
    <section id="categorias" class="seccion">
        <div class="container">
            <div class="seccion-encabezado">
                <p class="kicker">Explora el conocimiento</p>
                <h2 class="seccion-titulo">Nuestras Categorías</h2>
            </div>
            <div class="row g-4 justify-content-center">

                <div class="col-md-6 col-lg-4">
                    <article class="card card-categoria h-100">
                        <span class="card-num">01</span>
                        <div class="icono"><i class="fa fa-globe" aria-hidden="true"></i></div>
                        <h3>Exploración 3D</h3>
                        <p>Recorre el Sol y los planetas en un motor 3D interactivo, con
                           enciclopedia, estructura interna y minijuegos.</p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">Ingresar</a>
                    </article>
                </div>

                <div class="col-md-6 col-lg-4">
                    <article class="card card-categoria h-100">
                        <span class="card-num">02</span>
                        <div class="icono"><i class="fa fa-cube" aria-hidden="true"></i></div>
                        <h3>Realidad Aumentada</h3>
                        <p>Observa modelos 3D del espacio en tu propio entorno usando
                           la cámara de tu celular.</p>
                        <a href="#realidad-aumentada" class="btn btn-contorno-oro"
                           data-bitacora-accion="INGRESO_REALIDAD_AUMENTADA"
                           data-bitacora-detalle="Ingreso a realidad aumentada desde categorías">Ver en AR</a>
                    </article>
                </div>

                <div class="col-md-6 col-lg-4">
                    <article class="card card-categoria h-100">
                        <span class="card-num">03</span>
                        <div class="icono"><i class="fa fa-film" aria-hidden="true"></i></div>
                        <h3>Multimedia Educativa</h3>
                        <p>Aprende con video, una galería de imágenes de los planetas
                           y audio ambiental espacial.</p>
                        <a href="#multimedia" class="btn btn-contorno-oro"
                           data-bitacora-accion="INGRESO_MULTIMEDIA"
                           data-bitacora-detalle="Ingreso a multimedia educativa desde categorías">Ver recursos</a>
                    </article>
                </div>

            </div>
        </div>
    </section>

    <!-- ===================== REALIDAD AUMENTADA ===================== -->
    <section id="realidad-aumentada" class="seccion seccion--alt">
        <div class="container">
            <div class="seccion-encabezado">
                <p class="kicker">Tecnología inmersiva</p>
                <h2 class="seccion-titulo">Realidad Aumentada</h2>
            </div>
            <div class="row align-items-center g-5">
                <div class="col-lg-6">
                    <div class="ar-stage">
                        <model-viewer
                                src="https://modelviewer.dev/shared-assets/models/Astronaut.glb"
                                alt="Modelo 3D de un astronauta para realidad aumentada"
                                ar
                                ar-modes="webxr scene-viewer quick-look"
                                camera-controls
                                auto-rotate
                                shadow-intensity="1"
                                exposure="1.1"
                                environment-image="neutral">
                            <button slot="ar-button" class="btn btn-oro"
                                    data-bitacora-accion="INGRESO_REALIDAD_AUMENTADA"
                                    data-bitacora-detalle="Uso del modelo de realidad aumentada">
                                <i class="fa fa-mobile" aria-hidden="true"></i> Ver en mi espacio (AR)
                            </button>
                        </model-viewer>
                    </div>
                </div>
                <div class="col-lg-6">
                    <h3 class="h3 texto-oro">Lleva el espacio a tu habitación</h3>
                    <p class="text-secondary">
                        Gira el modelo 3D con el mouse o el dedo. Desde un celular,
                        toca el botón <strong>"Ver en mi espacio (AR)"</strong> para
                        proyectar el modelo en el mundo real con la cámara.
                    </p>
                    <ul class="ar-lista">
                        <li><i class="fa fa-check-circle" aria-hidden="true"></i> Compatible con Android (Scene Viewer) e iOS (Quick Look).</li>
                        <li><i class="fa fa-check-circle" aria-hidden="true"></i> No necesita instalar ninguna aplicación.</li>
                        <li><i class="fa fa-check-circle" aria-hidden="true"></i> Funciona directamente desde el navegador web.</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- ===================== MULTIMEDIA ===================== -->
    <section id="multimedia" class="seccion">
        <div class="container">
            <div class="seccion-encabezado">
                <p class="kicker">Aprende viendo y escuchando</p>
                <h2 class="seccion-titulo">Multimedia Educativa</h2>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-9">
                    <div class="marco-video">
                        <div class="ratio ratio-16x9">
                            <video controls preload="metadata" poster="${ctx}/js/textures/stars.jpg"
                                   data-bitacora-accion="INGRESO_MULTIMEDIA"
                                   data-bitacora-detalle="Reproducción del video educativo">
                                <source src="${ctx}/videos/intro-bg.mp4" type="video/mp4">
                                Tu navegador no soporta la reproducción de video.
                            </video>
                        </div>
                    </div>
                </div>
            </div>

            <div class="galeria-header">
                <p class="kicker">Laboratorio orbital</p>
                <h3 class="sub-titulo">Galería 3D de planetas</h3>
                <p class="text-secondary">
                    Observa texturas, atmósfera e iluminación en modelos giratorios antes de entrar al explorador.
                </p>
            </div>
            <div class="row g-4 galeria-3d justify-content-center">
                <div class="col-md-6 col-xl-3">
                    <article class="planet-card planet-card--earth">
                        <div class="planet-viewer">
                            <div class="planet-sphere planet-earth" aria-hidden="true">
                                <span class="planet-texture" style="background-image: url('${ctx}/js/textures/earth.jpg')"></span>
                            </div>
                        </div>
                        <span class="planet-chip">Planeta azul</span>
                        <h4>Tierra</h4>
                        <p>Océanos, continentes y atmósfera protectora para comprender nuestro hogar cósmico.</p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">Explorar</a>
                    </article>
                </div>
                <div class="col-md-6 col-xl-3">
                    <article class="planet-card planet-card--mars">
                        <div class="planet-viewer">
                            <div class="planet-sphere planet-mars" aria-hidden="true">
                                <span class="planet-texture" style="background-image: url('${ctx}/js/textures/mars.jpg')"></span>
                            </div>
                        </div>
                        <span class="planet-chip">Mundo rocoso</span>
                        <h4>Marte</h4>
                        <p>Superficie rojiza, antiguos valles y volcanes gigantes para estudiar geología planetaria.</p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">Explorar</a>
                    </article>
                </div>
                <div class="col-md-6 col-xl-3">
                    <article class="planet-card planet-card--jupiter">
                        <div class="planet-viewer">
                            <div class="planet-sphere planet-jupiter" aria-hidden="true">
                                <span class="planet-texture" style="background-image: url('${ctx}/js/textures/jupiter.jpg')"></span>
                            </div>
                        </div>
                        <span class="planet-chip">Gigante gaseoso</span>
                        <h4>Júpiter</h4>
                        <p>Bandas atmosféricas, tormentas colosales y la escala más grande del Sistema Solar.</p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">Explorar</a>
                    </article>
                </div>
                <div class="col-md-6 col-xl-3">
                    <article class="planet-card planet-card--venus">
                        <div class="planet-viewer">
                            <div class="planet-sphere planet-venus" aria-hidden="true">
                                <span class="planet-texture" style="background-image: url('${ctx}/js/textures/venus.jpg')"></span>
                            </div>
                        </div>
                        <span class="planet-chip">Atmásfera densa</span>
                        <h4>Venus</h4>
                        <p>Nubes brillantes y efecto invernadero extremo para analizar climas planetarios.</p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">Explorar</a>
                    </article>
                </div>
                <div class="col-md-6 col-xl-3">
                    <article class="planet-card planet-card--mercury">
                        <div class="planet-viewer">
                            <div class="planet-sphere planet-mercury" aria-hidden="true">
                                <span class="planet-texture" style="background-image: url('${ctx}/js/textures/mercury.jpg')"></span>
                            </div>
                        </div>
                        <span class="planet-chip">Interior rocoso</span>
                        <h4>Mercurio</h4>
                        <p>El planeta más cercano al Sol, con cráteres extremos y cambios térmicos intensos.</p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">Explorar</a>
                    </article>
                </div>
                <div class="col-md-6 col-xl-3">
                    <article class="planet-card planet-card--saturn">
                        <div class="planet-viewer">
                            <div class="planet-sphere planet-saturn" aria-hidden="true">
                                <span class="planet-ring"></span>
                                <span class="planet-texture" style="background-image: url('${ctx}/js/textures/saturn.jpg')"></span>
                            </div>
                        </div>
                        <span class="planet-chip">Anillos visibles</span>
                        <h4>Saturno</h4>
                        <p>Un gigante gaseoso con anillos brillantes que ayudan a estudiar órbitas y partículas.</p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">Explorar</a>
                    </article>
                </div>
                <div class="col-md-6 col-xl-3">
                    <article class="planet-card planet-card--uranus">
                        <div class="planet-viewer">
                            <div class="planet-sphere planet-uranus" aria-hidden="true">
                                <span class="planet-texture" style="background-image: url('${ctx}/js/textures/uranus.jpg')"></span>
                            </div>
                        </div>
                        <span class="planet-chip">Gigante helado</span>
                        <h4>Urano</h4>
                        <p>Un mundo azul verdoso con rotación inclinada y atmósfera fría rica en metano.</p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">Explorar</a>
                    </article>
                </div>
                <div class="col-md-6 col-xl-3">
                    <article class="planet-card planet-card--neptune">
                        <div class="planet-viewer">
                            <div class="planet-sphere planet-neptune" aria-hidden="true">
                                <span class="planet-texture" style="background-image: url('${ctx}/js/textures/neptune.jpg')"></span>
                            </div>
                        </div>
                        <span class="planet-chip">Azul profundo</span>
                        <h4>Neptuno</h4>
                        <p>Vientos veloces, color intenso y condiciones extremas en el límite del Sistema Solar.</p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-contorno-oro">Explorar</a>
                    </article>
                </div>
            </div>

            <div class="row justify-content-center mt-4">
                <div class="col-lg-8">
                    <div class="card panel-oscuro audio-card">
                        <div class="icono-audio"><i class="fa fa-headphones" aria-hidden="true"></i></div>
                        <h3 class="h5 texto-oro">Audio ambiental espacial</h3>
                        <p class="text-secondary mb-3">
                            El explorador 3D incluye música ambiental y efectos de sonido
                            generados en tiempo real. Actívalos con el botón de audio dentro
                            del explorador.
                        </p>
                        <a href="${ctx}/explorador.jsp" class="btn btn-oro">
                            <i class="fa fa-play" aria-hidden="true"></i> Escuchar en el explorador
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

</main>

<!-- ===================== PIE DE PÁGINA ===================== -->
<footer class="pie-sitio">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-3 col-md-6">
                <p class="pie-marca"><i class="fa fa-sun-o" aria-hidden="true"></i> SISTEMA SOLAR</p>
                <p class="small mb-0">
                    Plataforma web educativa para descubrir el universo mediante modelos 3D,
                    realidad aumentada y contenido multimedia. Un proyecto por una educación
                    de calidad para todos.
                </p>
            </div>
            <div class="col-lg-2 col-md-6">
                <p class="pie-titulo">Navegación</p>
                <ul class="pie-links">
                    <li><a href="#contenido">Inicio</a></li>
                    <li><a href="#categorias">Categorías</a></li>
                    <li><a href="#realidad-aumentada"
                           data-bitacora-accion="INGRESO_REALIDAD_AUMENTADA"
                           data-bitacora-detalle="Ingreso a realidad aumentada desde footer">Realidad Aumentada</a></li>
                    <li><a href="#multimedia"
                           data-bitacora-accion="INGRESO_MULTIMEDIA"
                           data-bitacora-detalle="Ingreso a multimedia desde footer">Multimedia</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-6">
                <p class="pie-titulo">Accesos</p>
                <ul class="pie-links">
                    <li><a href="${ctx}/explorador.jsp">Explorador 3D</a></li>
                    <li><a href="${ctx}/login.jsp">Iniciar sesión</a></li>
                    <li><a href="${ctx}/registro.jsp">Registrarse</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-6">
                <p class="pie-titulo">Proyecto</p>
                <ul class="pie-links">
                    <li><i class="fa fa-graduation-cap" aria-hidden="true"></i> ODS 4 - Educación de Calidad</li>
                    <li><i class="fa fa-university" aria-hidden="true"></i> Universidad Politécnica Salesiana</li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <p class="pie-titulo">Perfiles</p>
                <ul class="pie-links pie-social">
                    <li>
                        <a href="https://www.linkedin.com/in/jairo-alejandro-ojeda-herrera-9466543a6/"
                           target="_blank" rel="noopener noreferrer">
                            <i class="fa fa-linkedin" aria-hidden="true"></i> LinkedIn
                        </a>
                    </li>
                    <li>
                        <a href="https://github.com/Alejandro120325"
                           target="_blank" rel="noopener noreferrer">
                            <i class="fa fa-github" aria-hidden="true"></i> GitHub
                        </a>
                    </li>
                    <li>
                        <a href="https://www.instagram.com/alejo_ojeda1203/"
                           target="_blank" rel="noopener noreferrer">
                            <i class="fa fa-instagram" aria-hidden="true"></i> Instagram
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="pie-bottom">
            &copy; <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %>
            Sistema Solar &middot; Proyecto educativo - Objetivo de Desarrollo Sostenible 4
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>window.CONTEXT_PATH = "${ctx}";</script>
<script src="${ctx}/js/accesibilidad.js?v=20260603"></script>
<script src="${ctx}/js/efectos.js"></script>
<script src="${ctx}/js/bitacora.js?v=20260526"></script>
</body>
</html>
