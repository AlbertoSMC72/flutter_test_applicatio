@echo off
echo ========================================
echo GENERADOR DE KEYSTORE PARA FLUTTER
echo ========================================
echo.

echo Este script generará un keystore para firmar tu aplicación.
echo.
echo IMPORTANTE: Guarda la contraseña que uses en un lugar seguro.
echo.

REM Crear directorio si no existe
if not exist "android\app" mkdir android\app

REM Usar la ruta exacta de Android Studio
set "KEYTOOL_PATH=C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"

if not exist "%KEYTOOL_PATH%" (
    echo ERROR: No se encontró keytool en Android Studio.
    echo Ruta buscada: %KEYTOOL_PATH%
    echo.
    echo SOLUCIONES:
    echo 1. Verifica que Android Studio esté instalado
    echo 2. O instala Java JDK desde: https://adoptium.net/
    echo.
    pause
    exit /b 1
)

echo Usando keytool: %KEYTOOL_PATH%
echo.

echo Generando keystore...
echo.

REM Generar el keystore
"%KEYTOOL_PATH%" -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo ¡KEYSTORE GENERADO EXITOSAMENTE!
    echo ========================================
    echo.
    echo Archivo creado: android/app/upload-keystore.jks
    echo.
    echo AHORA NECESITAS:
    echo 1. Editar android/key.properties
    echo 2. Cambiar 'tu_password_aqui' por la contraseña que usaste
    echo 3. Ejecutar: flutter build appbundle --release
    echo.
) else (
    echo.
    echo ERROR al generar el keystore.
    echo.
)

pause 