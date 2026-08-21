# Módulo de Cámaras — App Mobile V3

## Arquitectura general

```
┌─────────────┐     GET /api/camaras/{clienteId}     ┌──────────────────┐
│  Auth Login  │ ──────────────────────────────────▶  │  Servidor API    │
│  (set@set.set) │                                    │  201.234.116.79  │
│  clienteId=7  │ ◀────────────────────────────────── │  :8088           │
└──────┬──────┘     JSON con srt_url, hls_url,        └──────────────────┘
       │             motion_log_url, onvif_api_url            │
       │                                                     │
       │  POST /ptz/{serial}/move  ────────────────▶  POST con {x,y}
       │                                                     │
       │  GET {motion_log_url} ────────────────▶  eventos.json
       │                                                     │
       │  GET {hls_url} ────────────────▶  playlist.m3u8
       │                                                     │
       ▼                                                     ▼
┌──────────────────────────────────────────────────────────────────┐
│                    App Mobile (Flutter)                           │
│                                                                  │
│  LocalStorage.getClienteId()  ──▶  "7"                           │
│                                                                  │
│  CameraRepositoryImpl.getCameras(clienteId:"7")                  │
│    └── CamerasApiClient.getCameras("7")                          │
│        └── GET http://201.234.116.79:8088/api/camaras/7         │
│                                                                  │
│  CameraEntity { id, serial, name, srt, hls, onvif,              │
│                 motionLogUrl, onvifApiUrl, ipCamara, ... }       │
└──────────────────────────────────────────────────────────────────┘
```

---

## Flujo completo

### 1. Login → Obtener clienteId

```
Login(set@set.set)
  └── AuthProvider.saveSession(email)
       └── GET /crm/clientes/by-email/set@set.set
       └── LocalStorage.setClienteId("7")
```

El `cliente_id` se obtiene del CRM mediante el email. La app guarda el `cliente_id=7` en SharedPreferences.

### 2. Cargar lista de cámaras

```
CamerasScreen
  └── ref.watch(cameraListProvider)
       └── CameraRepositoryImpl.getCameras(clienteId: "7")
            └── CamerasApiClient.getCameras("7")
                 └── GET http://201.234.116.79:8088/api/camaras/7
                      └── JSON → List<CameraEntity>
```

### 3. Seleccionar cámara y reproducir SRT

```
_CameraCard.onTap()
  └── ref.read(cameraSelectedProvider.notifier).select(camera)
  └── context.push('/tools/cameras/player', extra: camera)
       └── PlayerCamerasScreen
            └── NativePlayer(camera: camera)
                 └── buildSrtUrl(camera.srt)
                      └── srt://201.234.116.79:25732?latency=120&rcvbuf=1048576
```

### 4. Abrir detector de movimientos (eventos)

```
CameraControls → botón "Detector de movimientos"
  └── setState(_step = PlayerSteps.cameraEvents)
  └── CameraEvents(camera)
       └── ref.watch(cameraEventsProvider(camera.motionLogUrl))
            └── CameraRepositoryImpl.getCameraEvents(motionLogUrl)
                 └── CamerasApiClient.getEventLog(motionLogUrl)
                      └── GET http://201.234.116.79:8088/logs/movimiento/{serial}
```

### 5. Ver video de un evento

```
_EventTile.onTap() (si event.video no es vacío)
  └── parent.copyWith(isEvent:true, hls: event.video)
  └── context.push('/tools/cameras/event-player', extra: newCamera)
       └── PlayerCameraEventScreen
            └── BetterPlayerDataSource(hls: event.video)
```

### 6. Mover cámara (PTZ)

```
DPad.onTap() (si camera.onvifApiUrl no es vacío)
  └── CameraSelectedNotifier.move(x, y)
       └── CameraRepositoryImpl.moveCamera(id, x, y, onvifApiUrl: state!.onvifApiUrl)
            └── CamerasApiClient.movePtz(onvifApiUrl, x, y)
                 └── POST http://201.234.116.79:8088/ptz/{serial}/move
                      └── body: {"x": 0.1, "y": 0}
```

