# 📱 Agenda Telefónica - Aplicación Android

Una aplicación moderna de gestión de contactos para Android con interfaz Material Design, almacenamiento local seguro y facilidad de uso.

## 🎯 Características

✅ **Gestión Completa de Contactos**
- Agregar nuevos contactos
- Editar información existente
- Eliminar contactos
- Almacenamiento local SQLite

✨ **Interfaz Moderna**
- Diseño Material Design 3
- Colores gradientes atractivos (Morado → Azul)
- Responsive y optimizado
- Botón de acción flotante (FAB)

🔐 **Privacidad y Seguridad**
- Todos los datos se guardan localmente
- Sin sincronización en línea
- Completamente privado
- No requiere conexión a internet

⚡ **Rendimiento**
- RecyclerView optimizado
- Respuesta inmediata
- Bajo consumo de recursos
- Rápido y eficiente

## 📲 Requisitos del Sistema

| Requisito | Valor |
|-----------|-------|
| **Sistema Operativo** | Android 5.0+ (API 21) |
| **RAM** | 512 MB mínimo |
| **Espacio en Disco** | 50 MB |
| **Pantalla** | 4.5" recomendado |

## 📦 Información del APK

```
Nombre:         Agenda Telefónica
Versión:        1.0.0
Tamaño:         5.5 MB
Paquete:        com.agenda.telefonos
Build Tools:    33.0.0
Gradle:         8.0
Kotlin:         1.8.0
```

## 🚀 Instalación Rápida

### Método 1: ADB (Recomendado)
```bash
adb install -r agenda-app.apk
```

### Método 2: Manual
1. Copia `agenda-app.apk` a tu dispositivo
2. Abre el archivo con el administrador de archivos
3. Autoriza la instalación
4. Toca "INSTALAR"

## 📚 Documentación

Esta carpeta contiene la documentación completa de la aplicación:

### 1. **[MANUAL_USUARIO_AGENDA.md](MANUAL_USUARIO_AGENDA.md)** 📖
Manual completo en formato Markdown con:
- Introducción y requisitos
- Guía de instalación
- Descripción de pantallas
- Operaciones básicas (agregar, editar, eliminar)
- Características principales
- Solución de problemas
- FAQ
- Especificaciones técnicas

**Ideal para:** Lectura en terminal, GitHub, editores de texto

### 2. **[MANUAL_USUARIO_AGENDA.html](MANUAL_USUARIO_AGENDA.html)** 🌐
Manual interactivo con diseño visual completo:
- Mockups de pantallas del dispositivo
- Interfaz moderna y atractiva
- Diagramas visuales
- Tablas formateadas
- Secciones colapsables

**Ideal para:** Visualizar en navegador web, imprimir, compartir

### 3. **[GUIA_RAPIDA.md](GUIA_RAPIDA.md)** ⚡
Guía de referencia rápida:
- Resumen de operaciones
- Atajos y consejos
- Diagrama de la interfaz
- Tabla de troubleshooting
- Información técnica comprimida

**Ideal para:** Búsquedas rápidas, referencia en terminal

### 4. **[MANUAL_INSTALACION.html](MANUAL_INSTALACION.html)** 💿
Manual técnico de instalación:
- Requisitos de hardware detallados
- Métodos de instalación paso a paso
- Solución de problemas específicos
- Especificaciones técnicas completas
- Información de soporte

**Ideal para:** Problemas de instalación, configuración técnica

## 🎮 Uso Básico

### Agregar un Contacto
```
1. Toca el botón "+" (esquina inferior derecha)
2. Ingresa: Nombre, Teléfono (obligatorio), Email (opcional)
3. Toca "Guardar"
```

### Editar un Contacto
```
1. Toca la tarjeta del contacto
2. Modifica los datos
3. Toca "Guardar"
```

### Eliminar un Contacto
```
1. Abre el contacto
2. Toca "Eliminar"
3. Confirma la acción
```

## 🎨 Paleta de Colores

