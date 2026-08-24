# AGENTS.md — ia_building

Contexto del repo para agentes IA y nuevos desarrolladores.

## Qué es este repo

Una familia de apps Flutter (paquete Dart raíz: `tvapp`) de CDLATAM / OnePlay Perú.
**Un mismo repo contiene productos distintos según la rama.** No asumir que dos ramas son versiones de lo mismo: pueden ser apps diferentes con backends diferentes.

## Ramas

| Rama | Producto | Login/Auth | Servidor |
|---|---|---|---|
| `main` | Base histórica del prototipo | — | — |
| `dev` | Prototipo **"WiFi Speed"** (arquitectura features/, Material 3 oscuro) | JWT moderno, campo "Email o RUT", **sin splash**, arranca directo en `/login` | `http://serverpruebabryan.com.cd-latam.com:3000` → `POST /v1/auth/login` |
| `camaras-integracion-alejandro` | App **producción OnePlay Perú** + módulo cámaras SRT/HLS | Middleware IPTV, campo "Usuario", splash 5s | `http://201.234.116.79:9090/api/inicio` |
| `newpro`, `ultimo_alexei_app` | Históricas/experimentales | — | — |

Nota: el login estilo JWT (`/v1/auth/login`) es el **más reciente** (junio 2026, rama dev).
El protocolo `/api/inicio` es el sistema **real del operador IPTV** (binding de dispositivo:
usuario, pass, devid, marca, modelo). La app de cámaras lo usa porque autentica contra el middleware en producción.

## Servidores (rama cámaras)

- **Auth/IPTV API**: `BASE_HOST` = `http://201.234.116.79:9090` (`POST /api/inicio`, sesión vía `{BASE_HOST}/{token}/inicio.json`, logout `/api/desvincular`)
- **CRM**: `CRM_HOST` = `http://201.234.116.79:8083` (consulta cliente por email post-login, guarda `cliente_id`)
- **Tools** (Check Health, diagnóstico, gaming): `TOOLS_BASE_URL` = `http://201.234.116.79:9090`
- **Webhook cámaras**: `WEBHOOK_HOST` = `http://201.234.116.79:8088`
- **Middleware registro**: `https://middlewarebantel.iptvperu.tv` (código muerto actualmente)
- **IP-Find**: `https://streetfiber.groupinmotion.com:50500`

## Configuración (.env)

- **Rama cámaras**: `.env` vive EN el repo y viaja dentro del APK (usa `flutter_dotenv`, asset declarado en pubspec). Variables documentadas en `lib/config/environment/environment.dart`.
- **Rama dev**: `.env` está en `.gitignore`; se inyecta compile-time con `--dart-define-from-file=.env`. Constantes en `lib/core/constants/app_constants.dart`.

## Setup del entorno (Windows)

- Flutter **3.35.7** en `C:\Users\santi\flutter` (en PATH de usuario); FVM 4.2.0 en `C:\Users\santi\fvm`
- **JDK obligatorio**: Temurin 21 en `C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot`,
  configurado con `flutter config --jdk-dir=...`. ⚠️ El JBR de Android Studio es Java 25 y
  **rompe** el build con Gradle 8.11.1 ("Gradle version incompatible with Java version")
- ADB/PlatformTools vía winget (`Google.PlatformTools`); `cmdline-tools` en `%LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest`, licencias aceptadas
- Emulador AVD disponible: `Medium_Phone`

## Comandos habituales

```bash
flutter pub get                                          # dependencias
dart run build_runner build --delete-conflicting-outputs # genera *.g.dart / *.freezed.dart (NO están en git, obligatorio tras clonar)
flutter run                                              # rama cámaras (.env es asset)
fvm flutter run --dart-define-from-file=.env             # rama dev
flutter emulators --launch Medium_Phone                  # emulador
```

## Flujo de arranque (rama cámaras)

1. Splash nativo Android (`launch_background.xml`)
2. `InitialLoaderScreen`: logo `assets/hub/logo_oneplay.svg` fade-in 2s → dim a los 4s
3. A los 5s: `loadSession()` → si hay sesión válida entra a `MainScreen` (hub), si no → `LoginScreen`
4. Hub "Mis productos": Eventos *(placeholder)* · IPTV ✔ · VOD *(placeholder)* · **Cámaras ✔** · Descuentos *(placeholder)* · Check Health ✔

## Rama `feat/login-nuevo`

Reemplazo **solo de vista** del login de la rama cámaras con el diseño del login nuevo de dev
(header gradiente curvo + logo blanco, campos redondeados radio 14, banner de error inline,
botón gradiente con spinner). Lógica interna intacta: `rememberRepositoryProvider` (recordar
contraseña), `authProvider.login()` contra `/api/inicio`, `saveSession()`, navegación a `MainScreen`.
Incluye fix del overflow de `Row` en `body.login.widget.dart:69` (causaba pantalla en blanco).

## Problemas conocidos

- El backend devuelve **HTTP 500** en endpoints Multicdn/URL (`201.234.116.79:9090`) — problema del servidor, no del cliente
- **MIUI/HyperOS bloquea instalaciones ADB** (`INSTALL_FAILED_USER_RESTRICTED`): activar en el teléfono "Instalar vía USB" y "Depuración USB (ajustes de seguridad)"
- La depuración inalámbrica ADB **cambia de puerto en cada sesión**: si falla `adb connect`, pedir al usuario la IP:puerto actual mostrada en "Depuración inalámbrica"; el emparejamiento (`adb pair IP:PUERTO CÓDIGO`) persiste
- Los archivos generados (`*.g.dart`, `*.freezed.dart`, `GeneratedPluginRegistrant.*`) no deben modificarse a mano ni commitearse salvo cambio real de dependencias
