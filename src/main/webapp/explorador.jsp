<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
  <link rel="stylesheet" href="${ctx}/css/style.css?v=20260523">
  <title>Explorador del Sistema Solar | AAA WebGL</title>
</head>
<body>

<!-- ============================================================
     BLOQUEO DE ORIENTACION - solo moviles en modo portrait
     ============================================================ -->
<div id="orientation-lock" class="orientation-lock" role="dialog" aria-modal="true">
  <div class="orientation-lock__card">
    <div class="orientation-lock__phone" aria-hidden="true">
      <span class="phone-screen"></span>
      <span class="phone-notch"></span>
      <span class="phone-button"></span>
    </div>
    <h2 class="orientation-lock__title">GIRA TU DISPOSITIVO</h2>
    <p class="orientation-lock__msg">
      Esta experiencia esta optimizada para <strong>modo horizontal</strong>.
      Por favor, gira tu telefono para iniciar la exploracion del Sistema Solar.
    </p>
  </div>
</div>

<canvas id="webgl-canvas" style="position: fixed; top: 0; left: 0; z-index: -1;"></canvas>

<!-- PANTALLA DE INTRODUCCION -->
<div id="intro-screen" class="intro-screen">
  <div class="intro-screen__backdrop"></div>
  <div class="intro-content">
    <h1 class="intro-title">SISTEMA SOLAR</h1>
    <p class="intro-subtitle">EXPLORADOR INTERACTIVO 3D &middot; MODELO ONLINE</p>

    <div class="intro-description">
      <p>El <strong>Sistema Solar</strong> es nuestro hogar cosmico: un sistema planetario formado por el <strong>Sol</strong> y los ocho planetas que orbitan a su alrededor, junto a planetas enanos, lunas, asteroides y cometas. Todo se mantiene unido por la gravedad del Sol, una estrella amarilla que concentra el <strong>99.86%</strong> de la masa total del sistema.</p>
      <p>Explora cada planeta en 3D, descubre su <em>estructura interna</em>, lee su <em>enciclopedia</em> y pon a prueba lo aprendido con <em>minijuegos tematicos</em>.</p>
    </div>

    <button class="intro-start" id="intro-start" type="button" disabled aria-label="Cargando">
      <span class="intro-start__main" id="intro-start-main">CARGANDO</span>
      <span class="intro-start__sub" id="intro-start-sub">0%</span>
    </button>

    <div class="intro-progress-wrap">
      <div id="loading-progress" class="intro-progress"></div>
    </div>

    <div class="intro-hint">
      <i class="fa fa-mouse-pointer"></i>
      <span>Haz clic en los planetas o usa el menu lateral</span>
    </div>
  </div>
</div>

<!-- Boton de audio (musica + SFX) -->
<button id="audio-toggle" class="audio-toggle is-muted" type="button" aria-label="Activar audio" title="Musica y sonidos">
  <i class="fa fa-volume-off"></i>
</button>

<!-- Barra de cuenta: usuario con sesion iniciada -->
<nav class="top-nav" id="top-nav" aria-label="Cuenta">
  <div class="nav-user">
    <i class="fa fa-user-circle fa-user" aria-hidden="true"></i>
    <span>${sessionScope.usuario.nombreCompleto}</span>
  </div>
  <a class="nav-btn nav-btn--ghost" href="${ctx}/index.jsp">Inicio</a>
  <a class="nav-btn nav-btn--cosmic" href="${ctx}/logout">Salir</a>
</nav>

<h1 class='logo' id="main-logo">SISTEMA SOLAR</h1>

<div class="planet-menu" id="planet-menu">
  <input class='planet9' id='pluto' type='radio' name='planet'>
  <label class='menu pluto' for='pluto'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Pluton</h2><h3>39,5 UA</h3></div>
  </label>

  <input class='planet8' id='neptune' type='radio' name='planet'>
  <label class='menu neptune' for='neptune'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Neptuno</h2><h3>30,1 UA</h3></div>
  </label>

  <input class='planet7' id='uranus' type='radio' name='planet'>
  <label class='menu uranus' for='uranus'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Urano</h2>    <h3>19,2 UA</h3></div>
  </label>

  <input class='planet6' id='saturn' type='radio' name='planet'>
  <label class='menu saturn' for='saturn'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Saturno</h2>  <h3>9,6 UA</h3></div>
  </label>

  <input class='planet5' id='jupiter' type='radio' name='planet'>
  <label class='jupiter menu' for='jupiter'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Jupiter</h2>  <h3>5,2 UA</h3></div>
  </label>

  <input class='planet4' id='mars' type='radio' name='planet'>
  <label class='mars menu' for='mars'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Marte</h2>    <h3>1,5 UA</h3></div>
  </label>

  <input class='planet3' id='earth' type='radio' name='planet'>
  <label class='menu earth' for='earth'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Tierra</h2>   <h3>1 UA</h3></div>
  </label>

  <input class='planet2' id='venus' type='radio' name='planet'>
  <label class='menu venus' for='venus'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Venus</h2>    <h3>0,72 UA</h3></div>
  </label>

  <input class='planet1' id='mercury' type='radio' name='planet'>
  <label class='menu mercury' for='mercury'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Mercurio</h2> <h3>0,39 UA</h3></div>
  </label>

  <input class='planet0' id='sun' type='radio' name='planet'>
  <label class='menu sun' for='sun'>
    <div class='preview'></div>
    <div class='info'><h2><div class='pip'></div>Sol</h2> <h3>0 UA</h3></div>
  </label>
