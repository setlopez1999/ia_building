# Health Check Extension - Reglas del proyecto

Lee estos archivos al iniciar para orientarte:

- `docs/METAS.md` - Casos de uso de la app organizados por pantalla
- `docs/REGLAS.md` - Reglas de bitacora y funcionamiento
- `docs/ULTIMOHECHO.md` - Bitacora de la ultima sesion
- `docs/PLANEADO.md` - Tareas pendientes

## Stack
- Flutter 3.35.7 via FVM
- Riverpod + GoRouter
- Clean Architecture (domain/data/presentation)

## Comandos
- Build runner: `fvm flutter pub run build_runner build --delete-conflicting-outputs`
- Analyze: `fvm flutter analyze`
- Build APK debug: `fvm flutter build apk --debug`

## Convenciones
- Comentarios en espanol
- Sin emojis en codigo
- Domain layer pura Dart (sin Flutter)
- No modificar archivos en `lib/screens/` sin permiso explicito
