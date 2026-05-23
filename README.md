# Sistema Solar - Educacion de Calidad (ODS 4)

Aplicacion web educativa sobre el Sistema Solar con experiencia visual oscura,
modelos 3D, realidad aumentada, multimedia, minijuegos, ranking por planeta y
panel administrativo.

## Tecnologias

- Frontend: HTML5, CSS3, Bootstrap 5, JSP y JavaScript
- 3D: Three.js en el explorador
- Backend: Java Servlets + JSP
- Servidor: Apache Tomcat 9
- Base de datos: PostgreSQL
- Construccion: Maven (`.war`)
- Sesiones: `HttpSession`

## Perfiles

| Perfil | Funcion |
|---|---|
| Invitado | Ver inicio, categorias, realidad aumentada, multimedia y registrarse |
| Estudiante | Iniciar sesion, navegar el home y entrar al explorador 3D |
| Administrador | Gestionar usuarios, bitacora y rankings por planeta |

## Base de datos local

Datos configurados en `src/main/resources/db.properties`:

```properties
db.url=jdbc:postgresql://localhost:5432/sistema_solar
db.user=postgres
db.password=root
```

Crear la base:

```sql
-- Ejecutar conectado a la base postgres
CREATE DATABASE sistema_solar;
```

Luego conectarse a `sistema_solar` y ejecutar:

```text
database/sistema_solar.sql
```

Tambien existe un script separado para crear solo la base:

```text
database/crear_base_sistema_solar.sql
```

## Modelo de datos principal

- `usuarios`: datos de login, rol y estado.
- `planetas`: catalogo de planetas.
- `puntuaciones_planeta`: relacion usuario-planeta con puntaje, progreso y fechas.
- `bitacora`: registro de acciones del sistema.

La relacion evita duplicados con `UNIQUE(usuario_id, planeta_id)` y permite:

- ranking por planeta;
- puntuacion de un alumno en cada planeta;
- muchos usuarios por planeta;
- varios planetas por usuario.

## Ejecutar en IntelliJ IDEA

1. Abrir la carpeta del proyecto.
2. Cargar Maven desde `pom.xml`.
3. Configurar Apache Tomcat 9.
4. En Deployment usar `sistema-solar:war exploded`.
5. Context path: `/sistema-solar`.
6. Abrir `http://localhost:8080/sistema-solar/`.

## Administrador de prueba

El script SQL crea:

- Correo: `admin@gmail.com`
- Clave: `Admin123`

El inicializador Java usa esas mismas credenciales si el admin aun no existe.

## Generar WAR

```bash
mvn clean package
```

El archivo queda en:

```text
target/sistema-solar.war
```

## Accesibilidad

El proyecto conserva dos elementos:

1. Enlace "Saltar al contenido principal".
2. Control A- / A+ para ajustar el tamano del texto.
