# Metas de la App - Health Check Extension

## Flujo de pantallas y casos de uso

Layout: `Pantalla (ruta)` -> que acciones tiene y a donde navega.

---

### Hub (`/`)
**Proposito:** Dashboard principal de Oneplay.

| Elemento | Tipo | Accion |
|---|---|---|
| Carrusel banners | Visual | Auto-rotacion de 4 banners Unsplash |
| Tarjeta Eventos | Navegacion | `onTap: () {}` -- NO IMPLEMENTADO |
| Tarjeta IPTV | Navegacion | `onTap: () {}` -- NO IMPLEMENTADO |
| Tarjeta VOD | Navegacion | `onTap: () {}` -- NO IMPLEMENTADO |
| Tarjeta Camaras | Navegacion | `onTap: () {}` -- NO IMPLEMENTADO |
| Tarjeta Club descuentos | Navegacion | `onTap: () {}` -- NO IMPLEMENTADO |
| Tarjeta **Check Health** | Navegacion | -> `/loading?to=/check_health` |
| Boton notificaciones | Mock | Sin accion real |
| Avatar perfil | Mock | Sin accion real |

---

### Service Loading (`/loading?to=...`)
**Proposito:** Pantalla de transicion con animacion (1.8s).

| Elemento | Tipo | Accion |
|---|---|---|
| Auto-timer | Automatismo | Espera 1.8s y navega al `targetPath` |

---

### Home / Check Health (`/check_health`)
**Proposito:** Visor principal de estado de red.

| Elemento | Tipo | Accion |
|---|---|---|
| Wifi Status Card | Navegacion | -> `/change_password` |
| Chip ultimo diagnostico | Visual | Muestra "Hace 2 semanas" (hardcodeado) |
| Metrica "Estado" | Visual | "Activo" (hardcodeado) |
| Metrica "Equipos" | Navegacion | -> `/dispositivos` |
| Metrica "Lat. Google" | Visual | "12 ms" (hardcodeado) |
| Metrica "Lat. ISP" | Visual | "5 ms" (hardcodeado) |
| Metrica "Velocidad" | Visual | "248 Mbps" (hardcodeado) |
| Boton "Iniciar diagnostico" | Navegacion | -> `/diagnostico` |
| Menu "Modo Offline" | Navegacion | -> `/offline` |
| Menu "Chat" | Navegacion | -> `/chat` |
| Menu "Asistencia" | Navegacion | -> `/asistencia` |
| Menu "Historial" | Navegacion | -> `/historial` |
| Menu "Gaming" | Navegacion | -> `/gaming` |
| Menu "Streaming" | Navegacion | omitido (comentado en codigo) |

---

### Diagnostico de internet (`/diagnostico` -> `/diagnostico_result`)
**Proposito:** Simular escaneo de red.

| Elemento | Tipo | Accion |
|---|---|---|
| Circulo progreso | Animacion | 0% -> 100% en 4 segundos |
| Items de estado (4) | Visual | Velocidad -> Red Wifi -> Fibra -> Latencia (cambian de estado secuencial) |
| Boton "Cancelar" | Navegacion | -> `/` |
| Auto-completado | Automatismo | Al llegar a 100% -> `/diagnostico_result` |

**Resultado (`/diagnostico_result`):**
| Elemento | Tipo | Accion |
|---|---|---|
| Resumen "Excelente 9.5/10" | Visual | Hardcodeado |
| 4 tarjetas de metrica | Visual | Velocidad, WiFi, Fibra, Latencia |
| Recomendaciones | Visual | Texto estatico |
| Boton "Nuevo diagnostico" | Navegacion | -> `/diagnostico` |

---

### Chatbot (`/chat`)
**Proposito:** Asistente virtual con respuestas automaticas.

| Elemento | Tipo | Accion |
|---|---|---|
| Historial de mensajes | Visual | Burbujas usuario (gris) / bot (verde con avatar) |
| Campo de texto + enviar | Input | **Caso de uso: Enviar mensaje** -> `ChatProvider.sendMessage()` -> `ChatRepository` (respuesta simulada) |
| Boton borrar chat | Accion | **Caso de uso: Limpiar conversacion** -> `ChatProvider.clearChat()` |
| Auto-scroll | Automatismo | Scroll al final al recibir mensaje |
| Boton retroceso | Navegacion | <- Volver |

---

### Gaming (`/gaming` -> `/gaming/:id`)

**Lista (`/gaming`):**
**Proposito:** Seleccion de juego para monitoreo.

| Elemento | Tipo | Accion |
|---|---|---|
| Lista de juegos | Visual | 5 juegos con logo, nombre, ping. Datos desde `gamesProvider` (Stream) |
| Tap en juego | Navegacion | -> `/gaming/:id` |

**Detalle (`/gaming/:id`):**
**Proposito:** Monitoreo de latencia en tiempo real.

| Elemento | Tipo | Accion |
|---|---|---|
| Ping grande + radar animado | Visual | Circulos expansivos con CustomPainter |
| Metricas: Perdida, Jitter, Estado | Visual | Colores segun calidad (verde/amarillo/rojo) |
| Tarjeta servidor | Visual | Nombre + ubicacion del mejor servidor |
| **Caso de uso: Monitoreo continuo** | Automatismo | Al entrar: sondeo rapido a todos los servers -> selecciona mejor -> analisis profundo cada 4s. Al salir: auto-dispose. |
| Boton retroceso | Navegacion | <- Volver |

