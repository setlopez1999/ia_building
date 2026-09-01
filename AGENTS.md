# AGENTS.md — ia_building

Contexto del repo para agentes IA y nuevos desarrolladores.

## Reglas del proyecto

**Leer `docs/REGLAS.md` antes de escribir código.** Son reglas del equipo, no sugerencias.
Resumen: (1) toda API consumida refleja su estado en la UI —cargando / éxito / vacío / error—
y el detalle técnico del error solo se muestra con `APP_DEBUG_MODE=true`; (2) la config por
ISP vive en el `.env`; (3) nada de datos falsos presentados como reales.

## Checklist de arranque (leer SIEMPRE antes de tocar código)

> ⚠️ Sección en construcción — el usuario definirá el contenido definitivo.
> Borrador propuesto a partir de la revisión del 2026-08-24:

- [ ] **¿En qué rama estoy?** `git branch --show-current`. Cada rama es un **producto distinto**, no una versión del mismo (ver tabla abajo). No trasladar supuestos entre ramas.
- [ ] **¿Qué backend aplica a esta rama?** `/api/inicio` (cámaras/producción) vs `/v1/auth/login` (dev). Confundirlos rompe el login.
- [ ] **¿El `.env` es asset o `--dart-define`?** Depende de la rama; en cámaras viaja dentro del APK.
- [ ] **¿Están generados los `*.g.dart` / `*.freezed.dart`?** No están en git: `build_runner` obligatorio tras clonar o tras tocar `@riverpod` / `@freezed` / `@JsonSerializable`.
- [ ] **¿JDK 21?** El JBR de Android Studio (Java 25) rompe el build.
- [ ] **¿Hay build corriendo?** No modificar archivos con una compilación activa.
- [ ] **Estado del árbol**: `pubspec.lock`, `GeneratedPluginRegistrant.*`, `android/build/`, `linux/`, `windows/` son ruido de build — no commitear.

## Qué es este repo

Una familia de apps Flutter (paquete Dart raíz: `tvapp`) de CDLATAM / OnePlay Perú.
**Un mismo repo contiene productos distintos según la rama.** No asumir que dos ramas son versiones de lo mismo: pueden ser apps diferentes con backends diferentes.

## Ramas

| Rama | Producto | Login/Auth | Servidor |
|---|---|---|---|
| `main` | Base histórica del prototipo | — | — |
| `dev` | Prototipo **"WiFi Speed"** (arquitectura features/, Material 3 oscuro) | JWT moderno, campo "Email o RUT", **sin splash**, arranca directo en `/login` | `http://serverpruebabryan.com.cd-latam.com:3000` → `POST /v1/auth/login` |
| `camaras-integracion-alejandro` | App **producción OnePlay Perú** + módulo cámaras SRT/HLS | Middleware IPTV, campo "Usuario", splash 5s | `http://201.234.116.79:9090/api/inicio` |
| `feat/login-nuevo` | **Rama actual**: cámaras + vista de login nueva | igual que cámaras (`/api/inicio`) | igual que cámaras |
| `newpro`, `ultimo_alexei_app` | Históricas/experimentales | — | — |

Nota: el login estilo JWT (`/v1/auth/login`) es el **más reciente** (junio 2026, rama dev).
El protocolo `/api/inicio` es el sistema **real del operador IPTV** (binding de dispositivo:
usuario, pass, devid, marca, modelo). La app de cámaras lo usa porque autentica contra el middleware en producción.

## Servidores (rama cámaras)

- **Auth/IPTV API**: `BASE_HOST` = `http://oneplay.iptvperu.tv` (`POST /api/inicio`, sesión vía `{BASE_HOST}/{token}/inicio.json`, logout `/api/desvincular`). **Verificado 2026-08-24**: devuelve canales y categorías reales.
  - ⚠️ Hasta el 2026-08-24 apuntaba a `http://201.234.116.79:9090`, que **no es el servidor de OnePlay Perú**: devolvía `timezone: America/Santiago`, soporte `trapemn.tv` y cuentas sin plan. Además responde los errores como **404 de nginx con HTML**, mientras que el servidor correcto responde **HTTP 200 con `{"error":404}`** — que es el formato que el código espera. Esa diferencia era la causa de la pantalla de canales vacía.
- **CRM**: `CRM_HOST` = `http://201.234.116.79:8083` (`GET /crm/clientes/by-email/{email}` post-login, guarda `cliente_id` en `LocalStorage`)
- **Tools** (Check Health, diagnóstico, gaming): `TOOLS_BASE_URL` = `http://201.234.116.79:9090`
- **Webhook cámaras**: `WEBHOOK_HOST` = `http://201.234.116.79:8088`
- **Middleware registro**: `https://middlewarebantel.iptvperu.tv` (código muerto actualmente)
- **IP-Find**: `https://streetfiber.groupinmotion.com:50500`

## Configuración (.env)