---

## Modelos de datos

### CameraEntity

| Campo | Tipo | Origen (JSON) | Descripción |
|-------|------|---------------|-------------|
| `id` | `String` | `serial_camara` | ID único (mismo que serial) |
| `serial` | `String` | `serial_camara` | Serial de la cámara |
| `name` | `String` | `nombre_camara` | Nombre asignado |
| `isEvent` | `bool` | — | `true` si es modo evento (video DVR) |
| `srt` | `String` | `srt_url` + `?latency=120&rcvbuf=1048576` | URL SRT para streaming en vivo |
| `hls` | `String` | `hls_url` | URL HLS para live o DVR |
| `onvif` | `String` | `onvif_api_url` | Alias de `onvifApiUrl` (backward compat) |
| `motionLogUrl` | `String` | `motion_log_url` | URL para obtener eventos de movimiento |
| `onvifApiUrl` | `String` | `onvif_api_url` | URL base PTZ (`/ptz/{serial}`) |
| `ipCamara` | `String` | `ip_camara` | IP de la cámara en red local |
| `usuario` | `String` | `usuario` | Usuario ONVIF de la cámara |
| `passwordCamara` | `String` | `password_camara` | Password ONVIF |
| `srtPuerto` | `String?` | `srt_puerto` | Puerto SRT (25732) |

### CameraEventEntity

| Campo | Tipo | Origen (JSON) | Descripción |
|-------|------|---------------|-------------|
| `tipo` | `String` | `tipo` | `"inicio"` / `"fin"` / `"monitoreo"` |
| `unix` | `int` | `unix` | Timestamp UNIX del evento |
| `utc` | `String` | `utc` | Fecha/hora UTC (ISO 8601) |
| `video` | `String` | `video` | URL HLS del clip (solo inicio/fin) |
| `duracion` | `int` | `duracion` | Duración en segundos (solo fin) |
| `ip` | `String` | `ip` | IP de la cámara |
| `serial` | `String` | `serial` | Serial de la cámara |

---

## API Endpoints

### Servidor de cámaras: `http://201.234.116.79:8088`

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| `GET` | `/api/camaras/{clienteId}` | Listar cámaras de un cliente |
| `GET` | `/logs/movimiento/{serial}` | Obtener eventos de movimiento |
| `POST` | `/ptz/{serial}/move` | Mover PTZ (`{"x":0.1,"y":0}`) |
| `POST` | `/ptz/{serial}/stop` | Detener PTZ |
| `POST` | `/ptz/{serial}/presets` | Crear preset |
| `POST` | `/ptz/{serial}/goto` | Ir a preset |

### Servidor CRM: `http://217.216.83.61:8081`

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| `GET` | `/crm/clientes/by-email/{email}` | Obtener `cliente_id` por email |

---

## Estructura de archivos (cámaras)

```
lib/
├── core/
│   ├── domain/entities/tools/
│   │   ├── camera_entity.dart            ← Modelo de cámara
│   │   └── camera_event_entity.dart      ← Modelo de evento
│   ├── infraestructure/
│   │   ├── datasource/tools/
│   │   │   └── cameras_api_client.dart    ← Cliente HTTP (sin JWT)
│   │   └── repositories/tools/
│   │       ├── camera_repository.dart     ← Interfaz abstracta
│   │       └── camera_repository_impl.dart ← Implementación
│   └── ...
├── ui/
│   ├── providers/
│   │   ├── auth/auth_provider.dart       ← Login + fetch clienteId
│   │   └── tools/camera_providers.dart    ← Providers Riverpod
│   ├── screens/tools/cameras/
│   │   ├── cameras_screen.dart           ← Lista de cámaras
│   │   ├── player_cameras_screen.dart    ← Reproductor SRT + controles
│   │   ├── player_camera_event_screen.dart ← Reproductor HLS (eventos DVR)
│   │   └── widgets/
│   │       ├── native_player.dart        ← Player nativo SRT
│   │       ├── camera_controls.dart      ← Overlay de controles (brillo, volumen, menú)
│   │       ├── camera_list.dart          ← Sidebar lista de cámaras
│   │       ├── camera_grid.dart          ← Sidebar mosaico
│   │       ├── camera_events.dart        ← Sidebar eventos de movimiento
│   │       ├── info.dart                 ← Sidebar info de cámara
│   │       ├── dpad.dart                 ← Control PTZ (direccional)
│   │       └── event_controls.dart       ← Controles reproductor de eventos
│   └── shared/utils/
│       └── srt.dart                      ← buildSrtUrl()
└── storage/tools/
    └── local_storage.dart                ← SharedPreferences (clienteId, token)
```

