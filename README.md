# Sistema Solar - Educación de Calidad (ODS 4)

Aplicación web educativa e interactiva sobre el Sistema Solar, desarrollada como proyecto práctico del primer bimestre para la asignatura de Programación y Plataformas Web.

El sistema está orientado al **Objetivo de Desarrollo Sostenible 4: Educación de Calidad**, ya que busca fortalecer el aprendizaje mediante una experiencia visual, moderna e inmersiva, integrando contenido multimedia, modelos 3D, realidad aumentada, audio, interacción por perfiles, rankings y administración de usuarios.

---

## Descripción General

**Sistema Solar** es una plataforma web educativa que permite a los usuarios aprender sobre los planetas del Sistema Solar mediante una interfaz oscura de estilo espacial, animaciones visuales, recursos multimedia y módulos interactivos.

El proyecto cuenta con:

- Página de inicio con diseño espacial.
- Registro e inicio de sesión de usuarios.
- Manejo de sesiones con `HttpSession`.
- Perfil de estudiante.
- Perfil de administrador.
- Explorador 3D del Sistema Solar.
- Realidad aumentada.
- Videos, imágenes y audio.
- Galería de planetas.
- Ranking y puntuaciones por planeta.
- Bitácora de acciones.
- Gestión de usuarios.
- Bloqueo de usuarios.
- Base de datos PostgreSQL.
- Despliegue mediante archivo `.war` en Apache Tomcat 9.

---

## Objetivo del Proyecto

Desarrollar una aplicación web educativa relacionada con el **ODS 4: Educación de Calidad**, utilizando tecnologías web como **HTML5, CSS3, Bootstrap, JSP, Java Servlets, Apache Tomcat 9 y PostgreSQL**, incorporando recursos interactivos como modelos 3D, realidad aumentada, multimedia y perfiles de usuario.

---

## Tecnologías Utilizadas

| Categoría | Tecnología |
|---|---|
| Frontend | HTML5, CSS3, Bootstrap 5, JavaScript, JSP |
| Backend | Java Servlets, JSP |
| Servidor Web | Apache Tomcat 9 |
| Base de Datos | PostgreSQL |
| Interactividad 3D | Three.js |
| Sesiones | HttpSession |
| Construcción | Maven |
| Empaquetado | WAR |
| Control de versiones | GitHub |
| Diagramación | Draw.io |
| Arquitectura | Modelo C4 |
| Accesibilidad | Lighthouse / WAVE / axe DevTools |
| Validación CSS | W3C CSS Validator |

---

## Características Principales

- Interfaz visual moderna con temática espacial.
- Diseño oscuro elegante y responsivo.
- Planeta Tierra visible en la portada.
- Animaciones fluidas en escritorio y dispositivos móviles.
- Galería de planetas con vista previa visual.
- Explorador 3D del Sistema Solar.
- Módulo de realidad aumentada.
- Sección multimedia con recursos educativos.
- Audio ambiental.
- Registro de usuarios.
- Login con validación de credenciales.
- Sesiones por perfil.
- Perfil administrador y perfil estudiante.
- Bitácora de acciones del sistema.
- Ranking por planeta.
- Puntuaciones por usuario y planeta.
- Bloqueo de usuarios.
- Validaciones de formulario.
- Configuración externa de base de datos para despliegue en Tomcat.

---

## Perfiles del Sistema

| Perfil | Funcionalidades |
|---|---|
| Invitado | Puede ver la página de inicio, categorías, multimedia, realidad aumentada y acceder al registro o login. |
| Estudiante | Puede iniciar sesión, explorar el sistema, usar el explorador 3D, interactuar con planetas, acceder a multimedia y generar registros en la bitácora. |
| Administrador | Puede iniciar sesión, gestionar usuarios, consultar usuarios, bloquear usuarios, revisar bitácora y consultar rankings o puntuaciones. |

---

## Funcionalidades del Perfil Estudiante

El perfil estudiante permite al usuario interactuar con el contenido educativo del sistema.

Funciones principales:

- Registrarse en el sistema.
- Iniciar sesión.
- Acceder a la página principal.
- Entrar al explorador 3D.
- Interactuar con los planetas.
- Revisar contenido multimedia.
- Utilizar el módulo de realidad aumentada.
- Escuchar audio ambiental.
- Generar registros de interacción en la bitácora.
- Consultar o generar puntuaciones por planeta, según la interacción realizada.

---

## Funcionalidades del Perfil Administrador

El perfil administrador permite supervisar y gestionar el sistema.

Funciones principales:

- Iniciar sesión como administrador.
- Consultar usuarios registrados.
- Crear nuevos usuarios, si aplica.
- Actualizar información de usuarios.
- Bloquear usuarios.
- Impedir el acceso a usuarios bloqueados.
- Revisar la bitácora del sistema.
- Consultar registros de estudiantes.
- Ver acciones realizadas por usuarios.
- Revisar puntuaciones y rankings por planeta.

---

## Estructura General del Proyecto

```text
SISTEMA SOLAR/
├── database/
│   ├── migrations/
│   ├── crear_base_sistema_solar.sql
│   └── sistema_solar.sql
├── src/
│   └── main/
│       ├── java/
│       │   └── ...
│       ├── resources/
│       │   └── db.properties
│       └── webapp/
│           ├── css/
│           ├── js/
│           ├── images/
│           ├── WEB-INF/
│           ├── index.jsp
│           ├── login.jsp
│           ├── registrar.jsp
│           ├── explorador.jsp
│           └── ...
├── target/
│   └── sistema-solar.war
├── pom.xml
└── README.md
