# Nueva Arquitectura — WiFi Speed App

## Estructura de carpetas (`lib/`)

```
lib/
├── data/                          ← CAPA DE DATOS
│   ├── models/                    ← Modelos de dominio (Freezed)
│   │   ├── user.dart              ← User (PERFIL-1)
│   │   ├── notificacion.dart      ← Notificacion (NOTIF-1)
│   │   ├── diagnostico.dart       ← Diagnostico + DiagnosticoRequest + DiagnosticoSaveResult
│   │   ├── fibra.dart             ← Fibra (FIBRA-1)
│   │   ├── dispositivo.dart       ← Dispositivo (DISP-1)
│   │   ├── servidor_juego.dart    ← ServidorJuego (GAMING-1)
│   │   └── app_config.dart        ← AppConfig + NetworkTargets + AuthResult
│   ├── repositories/
│   │   ├── interfaces/            ← Contratos abstractos (una interfaz por dominio)
│   │   └── impl/                  ← Implementaciones reales con Dio
│   └── sources/
│       ├── remote/api_client.dart ← Dio + interceptor JWT automático
│       └── local/local_storage.dart ← SharedPreferences (token, clienteId, ping IPs, assets_version)
│
├── logic/                         ← CAPA DE LÓGICA (StateNotifier / Riverpod)
│   ├── auth/auth_notifier.dart    ← Login / Logout
│   ├── diagnostico/diagnostico_notifier.dart ← Flujo completo de diagnóstico (§14 del plan)
│   └── check_health/wifi_notifier.dart ← Cambiar SSID / contraseña
│
├── view/                          ← CAPA DE VISTA (vistas preservadas intactas)
│   ├── screens/
│   │   ├── home/                  ← HomeScreen (era HubScreen) + ServiceLoadingScreen
│   │   ├── check_health/          ← CheckHealthScreen (era HomeScreen)
│   │   ├── diagnostico/           ← DiagnosticoScreen + DiagnosticoResultScreen
│   │   ├── historial/             ← HistorialScreen (era HistoryScreen)
│   │   ├── gaming/                ← GamingScreen + GamingDetailScreen + GamingStreamingScreen
│   │   ├── streaming/             ← StreamingScreen + StreamingDetailScreen
│   │   ├── chat/                  ← ChatScreen
│   │   ├── asistencia/            ← AsistenciaIntroScreen + AsistenciaLoadingScreen + AsistenciaProblemScreen + AsistenciaSuccessScreen
│   │   ├── offline/               ← OfflineScreen + OfflineResultScreen
│   │   ├── change_password/       ← ChangePasswordScreen + ChangePasswordSuccessScreen
│   │   └── devices/               ← DevicesScreen
│   └── shared/
│       └── app_colors.dart        ← Colores globales
│
└── core/
    ├── constants/app_constants.dart ← URLs base, rutas de navegación
    ├── services/network_analyzer_service.dart ← Ping nativo + SpeedTest
    └── providers/providers.dart   ← FUENTE ÚNICA DE VERDAD de todos los providers Riverpod
```

## Mapa de vistas → datos requeridos

| Vista | Datos necesarios | Provider / Fuente |
|-------|-----------------|-------------------|
| `HomeScreen` | Perfil usuario, notificaciones, slider | `perfilProvider`, `notificacionesProvider` |
| `CheckHealthScreen` | SSID/dBm/canal (nativo), dispositivos, fibra | `dispositivosProvider`, `fibraProvider`, `NetworkAnalyzerService` |
| `DiagnosticoScreen` | Flujo paso a paso (ping + speed + fibra) | `diagnosticoNotifierProvider` |
| `DiagnosticoResultScreen` | Resultado del último diagnóstico | `diagnosticoNotifierProvider` |
| `HistorialScreen` | Lista de diagnósticos pasados | `historialDiagnosticoProvider` |
| `GamingScreen` | Servidores de juegos con métricas | `servidoresJuegoStreamProvider` |
| `GamingDetailScreen` | Detalle de un servidor | `servidoresJuegoStreamProvider` |
| `ChatScreen` | Chat con IA (read-only) | `chatProvider` (features/chat) |
| `DevicesScreen` | Dispositivos conectados | `dispositivosProvider` |
| `ChangePasswordScreen` | Acción: cambiar contraseña WiFi | `wifiNotifierProvider` |
| `AsistenciaIntroScreen` | Navegación local | — |
| `AsistenciaLoadingScreen` | Animación de diagnóstico | — |
| `AsistenciaProblemScreen` | Selección de problema | — |
| `OfflineScreen` | Diagnóstico offline | `NetworkAnalyzerService` |

## Reglas de arquitectura

1. **Ningún widget llama HTTP directamente** — todo pasa por un provider.
2. **El token JWT se inyecta automáticamente** en cada request vía `ApiClient`.
3. **Las IPs de ping se leen de `LocalStorage`** (nunca hardcodeadas).
4. **Los providers globales** están todos en `core/providers/providers.dart`.
5. **Los modelos** usan Freezed para inmutabilidad y serialización JSON.
6. **Las vistas originales** fueron preservadas intactas; solo se actualizaron sus imports.