**Servidores monitoreados (hardcodeados):**
- CS2: Valve Lima, Santiago, Sao Paulo, Buenos Aires (LATAM) + servers USA
- Valorant: Riot Bogota, Sao Paulo, Santiago (LATAM)
- Dota2: AWS (LATAM)
- Fortnite: AWS EC2 (LATAM)
- PUBG: (LATAM)

---

### Streaming (`/streaming` -> `/streaming/:id`)

**Lista (`/streaming`):**
**Proposito:** Seleccion de plataforma de streaming.

| Elemento | Tipo | Accion |
|---|---|---|
| Lista de plataformas | Visual | Con logo, nombre, velocidad. Datos desde `streamingPlatformsProvider` (Stream) |
| Tap en plataforma | Navegacion | -> `/streaming/:id` |

**Detalle (`/streaming/:id`):**
**Proposito:** Monitoreo de velocidad de streaming.

| Elemento | Tipo | Accion |
|---|---|---|
| Logo + nombre grande | Visual | |
| Grid 2x2: Bajada / Subida | Visual | Velocidad en Mbps |
| Tarjeta servidor | Visual | Nombre + ubicacion CDN |
| **Caso de uso: Monitoreo continuo** | Automatismo | Ping cada 8s a CDNs reales. Velocidad = 40-60 Mbps base + ajuste por latencia + componente aleatorio. Al salir: auto-dispose. |
| Boton retroceso | Navegacion | <- Volver |

**CDNs monitoreadas:** netflix.com, google.com, cloudfront.net, azure.microsoft.com, atv-ps.amazon.com

---

### Dispositivos (`/dispositivos`)
**Proposito:** Listar equipos conectados a la red.

| Elemento | Tipo | Accion |
|---|---|---|
| Encabezado "4 dispositivos" | Visual | Hardcodeado |
| Lista de dispositivos (4) | Visual | Samsung S23, A40, Moto 45-8, MacBook Pro. Iconos + status "Conectado". Sin interaccion. |
| Boton retroceso | Navegacion | <- Volver |

---

### Asistencia (`/asistencia` -> 4 pasos)

**Intro (`/asistencia`):**
**Proposito:** Categorizar el problema del usuario.

| Elemento | Tipo | Accion |
|---|---|---|
| 4 opciones de problema | Navegacion | Tap en cualquier opcion -> `/asistencia_diagnostic` |
| Opciones: No hay WiFi, Internet lento, Mala cobertura, Sin internet | | |

**Diagnostico (`/asistencia_diagnostic`):**
| Elemento | Tipo | Accion |
|---|---|---|
| Circulo progreso 4s | Animacion | + 4 items de estado secuenciales |
| Boton retroceso | Navegacion | <- Volver |
| Auto-completado | Automatismo | -> `/asistencia_problem` |

**Resultado (`/asistencia_problem`):**
| Elemento | Tipo | Accion |
|---|---|---|
| Icono problema + descripcion | Visual | "No hay conexion WiFi" |
| Pasos recomendados (4) | Visual | Verificar WiFi, reiniciar, olvidar red, reiniciar router |
| Acciones automaticas | Mock | Toggles: Activar WiFi, Reconectar a red guardada (sin funcion real) |
| Boton "Aplicar solucion" | Navegacion | -> `/asistencia_success` |

**Exito (`/asistencia_success`):**
| Elemento | Tipo | Accion |
|---|---|---|
| Check verde + texto exito | Visual | "Aplicando solucion automatica" + acciones ejecutadas |
| Boton "Aceptar" | Navegacion | -> `/check_health` |

---

### Offline (`/offline` -> `/offline_result`)
**Proposito:** Diagnostico sin conexion a internet.

| Elemento | Tipo | Accion |
|---|---|---|
| 4 items de verificacion | Visual | Estado dispositivo, Escaneo redes, Conexion router, Dispositivos red local |
| Badge "Disponible" + "Ejecutar ahora" | Visual | Sin accion real |
| Boton "Ejecutar todas" | Navegacion | -> `/offline_result` |

**Resultado (`/offline_result`):**
| Elemento | Tipo | Accion |
|---|---|---|
| Checkmarks: WiFi, Avion, Bluetooth, Bateria | Visual | Hardcodeado |
| Boton "Aceptar" | Navegacion | -> `/check_health` |

---

### Historial (`/historial`)
**Proposito:** Ver diagnosticos anteriores.

| Elemento | Tipo | Accion |
|---|---|---|
| Linea de tiempo 4 entradas | Visual | Excelente (verde), Bueno (azul), Regular (naranja), Malo (rojo). Cada una con hora + metricas. Hardcodeado. |
| "Ver detalles" | Visual | Solo texto, no interactivo |
| Boton retroceso | Navegacion | <- Volver |

---

### Cambiar clave (`/change_password` -> `/change_password_success`)
**Proposito:** Cambiar contrasena de la red WiFi.

| Elemento | Tipo | Accion |
|---|---|---|
| Tarjeta red WiFi | Visual | "CasaGonzalez3456" con gradiente |
| Campo "Nueva contrasena" | Input | Sin validacion ni persistencia |
| Campo "Repetir contrasena" | Input | Sin validacion ni persistencia |
| Boton "Cambiar clave" | Navegacion | -> `/change_password_success` |

**Exito (`/change_password_success`):**
| Elemento | Tipo | Accion |
|---|---|---|
| Check verde + texto exito | Visual | |
| Boton "Aceptar" | Navegacion | -> `/` |