- **Rama cámaras**: `.env` vive EN el repo y viaja dentro del APK (usa `flutter_dotenv`, asset declarado en pubspec). Variables documentadas en `lib/config/environment/environment.dart`.
- **Rama dev**: `.env` está en `.gitignore`; se inyecta compile-time con `--dart-define-from-file=.env`. Constantes en `lib/core/constants/app_constants.dart`.
- `Environment` lee las claves con `!` (`dotenv.env['X']!`): **una clave faltante revienta en el arranque**, no degrada.
- Bloques del `.env`: APP CONFIG · HTTP CONFIG · GRADIENT · APP THEME · GOOGLE FONTS · IMAGE_CONFIGS · INPUT_CONFIGS.
- `APP_NAME` / `APP_SIGN` / `APP_ICON` existen para reempaquetar por ISP, pero **no están cableados a nada nativo**: hoy se edita a mano `AndroidManifest.xml` / `Info.plist` / `build.gradle`. El script `app_configure.bat` de la raíz **está roto** (invoca `change_app_display_name` / `change_app_package_name`, que no están en `pubspec.yaml`).

## Setup del entorno (Windows)

**Máquina PC1 (actual)**
- Flutter **3.41.6** en `C:\winlib\flutter`, **NO está en PATH** → invocar `& "C:\winlib\flutter\bin\flutter.bat"`
- **Sin FVM** y **sin keystore de release** (`android/key.properties` no existe) → solo builds debug

**Máquina "santi" (histórica)**
- Flutter **3.35.7** en `C:\Users\santi\flutter` (en PATH); FVM 4.2.0 en `C:\Users\santi\fvm`

**Común**
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

En PC1, anteponer la ruta completa (no hay `flutter` en PATH ni FVM):

```powershell
& "C:\winlib\flutter\bin\flutter.bat" run
```

## Flujo de arranque (rama cámaras) — verificado en código

1. `main()`: `dotenv.load()` → `LocalStorage.init()` → `NotificationService.init()` → `FcmService.init()` y `AlertSchedulerService.start()` (ambos en `try/catch` silencioso)
2. **Gate `_Initialization`** (`main.dart`): la app entera espera a que `internetCheckProvider` tenga valor; mientras tanto renderiza `SizedBox()`. Hoy el gate **siempre pasa rápido** porque `internet_check_provider.dart:11` devuelve `isConnected: true` hardcodeado y el chequeo real está comentado en la línea 12; la detección efectiva queda solo en el listener `onConnectivityChanged`
3. `MyApp`: `MaterialApp.router` con `appRouterProvider`, siempre `lightTheme` (el aspecto oscuro sale de `Environment.darkThemeColor` dentro de `app.theme.dart`, no del `darkTheme` de Material)
4. Splash nativo Android (`launch_background.xml`)
5. Ruta inicial `/` → `InitialLoaderScreen`: logo `assets/hub/logo_oneplay.svg` fade-in 2s → opacidad 0.1 a los 4s
6. A los 5s: `loadSession()` → `success` ⇒ `MainScreen` (hub); cualquier otro estado ⇒ `LoginScreen`
7. Hub "Mis productos": Eventos *(placeholder)* · IPTV ✔ · VOD *(placeholder)* · **Cámaras ✔** · Club de descuentos *(placeholder)* · Check Health ✔

## 🔑 Autenticación — patrón obligatorio

**La app tiene UN solo sistema de autenticación: `POST /api/inicio` contra
`BASE_HOST`.** Es el login que lleva años en producción y del que depende todo
el backend. No se reemplaza ni se le agrega otro en paralelo.

### El token está atado al servidor que lo emitió

Esto es lo que más confusión causó, así que queda escrito: **un token de
`/api/inicio` solo vale contra el host que lo generó.** Presentárselo a otro
servidor devuelve `401 {"success":false,"mensaje":"Token inválido"}`.

Hoy la app habla con dos servidores:

| Servidor | Qué tiene | Estado |
|---|---|---|
| `oneplay.iptvperu.tv` (`BASE_HOST`) | **Auth + IPTV** | Producción |
| `201.234.116.79:9090` (`TOOLS_BASE_URL`) | Check Health | **De pruebas** — su backend todavía no migró |

Por eso **Check Health responde 401 hoy**: recibe una sesión de producción y la
valida contra el servidor de pruebas. No es un bug de la app ni un segundo
sistema de login. Cuando el backend de herramientas migre a `oneplay`, se
cambia `TOOLS_BASE_URL` y funciona sin tocar código.

Verificado el 2026-09-01: con un token emitido por `201.234.116.79:9090`, las
rutas `/v1/config`, `/v1/dispositivos` y `/v1/gaming/servers` responden 200.
Con uno de `oneplay`, las tres dan 401.

### Regla: nadie lee la sesión por su cuenta

**`SessionTokenSource`** (`core/infraestructure/datasource/session_token_source.dart`)
es el **único lugar del proyecto autorizado a leer la clave `'data'`** de
SharedPreferences. Expone `token()`, `email()` y `userId()`.