---

## Providers Riverpod

### `cameraRepositoryProvider`
```dart
Provider<CameraRepository>((ref) => CameraRepositoryImpl())
```
Provee el repositorio de cámaras (sin dependencias externas).

### `cameraListProvider`
```dart
FutureProvider<List<CameraEntity>>((ref) async {
  final clienteId = LocalStorage.getClienteId();
  return ref.watch(cameraRepositoryProvider).getCameras(clienteId: clienteId);
})
```
Obtiene la lista de cámaras usando el `clienteId` guardado en sesión.

### `cameraEventsProvider`
```dart
FutureProvider.family<List<CameraEventEntity>, String>((ref, motionLogUrl) async {
  return ref.watch(cameraRepositoryProvider).getCameraEvents(motionLogUrl);
})
```
Obtiene eventos por `motionLogUrl`. Se invalida al abrir el panel de eventos para forzar refresh.

### `cameraSelectedProvider`
```dart
NotifierProvider<CameraSelectedNotifier, CameraEntity?>
```
Mantiene la cámara actualmente seleccionada. El método `move(x, y)` llama al repositorio con `onvifApiUrl`.

---

## Pantallas principales

### CamerasScreen
- Lista vertical de cámaras con `_CameraCard`
- Al hacer tap: selecciona cámara y navega a `PlayerCamerasScreen`

### PlayerCamerasScreen
- Reproductor a pantalla completa con `NativePlayer` (SRT)
- **Auto-hide**: los controles se ocultan tras 10s sin interacción
- **PiP**: Picture-in-Picture en Android
- **Estados**: buffering, playing, error
- **Sidebars** que se abren desde `CameraControls`:
  - `cameraInfo` → Info(camera)
  - `cameraList` → CameraList
  - `cameraGrid` → CameraGrid
  - `cameraEvents` → CameraEvents(camera)

### PlayerCameraEventScreen
- Reproductor de video de evento (HLS con DVR range)
- Controles: back, rewind -10s, forward +10s
- Manejo de errores con botón "Reintentar"

---

## Sidebar de eventos (CameraEvents)

### Comportamiento
1. Al abrirse: invalida el provider para forzar refresh
2. Muestra lista de eventos ordenados por `unix`
3. Cada evento se muestra con:
   - **`inicio`**: icono ⚠️ ámbar, "Movimiento detectado", hora local
   - **`fin`**: icono ✅ verde, "Movimiento finalizado - {duracion}s", hora local
   - **`monitoreo`**: icono 👁️ gris, "Monitoreo - sin movimiento", hora local
4. Tap en evento con `video` → navega a `PlayerCameraEventScreen`
5. Tap en `monitoreo` sin `video` → no hace nada
6. **Refresh manual**: botón 🔄 en header + pull-to-refresh

---

## PTZ (Movimiento de cámara)

### Condiciones para mostrar el DPad
El DPad solo se muestra si:
```dart
_step == PlayerSteps.none && dpadEnabled && camera.onvifApiUrl.isNotEmpty
```

