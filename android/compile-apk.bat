@echo off
REM Script para compilar la app Android en Windows
REM Uso: compile-apk.bat [debug|release]

setlocal enabledelayedexpansion

set BUILD_TYPE=%1
if "%BUILD_TYPE%"=="" set BUILD_TYPE=debug

set "PROJECT_DIR=%~dp0"

echo ================================================
echo Compilando APK para Mi Agenda
echo ================================================
echo Tipo de compilacion: %BUILD_TYPE%
echo Directorio: %PROJECT_DIR%
echo.

REM Compilar
echo Compilando...
if "%BUILD_TYPE%"=="release" (
    call "%PROJECT_DIR%gradlew.bat" clean assembleRelease -x test
    set "APK_PATH=%PROJECT_DIR%app\build\outputs\apk\release\app-release.apk"
) else (
    call "%PROJECT_DIR%gradlew.bat" clean assembleDebug -x test
    set "APK_PATH=%PROJECT_DIR%app\build\outputs\apk\debug\app-debug.apk"
)

echo.
echo ================================================
echo Compilacion completada
echo ================================================
echo.
echo APK generado en:
echo    %APK_PATH%
echo.

REM Verificar si adb está disponible
where adb >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Deseas instalar el APK en tu dispositivo? (s/n)
    set /p response=
    if /i "%response%"=="s" (
        echo Instalando...
        call adb install -r "%APK_PATH%"
        echo Instalado exitosamente
        echo.
        echo Lanzando aplicacion...
        call adb shell am start -n com.agenda.telefonos/.MainActivity
    )
)

echo.
echo Listo!
pause
