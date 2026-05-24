# Instrucciones de despliegue - Sistema Solar

Proyecto: **Sistema Solar - Plataforma educativa interactiva basada en el ODS 4 Educacion de Calidad**

Tecnologias principales: JSP, Java, HTML5, CSS3, Bootstrap, JavaScript, Apache Tomcat 9 y PostgreSQL.

El proyecto se empaqueta como:

```text
target/sistema-solar.war
```

## 1. Configuracion de base de datos

La conexion PostgreSQL esta centralizada en:

```text
src/main/java/com/sistemasolar/dao/ConexionBD.java
```

La configuracion empaquetada por defecto esta en:

```text
src/main/resources/db.properties
```

El archivo debe usar estas claves:

```properties
db.url=jdbc:postgresql://localhost:5432/sistema_solar
db.user=postgres
db.password=root
```

Tambien se puede configurar sin recompilar el WAR creando este archivo en Tomcat:

```text
${catalina.base}/conf/sistema-solar/database.properties
```

Ese archivo externo usa las mismas claves:

```properties
db.url=jdbc:postgresql://localhost:5432/sistema_solar
db.user=postgres
db.password=1234
```

Prioridad de configuracion:

1. Archivo externo de Tomcat: `${catalina.base}/conf/sistema-solar/database.properties`.
2. Propiedades JVM o variables de entorno: `db.url`, `db.user`, `db.password`, `DB_URL`, `DB_USER`, `DB_PASSWORD`.
3. Archivo empaquetado en el WAR: `src/main/resources/db.properties`.

En Windows, si Tomcat esta instalado en `C:\Tomcat\apache-tomcat-9.0.118`, el archivo externo esperado es:

```text
C:\Tomcat\apache-tomcat-9.0.118\conf\sistema-solar\database.properties
```

Contenido para la VM:

```properties
db.url=jdbc:postgresql://localhost:5432/sistema_solar
db.user=postgres
db.password=1234
```

Al arrancar Tomcat, la consola debe mostrar mensajes parecidos a:

```text
[DB] Leyendo configuración desde: C:\Tomcat\apache-tomcat-9.0.118\conf\sistema-solar\database.properties
[DB] Archivo existe: true
[DB] URL: jdbc:postgresql://localhost:5432/sistema_solar
[DB] USER: postgres
[DB] PASSWORD cargada: sí
```

## 2. Archivos SQL

Los scripts de base de datos estan en:

```text
database/crear_base_sistema_solar.sql
database/sistema_solar.sql
database/migrations/002_planetas_puntuaciones.sql
```

Orden correcto para instalacion desde cero:

1. Ejecutar `database/crear_base_sistema_solar.sql` conectado a la base `postgres`.
2. Conectarse a la base `sistema_solar`.
3. Ejecutar `database/sistema_solar.sql`.

El archivo `sistema_solar.sql` crea:

- Tabla `usuarios`.
- Tabla `planetas`.
- Tabla `puntuaciones_planeta`.
- Tabla `bitacora`.
- Indices.
- Usuario administrador inicial.
- Usuario estudiante de ejemplo.
- Datos iniciales de planetas.
- Datos de prueba de puntuaciones y bitacora.

Credenciales iniciales del administrador:

```text
email: admin@gmail.com
clave: Admin123
```

## 3. Despliegue en maquina local

### 3.1 Configurar PostgreSQL local

Datos locales:

```text
Host: localhost
Puerto: 5432
Base de datos: sistema_solar
Usuario: postgres
Clave: root
```

Configurar `src/main/resources/db.properties` asi:

```properties
db.url=jdbc:postgresql://localhost:5432/sistema_solar
db.user=postgres
db.password=root
```

### 3.2 Crear base de datos local

Desde pgAdmin:

1. Abrir Query Tool conectado a la base `postgres`.
2. Ejecutar `database/crear_base_sistema_solar.sql`.
3. Cambiar la conexion a la base `sistema_solar`.
4. Ejecutar `database/sistema_solar.sql`.

Desde consola con `psql`:

```bash
psql -U postgres -d postgres -f database/crear_base_sistema_solar.sql
psql -U postgres -d sistema_solar -f database/sistema_solar.sql
```

### 3.3 Generar el WAR con Maven

Desde la raiz del proyecto:

```bash
mvn clean package
```

Si usas el Maven incluido en IntelliJ IDEA en Windows:

```powershell
$env:JAVA_HOME='C:\Users\aleja\.jdks\ms-21.0.7'
& 'C:\Users\aleja\AppData\Local\Programs\IntelliJ IDEA Ultimate\plugins\maven\lib\maven3\bin\mvn.cmd' clean package
```

El WAR se genera en:

```text
target/sistema-solar.war
```

### 3.4 Ejecutar en Tomcat local

Copiar el archivo:

```text
target/sistema-solar.war
```

