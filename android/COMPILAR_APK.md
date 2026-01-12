# Compilar APK - Guía Completa

## Requisitos

- Android Studio 2022.1 o superior
- Android SDK 33
- Java JDK 17 o superior
- Gradle 8.0

## Método 1: Con Android Studio (Recomendado)

### Pasos:

1. **Descargar Android Studio**
   - Descarga desde: https://developer.android.com/studio

2. **Importar Proyecto**
   - Abre Android Studio
   - Selecciona "Open" 
   - Navega a la carpeta `/opt/pruebina/android/`
   - Espera a que Gradle sincronice

3. **Conectar Dispositivo o Emulador**
   - Conecta un dispositivo Android por USB
   - O inicia un emulador virtual
   - Activa "Developer Mode" en el dispositivo

4. **Compilar APK**
   - En el menú: `Build > Build Bundle(s) / APK(s) > Build APK(s)`
   - O presiona `Ctrl + F9`
   - El APK se generará en: `app/build/outputs/apk/debug/app-debug.apk`

5. **Instalar en Dispositivo**
   - En el menú: `Run > Run 'app'`
   - O presiona `Shift + F10`

## Método 2: Desde Línea de Comandos

### Con Gradle Wrapper incluido:

```bash
cd /opt/pruebina/android

# En Windows
gradlew.bat assembleDebug

# En Linux/Mac
./gradlew assembleDebug
```

El APK estará en: `app/build/outputs/apk/debug/app-debug.apk`

### Para Release (APK Firmado):

```bash
./gradlew assembleRelease
```

El APK estará en: `app/build/outputs/apk/release/app-release.apk`

## Método 3: Instalación Rápida

### Instalar directamente en dispositivo conectado:

```bash
cd /opt/pruebina/android

# En Windows
gradlew.bat installDebug

# En Linux/Mac
./gradlew installDebug
```

## Método 4: Usando Comandos Android

### Compilar e instalar:

```bash
# Compilar
cd /opt/pruebina/android
./gradlew assembleDebug

# Instalar en dispositivo
adb install -r app/build/outputs/apk/debug/app-debug.apk

# Ver logs
adb logcat
```

## Instalación en Dispositivo Físico

1. **Descargar el APK**
   - Desde: `app/build/outputs/apk/debug/app-debug.apk`

2. **Copiar al dispositivo** (vía USB o enviar por email)

3. **Habilitar instalación de apps desconocidas**
   - Ajustes > Seguridad > Orígenes desconocidos

4. **Instalar**
   - Abre el archivo APK
   - Presiona "Instalar"

## Solución de Problemas

### Error: Android SDK no encontrado
```bash
# Descarga e instala Android SDK Command-line Tools
# https://developer.android.com/studio/command-line/sdkmanager
```

### Error: java: not found
```bash
# Instala Java JDK 17
# En Linux (Ubuntu/Debian)
sudo apt-get install openjdk-17-jdk

# En Mac
brew install openjdk@17

# En Windows
# Descarga desde: https://adoptium.net/
```

### Error: Gradle version
```bash
# Actualiza Gradle
./gradlew wrapper --gradle-version=8.0
```

### Limpiar y reconstruir
```bash
./gradlew clean build -x test
```

## Información del APK

- **Nombre**: Mi Agenda
- **Paquete**: com.agenda.telefonos
- **Versión**: 1.0.0
- **API Mínima**: 21 (Android 5.0)
- **API Objetivo**: 33 (Android 13)
- **Tamaño aproximado**: 3-5 MB

## Configuración de Firma

Para distribuir en Google Play, necesitas firmar el APK:

### Generar Keystore:

```bash
keytool -genkey -v -keystore keystore.jks \
  -alias agenda_key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

### Compilar APK Firmado:

```bash
./gradlew assembleRelease
```

El archivo firmado estará en: `app/build/outputs/apk/release/app-release.apk`

## Distribución en Google Play

1. Crea una cuenta de desarrollador: https://play.google.com/console
2. Crea una nueva aplicación
3. Sube el APK desde `app/build/outputs/apk/release/app-release.apk`
4. Rellena los detalles de la aplicación
5. Envía para revisión

## Verificar Instalación

```bash
# Listar aplicaciones instaladas
adb shell pm list packages | grep agenda

# Lanzar aplicación
adb shell am start -n com.agenda.telefonos/.MainActivity

# Ver información de la app
adb shell dumpsys package com.agenda.telefonos
```

---

¡Tu APK está listo para compilar! 📱

Cualquier duda, consulta la [documentación oficial de Android](https://developer.android.com/docs).