```
🟪 Primario:      #667eea (Morado)
🟦 Oscuro:        #5568d3 (Azul)
🟨 Acento:        #764ba2 (Púrpura)
⬜ Fondo:         #f5f5f5 (Gris)
⬛ Texto:         #333333 (Negro)
```

## 🛠️ Especificaciones Técnicas

### Stack Tecnológico
- **Lenguaje:** Kotlin 1.8.0
- **Framework:** Android AndroidX
- **Build System:** Gradle 8.0
- **Base de Datos:** SQLite 3
- **UI Framework:** Material Design 3

### Dependencias Principales
```gradle
androidx.appcompat:appcompat:1.6.1
androidx.constraintlayout:constraintlayout:2.1.4
androidx.recyclerview:recyclerview:1.3.0
com.google.android.material:material:1.9.0
androidx.lifecycle:lifecycle-runtime-ktx:2.6.1
```

### Estructura de Base de Datos
```sql
CREATE TABLE contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT,
    telefono TEXT NOT NULL,
    email TEXT
);
```

## 🔧 Solución de Problemas Rápida

| Problema | Solución |
|----------|----------|
| **App no abre** | Reinstala: `adb install -r agenda-app.apk` |
| **No se guarda contacto** | Verifica que teléfono esté completo |
| **Contacto eliminado** | Sin recuperación, sé más cuidadoso |
| **Email inválido** | Formato: usuario@dominio.com |

Para más detalles, consulta los manuales incluidos.

## 📋 FAQ Rápidas

**¿Hay sincronización en la nube?**
No, es completamente local. Perfecto para privacidad.

**¿Hay límite de contactos?**
No hay límite teórico, recomendado hasta 1000.

**¿Hay búsqueda?**
No en v1.0, planificada para v1.1.

**¿Se puede exportar?**
No en v1.0, será disponible en futuras versiones.

## 🚀 Hoja de Ruta (Roadmap)

### v1.1 (Próxima)
- 🔍 Búsqueda de contactos
- ⭐ Favoritos
- 📥 Exportar a CSV/vCard

### v1.2 (Planificado)
- 🔗 Sincronización Google Contacts
- 📸 Fotos de perfil
- 🏷️ Categorías

### v2.0 (Futuro)
- 🌐 App web complementaria
- ☁️ Backup en nube
- 🗑️ Papelera de reciclaje

## 📧 Soporte

### Reportar Problemas
- 🐛 **GitHub Issues:** [github.com/matatunos/pruebina](https://github.com/matatunos/pruebina)
- 📧 **Email:** support@agendatelefonica.com

### Apoya el Proyecto
- ⭐ Califica 5 estrellas
- 🔗 Comparte con amigos
- 💬 Deja un comentario
- 🐛 Reporta bugs

## 📄 Licencia

© 2026 Agenda Telefónica. Todos los derechos reservados.

Licencia propietaria. No se permite modificar, descompilar o distribuir sin autorización.

## 👨‍💻 Desarrollado Por

Equipo de Agenda Telefónica
- GitHub: [@matatunos](https://github.com/matatunos)
- Repositorio: [pruebina](https://github.com/matatunos/pruebina)

## 📝 Historial de Versiones

### v1.0.0 - Enero 12, 2026
- ✨ Primera versión pública
- ✅ Funcionalidad completa CRUD
- 🎨 Interfaz Material Design
- 💾 Almacenamiento SQLite
- 📱 APK compilado (5.5 MB)

---

## 🎯 Próximos Pasos

1. **Instala la app:** Usa uno de los métodos de instalación
2. **Lee el manual:** Consulta [MANUAL_USUARIO_AGENDA.html](MANUAL_USUARIO_AGENDA.html)
3. **Comienza a usar:** Agrega tus primeros contactos
4. **Reporta issues:** Si encuentras problemas, avísanos

---

**¡Gracias por usar Agenda Telefónica!** 📱✨

Para más información, abre [MANUAL_USUARIO_AGENDA.html](MANUAL_USUARIO_AGENDA.html) en tu navegador.