</div>

<div id="planet-details" class="panel-details sci-fi">
  <!-- VISTA MENU PRINCIPAL -->
  <div class="panel-view" data-view="menu">
    <div class="panel-header">
      <button class="panel-back" id="panel-back-menu" aria-label="Volver"><i class="fa fa-chevron-left"></i></button>
      <h1 id="details-planet-name">TIERRA</h1>
      <h2 id="details-planet-type">PLANETA</h2>
    </div>

    <ul class="panel-buttons">
      <li><button class="scifi-btn" data-action="visit"><i class="fa fa-plane"></i> VISITA<i class="fa fa-caret-right caret"></i></button></li>
      <li><button class="scifi-btn" data-action="encyclopedia"><i class="fa fa-book"></i> ENCICLOPEDIA<i class="fa fa-caret-right caret"></i></button></li>
      <li><button class="scifi-btn" data-action="structure"><i class="fa fa-code-fork"></i> ESTRUCTURA<i class="fa fa-caret-right caret"></i></button></li>
      <li><button class="scifi-btn scifi-btn--game" data-action="game"><i class="fa fa-gamepad"></i> MINIJUEGO<i class="fa fa-caret-right caret"></i></button></li>
    </ul>
  </div>

  <!-- VISTA ENCICLOPEDIA -->
  <div class="panel-view" data-view="encyclopedia" hidden>
    <div class="panel-header">
      <button class="panel-back" data-back="menu" aria-label="Volver"><i class="fa fa-chevron-left"></i></button>
      <h1 class="enc-title" id="enc-planet-name">TIERRA</h1>
      <h2 id="enc-planet-type">PLANETA</h2>
    </div>
    <h3 class="section-title">ENCICLOPEDIA</h3>
    <table class="enc-table" id="enc-stats"></table>
    <div class="enc-body" id="enc-body"></div>
  </div>

  <!-- VISTA ESTRUCTURA -->
  <div class="panel-view" data-view="structure" hidden>
    <div class="panel-header">
      <button class="panel-back" data-back="menu" aria-label="Volver"><i class="fa fa-chevron-left"></i></button>
      <h1 class="enc-title" id="struct-planet-name">TIERRA</h1>
      <h2 id="struct-planet-type">PLANETA</h2>
    </div>
    <h3 class="section-title">ESTRUCTURA</h3>
    <p class="struct-intro" id="struct-intro"></p>
    <div class="struct-sections" id="struct-sections"></div>
  </div>

  <div class="panel-footer">
    <button class="footer-icon-btn" id="btn-back-orbit"><i class="fa fa-sun-o"></i> SISTEMA SOLAR</button>
    <button class="footer-icon-btn is-active"><i class="fa fa-globe"></i> PLANETA</button>
  </div>
</div>

<!-- OVERLAY DE ESTRUCTURA -->
<div id="structure-overlay" class="structure-overlay" hidden>
  <div class="struct-diagram" id="struct-diagram"></div>
</div>

<!-- MODAL DE MINIJUEGO -->
<div id="game-modal" class="game-modal" hidden>
  <div class="game-modal__backdrop" id="game-backdrop"></div>
  <div class="game-modal__card">
    <div class="game-modal__header">
      <h2 id="game-title">MINIJUEGO</h2>
      <button class="game-modal__close" id="game-close" aria-label="Cerrar">&times;</button>
    </div>
    <div class="game-modal__body" id="game-body"></div>
  </div>
</div>

<script type="importmap">
  {
    "imports": {
      "three": "https://unpkg.com/three@0.160.0/build/three.module.js",
      "three/addons/": "https://unpkg.com/three@0.160.0/examples/jsm/",
      "gsap": "https://cdn.jsdelivr.net/npm/gsap@3.12.5/+esm"
    }
  }
</script>

<!-- Ruta del contexto para que bitacora.js sepa a donde enviar las interacciones -->
<script>window.CONTEXT_PATH = "${ctx}";</script>

<script type="module" src="${ctx}/js/data.js?v=20260523"></script>
<script type="module" src="${ctx}/js/audio.js?v=20260523"></script>
<script type="module" src="${ctx}/js/intro.js?v=20260523"></script>
<!-- js/games.js se importa dinamicamente desde interaction.js (lazy load) -->
<script type="module" src="${ctx}/js/interaction.js?v=20260601"></script>
<!-- Registro de interacciones del estudiante en la bitacora -->
<script src="${ctx}/js/bitacora.js?v=20260523"></script>
</body>
</html>