- El **repositorio de auth** es el único que la **escribe**.
- **Todo lo demás la pide a `SessionTokenSource`.** Nunca `SharedPreferences`
  directo, nunca parseando el JSON a mano.

**Por qué:** `ToolsApiClient` abría SharedPreferences y parseaba el JSON él
mismo. Eso significaba que cualquier cambio en el almacenamiento —cifrar la
sesión, por ejemplo— iba a romper Check Health en silencio mientras el resto de
la app seguía andando. Con la fuente única, cifrar es cambiar **un solo
archivo**.

### Al agregar una pantalla nueva que necesite sesión

1. Pedir el token a `SessionTokenSource`, no al almacenamiento.
2. Si la pantalla habla con `BASE_HOST`, el token sirve tal cual.
3. Si habla con otro host, **asumir que el token no vale ahí** hasta comprobarlo.
4. Traducir el 401 a un mensaje entendible; el detalle técnico solo con
   `APP_DEBUG_MODE=true` (Regla 1.b de `docs/REGLAS.md`).

### Contrato de `/api/inicio` (validado 2026-09-01)

| Llamada | Respuesta |
|---|---|
| `POST /api/inicio` correcto | `code:200` + `info.token`, `info.us_id`, `info.limit_movil` |
| `POST /api/inicio` clave mala | `{"code":400,"mensaje":"Contraseña incorrecta"}` |
| `GET /{token}/inicio.json` válido | 200 con la sesión completa |
| `GET /{token}/inicio.json` inválido | **HTTP 200** con cuerpo `{"error":404}` |

⚠️ El token es **opaco**, con formato `115h_{devid}_${hash}`. **No es un JWT** y
va en la **ruta**, no en un header. Había comentarios en el código afirmando lo
contrario; están corregidos.

⚠️ El servidor **no devuelve `devid`** en `info`: lo inyecta la app tras el
login. Si eso cambia, el binding de dispositivo se rompe.

### Auth — comportamiento no obvio

- `Auth` es `@Riverpod(keepAlive: true)` y arranca un **`Timer.periodic` de 1 minuto** que llama `loadSession(silent: true)`: revalida el token contra el servidor **y golpea el CRM** en cada tick.
- `router.dart` **escucha `authProvider`**: los estados `initial` y `error` disparan `pushReplacementNamed(login)` desde cualquier pantalla. Un fallo de auth en background expulsa al usuario al login.
- `loadSession(silent: true)` que falla **no** limpia la sesión ni cambia el estado; en modo no-silencioso sí (`CleanSessionUseCase` + `initial`).
- `login()` no persiste nada: guardar es responsabilidad del caller (`saveSession(email)`, que además resuelve `cliente_id` en el CRM y registra el token FCM).
- Notificación en cold start: `EventNotificationRouter.queue()` encola la cámara y `MainScreen` la consume al montarse (el router aún no existe cuando llega el tap).

## Rama `feat/login-nuevo`

Reemplazo **solo de vista** del login de la rama cámaras con el diseño del login nuevo de dev
(header gradiente curvo + logo blanco, campos redondeados radio 14, banner de error inline,
botón gradiente con spinner). Lógica interna intacta: `rememberRepositoryProvider` (recordar
contraseña), `authProvider.login()` contra `/api/inicio`, `saveSession()`, navegación a `MainScreen`.
Incluye fix del overflow de `Row` en `body.login.widget.dart:69` (causaba pantalla en blanco).

**Verificada (ago 2026, PC1)**: compila y arranca OK en ZTE 8045 (`P606F02`, Android 11).
Splash → login nuevo renderiza bien; únicos errores en log los HTTP 500 de Multicdn ya documentados.

## Problemas conocidos

- El backend devuelve **HTTP 500** en endpoints Multicdn/URL (`201.234.116.79:9090`) — problema del servidor, no del cliente
- **MIUI/HyperOS bloquea instalaciones ADB** (`INSTALL_FAILED_USER_RESTRICTED`): activar en el teléfono "Instalar vía USB" y "Depuración USB (ajustes de seguridad)"
- La depuración inalámbrica ADB **cambia de puerto en cada sesión**: si falla `adb connect`, pedir al usuario la IP:puerto actual mostrada en "Depuración inalámbrica"; el emparejamiento (`adb pair IP:PUERTO CÓDIGO`) persiste
- Los archivos generados (`*.g.dart`, `*.freezed.dart`, `GeneratedPluginRegistrant.*`) no deben modificarse a mano ni commitearse salvo cambio real de dependencias
- **Mezclar APK release y debug del mismo package falla** (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`): hay que desinstalar la app antes de instalar la otra variante
- En PowerShell 5.1 `adb exec-out screencap -p > file.png` **corrompe el PNG** (CRLF): usar `adb shell screencap -p /sdcard/x.png` + `adb pull`
- "Recordar contraseña" guarda `usuario __ contraseña` en un solo string y lo parte con `split(' __ ')` accediendo a `[1]` sin validar: un valor guardado sin ese separador lanza `RangeError` en el `initState` del login
