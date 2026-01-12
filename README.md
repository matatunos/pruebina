# Agenda de Teléfonos - Docker

Una agenda de teléfonos moderna con interfaz web creada en PHP, lista para ejecutarse con Docker.

## Características

- ✅ Agregar contactos (Altas)
- ✅ Eliminar contactos (Bajas)
- ✅ Editar contactos (Modificaciones)
- ✅ Interfaz moderna con colores bonitos
- ✅ Font Awesome icons
- ✅ Almacenamiento en JSON
- ✅ Totalmente responsive

## Requisitos

- Docker
- Docker Compose

## Instalación y Ejecución

### Opción 1: Con Docker Compose (Recomendado)

```bash
# Clonar o descargar el proyecto
cd agenda-telefonos

# Iniciar la aplicación
docker-compose up -d

# La aplicación estará disponible en http://localhost:8080
```

### Opción 2: Con Docker (Sin Docker Compose)

```bash
# Construir la imagen
docker build -t agenda-telefonos .

# Ejecutar el contenedor
docker run -d \
  --name agenda-app \
  -p 8080:80 \
  -v $(pwd):/var/www/html \
  agenda-telefonos

# La aplicación estará disponible en http://localhost:8080
```

## Comandos Docker Compose

```bash
# Ver logs en tiempo real
docker-compose logs -f

# Detener la aplicación
docker-compose stop

# Reiniciar la aplicación
docker-compose restart

# Eliminar contenedores y volúmenes
docker-compose down

# Reconstruir la imagen
docker-compose build --no-cache
```

## Estructura de Archivos

```
agenda-telefonos/
├── index.php              # Aplicación principal
├── style.css             # Estilos CSS
├── Dockerfile            # Configuración de Docker
├── docker-compose.yml    # Configuración de Docker Compose
├── .dockerignore         # Archivos a ignorar en Docker
├── README.md             # Este archivo
└── contacts.json         # Archivo de datos (se crea automáticamente)
```

## Datos Persistentes

Los contactos se guardan en el archivo `contacts.json` en la misma carpeta de la aplicación. Este archivo se persiste automáticamente en Docker.

## Puerto

- Por defecto, la aplicación se ejecuta en el puerto **8080**
- Puedes cambiar esto editando el archivo `docker-compose.yml` en la sección `ports`

## Solución de Problemas

### El puerto 8080 ya está en uso
Cambia el puerto en `docker-compose.yml`:
```yaml
ports:
  - "8081:80"  # Usa el puerto 8081 en su lugar
```

### Los datos no se guardan
Verifica que los permisos del directorio sean correctos y que el volumen esté correctamente montado en `docker-compose.yml`

### Ver estado de contenedores
```bash
docker-compose ps
```

## Desarrollo Local (sin Docker)

Si prefieres ejecutar la aplicación sin Docker:

```bash
# Necesitas PHP 7.4+ con Apache
php -S localhost:8000
```

Luego accede a `http://localhost:8000` en tu navegador.

---

¡Disfruta tu agenda de teléfonos! 📱