a la carpeta:

```text
TOMCAT_HOME/webapps/
```

Luego iniciar Tomcat y acceder a:

```text
http://localhost:8080/sistema-solar
```

## 4. Despliegue en VM 172.17.42.138

Datos de la VM:

```text
IP: 172.17.42.138
Clave de acceso a VM: Alejo1203
PostgreSQL usuario: postgres
PostgreSQL clave: 1234
Base de datos: sistema_solar
```

Si Tomcat y PostgreSQL estan en la misma VM, la conexion debe ser:

```properties
db.url=jdbc:postgresql://localhost:5432/sistema_solar
db.user=postgres
db.password=1234
```

### 4.1 Crear base de datos en la VM

Copiar la carpeta `database/` a la VM o subir los archivos SQL.

Ejecutar conectado a PostgreSQL:

```bash
psql -U postgres -d postgres -f database/crear_base_sistema_solar.sql
psql -U postgres -d sistema_solar -f database/sistema_solar.sql
```

Si usas pgAdmin o DBeaver:

1. Conectarse a PostgreSQL con usuario `postgres` y clave `1234`.
2. Abrir Query Tool conectado a `postgres`.
3. Ejecutar `crear_base_sistema_solar.sql`.
4. Cambiar a la base `sistema_solar`.
5. Ejecutar `sistema_solar.sql`.

### 4.2 Configurar conexion en Tomcat de la VM

Opcion recomendada: archivo externo de Tomcat.

Crear carpeta:

```bash
mkdir -p $CATALINA_BASE/conf/sistema-solar
```

Crear archivo:

```text
$CATALINA_BASE/conf/sistema-solar/database.properties
```

Contenido:

```properties
db.url=jdbc:postgresql://localhost:5432/sistema_solar
db.user=postgres
db.password=1234
```

Si no usas archivo externo, cambia `src/main/resources/db.properties` antes de generar el WAR y vuelve a ejecutar `mvn clean package`.

### 4.3 Copiar WAR a Tomcat en la VM

Copiar:

```text
target/sistema-solar.war
```

a:

```text
$TOMCAT_HOME/webapps/
```

Antes de copiar una version nueva, detener Tomcat y borrar la version anterior:

```text
webapps/sistema-solar
webapps/sistema-solar.war
```

Reiniciar Tomcat:

```bash
$TOMCAT_HOME/bin/shutdown.sh
$TOMCAT_HOME/bin/startup.sh
```

Si Tomcat esta como servicio:

```bash
sudo systemctl restart tomcat
```

Acceder desde el navegador:

```text
http://172.17.42.138:8080/sistema-solar
```

Si Tomcat usa otro puerto, reemplazar `8080` por el puerto real.

## 5. Despliegue en servidor final de la docente

Datos entregados:

```text
Servidor Web: 172.17.42.107:8085
Usuario web: admin
Clave web: admin
Servidor Base de Datos: 172.17.42.121
Usuario BD: alumno
Clave BD: 1234
Base de datos: sistema_solar
```

La conexion de la aplicacion debe apuntar a:

```properties
db.url=jdbc:postgresql://172.17.42.121:5432/sistema_solar
db.user=alumno
db.password=1234
```

Opcion recomendada en el servidor web:

1. Subir `sistema-solar.war` al Tomcat del servidor `172.17.42.107:8085`.
2. Configurar archivo externo en Tomcat:

```text
${catalina.base}/conf/sistema-solar/database.properties
```

con:

```properties
db.url=jdbc:postgresql://172.17.42.121:5432/sistema_solar
db.user=alumno
db.password=1234
```

3. Restaurar la base en el servidor PostgreSQL `172.17.42.121`.
4. Reiniciar Tomcat.
5. Acceder a:

```text
http://172.17.42.107:8085/sistema-solar
```

## 6. Validacion despues del despliegue

Revisar lo siguiente:

- La pagina de inicio carga correctamente.
- El registro de usuario funciona.
- El login funciona.
- El usuario administrador puede ingresar al panel.
- El estudiante puede ingresar al sistema.
- La bitacora registra interacciones.
- El bloqueo de usuarios funciona.
- El explorador 3D carga correctamente.
- La realidad aumentada y multimedia cargan correctamente.
- Las texturas y archivos estaticos se sirven desde el contexto `/sistema-solar/`.

## 7. Comandos rapidos

Generar WAR:

```bash
mvn clean package
```

Crear base:

```bash
psql -U postgres -d postgres -f database/crear_base_sistema_solar.sql
```

Crear tablas y datos:

```bash
psql -U postgres -d sistema_solar -f database/sistema_solar.sql
```

URL local:

```text
http://localhost:8080/sistema-solar
```

URL VM:

```text
http://172.17.42.138:8080/sistema-solar
```

URL servidor docente:

```text
http://172.17.42.107:8085/sistema-solar
```
