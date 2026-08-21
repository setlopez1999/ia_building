@echo off
SETLOCAL EnableDelayedExpansion

REM Leer el archivo .env
for /f "tokens=1,* delims==" %%A in ('type .env') do (
    REM Reemplazar el nombre de la aplicación en AndroidManifest.xml
    if "%%A"=="APP_NAME" (
        flutter pub run change_app_display_name:main %%B
    )

    REM Reemplazar el nombre del paquete en AndroidManifest.xml y Info.plist
    if "%%A"=="APP_SIGN" (
        flutter pub run change_app_package_name:main %%B
    )
)