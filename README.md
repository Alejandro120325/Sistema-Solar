# Sistema Solar - Educacion de Calidad (ODS 4)

Aplicacion web educativa sobre el Sistema Solar. Permite explorar el Sol y los
planetas en un motor 3D interactivo, con realidad aumentada, multimedia,
minijuegos y un sistema de usuarios con tres perfiles.

Proyecto enmarcado en el **Objetivo de Desarrollo Sostenible 4: Educacion de Calidad**.

## Tecnologias

- **Frontend:** HTML5, CSS3, Bootstrap 5, JSP, JavaScript (Three.js para 3D)
- **Backend:** Java (Servlets + JSP), Apache Tomcat 9
- **Base de datos:** PostgreSQL
- **Construccion:** Maven (empaquetado `.war`)
- **Seguridad:** sesiones (`HttpSession`) y contrasenas cifradas con BCrypt

## Perfiles de usuario

| Perfil | Que puede hacer |
|---|---|
| Invitado | Ver la pagina de inicio, la realidad aumentada, la multimedia y registrarse |
| Estudiante | Todo lo anterior + explorar el Sistema Solar en 3D |
| Administrador | Gestionar usuarios (crear, editar, bloquear, eliminar) y revisar la bitacora |

## Estructura del proyecto

```
SISTEMA SOLAR/
├── pom.xml                          Configuracion de Maven
├── database/sistema_solar.sql       Script de la base de datos PostgreSQL
└── src/main/
    ├── java/com/sistemasolar/
    │   ├── modelo/      Usuario, Bitacora
    │   ├── dao/         ConexionBD, UsuarioDAO, BitacoraDAO
    │   ├── controlador/ Servlets (login, registro, admin, etc.)
    │   └── filtro/      Filtros de seguridad
    ├── resources/db.properties      Datos de conexion a la BD
    └── webapp/
        ├── WEB-INF/web.xml + vistas/admin/   Paginas del panel admin
        ├── css/  js/  img/          Estilos, motor 3D y assets
        ├── index.jsp                Pagina de inicio
        ├── login.jsp  registro.jsp  Autenticacion
        └── explorador.jsp           Motor 3D del Sistema Solar
```

## Como ejecutar (local)

1. Instala **PostgreSQL** y crea la base de datos:
   ```sql
   CREATE DATABASE sistema_solar;
   ```
2. Ejecuta el script `database/sistema_solar.sql` sobre esa base de datos.
3. Revisa `src/main/resources/db.properties` y ajusta usuario/clave de PostgreSQL.
4. Abre el proyecto en **IntelliJ IDEA** (detecta `pom.xml` como proyecto Maven).
5. Configura un servidor **Tomcat 9** y despliega el artefacto `war exploded`.
6. Abre `http://localhost:8080/sistema-solar/`

## Administrador por defecto

La aplicacion crea el administrador automaticamente al arrancar:

- **Correo:** `admin@sistemasolar.com`
- **Clave:** `admin12345`

## Generar el archivo .war

Con Maven: `mvn clean package` -> genera `target/sistema-solar.war`

## Accesibilidad

El sitio incluye dos elementos de accesibilidad:
1. Enlace "Saltar al contenido principal" (visible al navegar con el teclado).
2. Barra para ajustar el tamano del texto y activar el modo de alto contraste.

## Notas

- El video de la seccion Multimedia (`index.jsp`) usa un id de ejemplo:
  reemplaza `TU_ID_DE_VIDEO` por el id de un video de YouTube real.
- Las texturas de los planetas son imagenes de alta resolucion; si el `.war`
  resulta muy pesado para subirlo al servidor, conviene optimizarlas.

## Autor

Alejandro Ojeda - Universidad Politecnica Salesiana
