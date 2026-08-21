# Notas para retomar mañana

## Contexto del proyecto
- **app-mobile-v3** (`tvapp`): app Flutter IPTV + herramientas de red, blanco (white-label) — se reempaqueta por ISP/cliente.
- Fusión de 2 proyectos origen (ia_building + app-mobile-v2), arquitectura de 3 capas.
- FVM 3.35.7. Cada cambio en `@freezed`/`@riverpod`/`@JsonSerializable` requiere `fvm dart run build_runner build --delete-conflicting-outputs`.

## Pendiente: automatizar ícono y nombre de app vía `.env`

### Problema
El `.env` (raíz del proyecto) ya tiene los campos para reempaquetar por ISP:
```
APP_NAME="Setimer"
APP_SIGN="tv.cdlatam.setimer"
APP_ICON="assets/isp/icons/streamlink/drawable/logo.png"
```
Pero **no están cableados a nada nativo**. Hoy cada ISP se configura **a mano**, editando `AndroidManifest.xml` / `Info.plist` / `build.gradle` directamente.

### Hallazgos (investigación ya hecha)
1. `app_configure.bat` (raíz) intenta correr `change_app_display_name` / `change_app_package_name` vía `flutter pub run`, pero **ninguno de los 2 paquetes está en `pubspec.yaml`** — el script está roto. Tampoco toca íconos.
2. `flutter_launcher_icons` **sí está instalado** (dev_dependency, `pubspec.yaml`) pero **sin archivo de configuración** (`flutter_launcher_icons.yaml`) — no hace nada.
3. `android/app/src/main/AndroidManifest.xml:24-27` → `android:label="StreamLink"` **hardcodeado**, no usa `@string/app_name`. No hay `strings.xml` con `app_name`.
4. `ios/Runner/Info.plist` → `CFBundleDisplayName`="Tvapp" vs `CFBundleName`="Bantel TV" — **inconsistentes entre sí**, evidencia de ediciones manuales sueltas.
5. `android/app/build.gradle` → `applicationId = "tv.cdlatam.streamlink.app"` hardcodeado, distinto del `APP_SIGN` de ejemplo del `.env`.
6. Sí existe la librería de assets por marca: `assets/isp/icons/<isp>/drawable/` (+150 carpetas, icon.png + logo.png) y `assets/isp/imgs/fondo/<isp>/`.
7. `Environment.appIcon/appName/appSign` (`lib/config/environment/environment.dart`) solo se usan a nivel Dart/runtime (splash screen, UI) — nunca llegan a lo nativo.

### Plan propuesto (pendiente de aprobar/implementar)
1. **Ícono**: crear `flutter_launcher_icons.yaml` apuntando a una ruta fija (ej. `assets/icon/icon.png`). Un script copia el `APP_ICON` del `.env` a esa ruta fija y corre `dart run flutter_launcher_icons` → regenera mipmaps Android + AppIcon.appiconset iOS.
2. **Nombre**: reemplazar `android:label` hardcodeado por `@string/app_name` (agregar `strings.xml`), y que un script inyecte `APP_NAME` ahí + en `CFBundleDisplayName`/`CFBundleName` del `Info.plist` (de paso corrige la inconsistencia entre esos 2 campos).
3. **Package ID (`APP_SIGN`)**: dejarlo **fuera del automatismo, manual** — cambiar el `applicationId` afecta la identidad de la app en las stores, es más riesgoso que icono/nombre.
4. Un solo script (PowerShell, ya que se trabaja en Windows) que hace 1 y 2, corrido antes de `fvm flutter build apk`.

### Siguiente paso
Confirmar con el usuario si se implementa así (ícono + nombre automatizados, package ID manual) y ejecutar.