### Flujo de PTZ
```
DPad.onTap()
  → CameraSelectedNotifier.move(x, y)
    → CameraRepositoryImpl.moveCamera(serial, x, y, onvifApiUrl)
      → CamerasApiClient.movePtz(onvifApiUrl, x, y)
        → POST {onvifApiUrl}/move
          → body: {"x": 0.1, "y": 0}
```

### Valores enviados por dirección
| Dirección | `x` | `y` |
|-----------|---|-----|
| Arriba | `0` | `0.1` |
| Abajo | `0` | `-0.1` |
| Izquierda | `-0.1` | `0` |
| Derecha | `0.1` | `0` |

### Rate limiting
El DPad tiene un throttle de 1 segundo entre movimientos para evitar sobrecarga.

---

## SRT URL

```dart
// lib/ui/shared/utils/srt.dart
String buildSrtUrl(String baseUrl) {
  final uri = Uri.parse(baseUrl);
  final params = Map<String, String>.from(uri.queryParameters)
    ..putIfAbsent('latency', () => '120')
    ..putIfAbsent('rcvbuf', () => '1048576');
  return uri.replace(queryParameters: params).toString();
}
```

Parámetros fijos:
- `latency=120` — latencia en ms
- `rcvbuf=1048576` — buffer de recepción en bytes

---

## Sesión de usuario y clienteId

### Almacenamiento
```dart
LocalStorage.getClienteId()  →  SharedPreferences key "cliente_id"
```

### Obtención durante login
```dart
AuthProvider.saveSession(email)
  → GET http://217.216.83.61:8081/crm/clientes/by-email/{email}
  → Response: {"cliente_id": 7, "nombre": "SET", ...}
  → LocalStorage.setClienteId("7")
```

### Restauración de sesión
```dart
AuthProvider.loadSession()
  → Login por token
  → GET CRM by-email (desde saved email)
  → LocalStorage.setClienteId(crmClienteId)
```

---

## Ejemplos de JSON

### GET /api/camaras/7
```json
{
  "camaras": [
    {
      "id": 41,
      "cliente_id": "7",
      "serial_camara": "1a366c9e83a4a29e8fd9",
      "nombre_camara": "Casajj",
      "ip_camara": "192.168.0.223",
      "usuario": "user",
      "password_camara": "1a366c9e83a4a29e8fd9",
      "srt_puerto": 25732,
      "srt_url": "srt://201.234.116.79:25732",
      "hls_url": "http://201.234.116.79:33935/cam/.../playlist_dvr.m3u8",
      "onvif_api_url": "http://201.234.116.79:8088/ptz/1a366c9e83a4a29e8fd9",
      "motion_log_url": "http://201.234.116.79:8088/logs/movimiento/1a366c9e83a4a29e8fd9",
      "creado_en": "Thu, 16 Jul 2026 16:45:53 GMT",
      "actualizado_en": "Fri, 17 Jul 2026 18:46:24 GMT"
    }
  ],
  "success": true
}
```

### GET /logs/movimiento/{serial}
```json
{
  "eventos": [
    { "tipo": "monitoreo", "unix": 1784310143, "utc": "2026-07-17T17:42:23Z", "ip": "192.168.0.223", "serial": "1a366c9e83a4a29e8fd9" },
    { "tipo": "inicio", "unix": 1784310609, "utc": "2026-07-17T17:50:09Z", "video": "http://.../playlist_dvr_range-1784310609-60.m3u8", "ip": "192.168.0.223", "serial": "1a366c9e83a4a29e8fd9" },
    { "tipo": "fin", "unix": 1784310609, "utc": "2026-07-17T17:50:11Z", "video": "http://.../playlist_dvr_range-1784310609-1.m3u8", "duracion": 1, "ip": "192.168.0.223", "serial": "1a366c9e83a4a29e8fd9" }
  ],
  "serial": "1a366c9e83a4a29e8fd9",
  "success": true,
  "total": 7
}
```

### POST /ptz/{serial}/move
```json
// Request
{"x": 0.1, "y": 0}

// Response
{"ok": true, "success": true}
```
