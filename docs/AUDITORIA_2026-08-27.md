# Auditoría del proyecto — 27 ago 2026

Revisión de estructura y calidad, con mediciones sobre el código, no impresiones.
Rama `feat/login-nuevo`.

## Veredicto

El proyecto funciona y avanza rápido, pero es un prototipo que creció hasta
parecer un producto. No tiene un problema grave: tiene **deuda estructural
repartida**, que hoy se paga en tiempo de debugging y mañana en imposibilidad de
mantenerlo entre varias personas.

**23.693 líneas a mano · 284 archivos · 6 tests** — todos de Check Health.
Auth, IPTV y Cámaras tienen cero cobertura.

---

## Por caso de uso

### Autenticación y sesión — el más riesgoso
- Token y contraseña **en texto plano** (verificado en dispositivo).
- Historial de los últimos 5 tokens que **no se borra al cerrar sesión**.
- La revalidación de cada minuto **descarta su propio resultado**: una cuenta
  dada de baja sigue usando la app hasta reiniciarla.
- La expulsión al login es global: cualquier `error` del provider de auth saca
  al usuario de donde esté, incluso reproduciendo.

### IPTV — funciona, pero acoplado
- `categorySelected` y `channelsLoaded` se llaman entre sí; el orden importa.
- `player_screen.dart`: **677 líneas y 3 timers propios**, uno **cada segundo**
  para sincronizar EPG.
- Positivo: liberación de recursos del reproductor correcta; fallback de
  Multicdn correcto.

### Cámaras — el más caro en batería
- Dos providers con timer de **15 s sin `autoDispose`**: siguen consultando con
  la pantalla cerrada, toda la vida de la app.
- Credenciales ONVIF por **HTTP sin cifrar**, con
  `usesCleartextTraffic="true"` en el manifest.

### Check Health — el mejor construido y el más abandonado
- Único módulo **con tests** (los 6 que hay) y con pantalla contenedora limpia.
- **Streaming es 100 % mock y además inalcanzable**: rutas registradas, ningún
  botón lleva ahí.
- Gaming: pings reales, catálogo en memoria.
- `check_health_screen.dart`: 505 líneas.

### Registro — listo pero miente
- La llamada **finge éxito sin crear nada** (`_registroSimulado`).
- Los términos legales que muestra **son de otra empresa** (Bantel).

### Mi cuenta · Notificaciones · Otros productos — el estándar a seguir
Hechos con las reglas: estados de API visibles, componentes compartidos,
interfaz para lo que todavía no tiene endpoint.

---

## Transversal

| Tema | Medición |
|---|---|
| Estilos de estado conviviendo | `@riverpod` 14 · `keepAlive` 12 · `NotifierProvider` 6 · `FutureProvider` 11 · `Provider` 16 · `setState` 27 |
| Clientes HTTP distintos | Dio suelto 11 · `HttpClient` dart:io 5 · `ToolsApiClient` 14 |
| Violaciones de capa | 15 archivos de UI importan `core/infraestructure` |
| Casos de uso vs repo directo | 19 providers con use case · 10 directo al repo |
| Timers periódicos vivos | **12** (auth 1min, multicdn 1min, notificaciones 1min, alertas 1min, cámaras 15s ×2, gaming 4-10s, EPG **1s**) |
| Avisos del analizador | **677** |
| Convención de nombres | 44 archivos `x.screen.dart` · 250 snake_case |
| Carpetas mal escritas | `core/infraestructure` (→ infrastructure) · `register/wigdets` (→ widgets) |
| Pantallas > 300 líneas | player 677 · camera_alerts 548 · diagnostico_result 521 · check_health 505 |

---

## Prioridades

1. **Seguridad de sesión.** Cifrar token y contraseña, limpiar el historial al
   cerrar sesión, hacer que la revalidación silenciosa expulse cuando el
   servidor rechaza. Único punto con impacto fuera del código.
2. **Un solo cliente HTTP** con timeouts, reintentos y traducción de errores en
   un lugar.
3. **Bajar el lint a algo cumplible** y dejar `flutter analyze` en cero. Sin
   esto no puede haber CI, y sin CI no puede haber más de una persona tocando.
4. **Tests de auth**: los cuatro caminos del login y los dos de la revalidación.
5. Recién después: unificar estado y partir pantallas grandes.

## Lo que hay que sostener

`docs/REGLAS.md` y `ApiStateView` convirtieron una convención en algo que se
cumple solo. El `.env` como fuente única de configuración por ISP está bien
pensado, aunque a medio cablear.

**Conclusión:** no necesita reescritura. Necesita dejar de agregar módulos por
dos semanas y aplicar el estándar de Mi cuenta / Notificaciones hacia atrás.
