# Reglas del Proyecto - Health Check Extension

## 1. Bitacora de sesiones

- Al **iniciar** una sesion, leer `docs/ULTIMOHECHO.md` y `docs/PLANEADO.md` para saber el estado anterior y que sigue.
- Al **terminar** la sesion (usuario dice "volvere mañana", "termino", "nos vemos", "continuamos mañana", o similar):
  1. Actualizar `docs/ULTIMOHECHO.md` con la fecha y un resumen de todo lo que se hizo en la sesion actual.
  2. Si hay tareas pendientes, actualizar `docs/PLANEADO.md` con la fecha y lo que queda por hacer.
- Los registros son bitacoras acumulativas con fecha. No borrar entradas anteriores, agregar nuevas al inicio.

## 2. Proposito de cada archivo en docs/

| Archivo | Contenido |
|---|---|
| `METAS.md` | Objetivos de la app organizados por pantalla. Cada elemento de UI se clasifica como Visual, Navegacion, Input, Accion o Automatismo. Los Casos de Uso de negocio se marcan explicitamente. |
| `REGLAS.md` | Este archivo. Reglas de funcionamiento del agente. |
| `ULTIMOHECHO.md` | Bitacora de lo ultimo realizado en la sesion anterior. Fecha + resumen. |
| `PLANEADO.md` | Tareas pendientes para la siguiente sesion. Fecha + lista. |

## 3. Estructura del codigo

- **No modificar archivos de vista** (`lib/screens/`) sin permiso explicito del usuario.
- La logica de negocio va en `lib/core/`, `lib/data/`, `lib/domain/` (Clean Architecture).
- `lib/features/` contiene los providers y repositorios originales de cada modulo.
- `lib/screens/` contiene las vistas. No tocarlas sin autorizacion.

## 4. Datos reales vs mock

- Gaming: pings reales a servidores. Unico modulo con datos reales.
- Streaming: pings reales a CDNs, velocidad simulada (documentado con comentario explicito).
- Chat: respuestas simuladas desde ChatRepository.
- Todo lo demas: 100% hardcodeado / mock.

## 5. Convenciones de codigo

- Comentarios en espanol.
- Sin emojis en codigo ni commits.
- Sin clever code (legibilidad > brevedad).
- Domain layer es pura Dart (sin Flutter).
