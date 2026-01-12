#!/bin/bash

# Script para compilar la app Android
# Uso: ./compile-apk.sh [debug|release]

set -e

BUILD_TYPE=${1:-debug}
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================================"
echo "📱 Compilando APK para Mi Agenda"
echo "================================================"
echo "Tipo de compilación: $BUILD_TYPE"
echo "Directorio: $PROJECT_DIR"
echo ""

# Verificar si existe gradlew
if [ ! -f "$PROJECT_DIR/gradlew" ]; then
    echo "❌ Error: gradlew no encontrado"
    echo "Descargando Gradle..."
    cd "$PROJECT_DIR"
    wget -q https://services.gradle.org/gradle-wrapper/gradle-8.0-all.zip
    unzip -q gradle-8.0-all.zip
fi

# Compilar
echo "⏳ Compilando..."
if [ "$BUILD_TYPE" = "release" ]; then
    cd "$PROJECT_DIR"
    ./gradlew clean assembleRelease -x test
    APK_PATH="$PROJECT_DIR/app/build/outputs/apk/release/app-release.apk"
else
    cd "$PROJECT_DIR"
    ./gradlew clean assembleDebug -x test
    APK_PATH="$PROJECT_DIR/app/build/outputs/apk/debug/app-debug.apk"
fi

echo ""
echo "================================================"
echo "✅ Compilación completada"
echo "================================================"
echo ""
echo "📦 APK generado en:"
echo "   $APK_PATH"
echo ""
echo "📊 Tamaño del APK:"
ls -lh "$APK_PATH" | awk '{print "   " $5}'
echo ""

# Si está conectado un dispositivo, ofrecer instalar
if command -v adb &> /dev/null; then
    echo "¿Deseas instalar el APK en tu dispositivo? (s/n)"
    read -r response
    if [ "$response" = "s" ] || [ "$response" = "S" ]; then
        echo "📲 Instalando..."
        adb install -r "$APK_PATH"
        echo "✅ Instalado exitosamente"
        echo ""
        echo "🚀 Lanzando aplicación..."
        adb shell am start -n com.agenda.telefonos/.MainActivity
    fi
fi

echo ""
echo "¡Listo! 🎉"
