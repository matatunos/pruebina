# Agenda de Teléfonos - App Android

Aplicación Android nativa para gestionar tus contactos de teléfono con una interfaz moderna y colores bonitos.

## Características

- ✅ **Agregar contactos** - Crea nuevos contactos fácilmente
- ✅ **Editar contactos** - Modifica la información existente
- ✅ **Eliminar contactos** - Borra contactos que ya no necesites
- ✅ **Almacenamiento local** - Los datos se guardan en SQLite
- ✅ **Interfaz moderna** - Diseño material design con colores atractivos
- ✅ **Responsive** - Funciona perfectamente en todos los tamaños de pantalla
- ✅ **Fácil de usar** - Interfaz intuitiva y clara

## Requisitos

- Android 5.0+ (API 21)
- Android Studio (para compilar)
- SDK de Android 33

## Estructura del Proyecto

```
android/
├── MainActivity.kt                 # Pantalla principal con lista de contactos
├── DetailActivity.kt              # Pantalla de crear/editar contacto
├── model/
│   └── Contact.kt                # Modelo de datos
├── data/
│   ├── ContactDatabaseHelper.kt   # Helper de SQLite
│   └── ContactRepository.kt       # Repositorio de datos
├── adapter/
│   └── ContactAdapter.kt          # Adaptador para RecyclerView
├── layout/
│   ├── activity_main.xml          # Layout principal
│   ├── activity_detail.xml        # Layout de detalle
│   └── item_contact.xml           # Layout de item de contacto
├── drawable/                      # Iconos vectoriales
├── values/
│   ├── colors.xml                # Paleta de colores
│   └── strings.xml               # Textos de la app
└── AndroidManifest.xml           # Configuración de la app
```

## Instalación

### Opción 1: Con Android Studio

1. Abre Android Studio
2. Selecciona "Open" y navega a la carpeta `android/`
3. Espera a que Gradle descargue las dependencias
4. Conecta un dispositivo Android o inicia un emulador
5. Presiona "Run" o Ctrl+R para instalar y ejecutar

### Opción 2: Desde línea de comandos

```bash
# Compilar APK
cd android
./gradlew build

# Instalar en dispositivo conectado
./gradlew installDebug

# Ejecutar en emulador
./gradlew runDebug
```

## Tecnologías Utilizadas

- **Lenguaje**: Kotlin
- **Base de datos**: SQLite
- **UI**: XML Layouts + Material Design
- **Architecture**: MVVM Pattern
- **Build Tool**: Gradle

## Funcionalidades Detalladas

### Lista de Contactos
- Vista en RecyclerView
- Scroll suave
- Botones de editar y eliminar en cada contacto
- Estado vacío personalizado

### Agregar/Editar Contacto
- Campos de entrada para nombre, teléfono y correo
- Validación de campos obligatorios
- Confirmación visual con Toasts
- Botón de cancelar

### Eliminar Contacto
- Confirmación mediante diálogo
- Eliminación segura

## Paleta de Colores

- **Primario**: #667eea (Morado)
- **Primario Oscuro**: #5568d3
- **Acento**: #764ba2
- **Fondo**: #f5f5f5
- **Texto Principal**: #212121
- **Texto Secundario**: #757575

## Debugging

### Ver logs en tiempo real
```bash
adb logcat
```

### Limpiar caché y reinstalar
```bash
./gradlew clean && ./gradlew installDebug
```

## Próximas Mejoras Planeadas

- [ ] Búsqueda y filtrado de contactos
- [ ] Sincronización con Google Contacts
- [ ] Exportar/Importar contactos (CSV, vCard)
- [ ] Categorías de contactos
- [ ] Llamadas directas desde la app
- [ ] Compartir contactos
- [ ] Interfaz oscura (Dark Mode)

## Licencia

Este proyecto está disponible bajo la licencia MIT.

---

¡Disfruta tu agenda de teléfonos en Android! 📱
