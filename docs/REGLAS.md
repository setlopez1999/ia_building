# Reglas del proyecto

Reglas definidas por el equipo. **No son sugerencias**: todo código nuevo las cumple,
y el código viejo se corrige a medida que se toca.

---

## Regla 1 — Toda API consumida debe reflejar su estado en la UI

Siempre que se consuma una API y su resultado se dibuje en pantalla, la interfaz
**debe mostrar en qué estado está esa llamada**. Los tres estados son obligatorios:

| Estado | Qué se ve |
|---|---|
| **Cargando** | Indicador de carga visible. Nunca una pantalla en blanco. |
| **Éxito** | El contenido. Si viene vacío, un mensaje que lo diga (no un espacio vacío). |
| **Error** | Un mensaje de error visible, con opción de reintentar. |

**Prohibido:**
- Dejar un `SizedBox()` / `Container()` vacío como caso por defecto (`orElse`).
- Tapar un fallo con contenido de relleno, con datos mock o con una pantalla vacía.
- Tragar la excepción sin que el usuario se entere de nada.

**Por qué:** sin este feedback es imposible saber si la app falla o si el backend
falla. En agosto 2026 la pantalla de canales estuvo vacía durante días por esto:
el servidor devolvía 404 y la app no mostraba absolutamente nada.

### Excepción vigente

| Elemento | Trato | Motivo |
|---|---|---|
| Carrusel de banners del hub | Si falla o viene vacío, **no ocupa lugar**. El error se ve solo con `APP_DEBUG_MODE=true`. | Es contenido promocional: el usuario no pierde ninguna función y un cartel de error en medio del home es ruido. El fallo igual queda visible para quien desarrolla. |

### Regla 1.b — El detalle técnico del error, solo en debug

Cuando la llamada falla, el usuario ve **un mensaje entendible en castellano**.

Además, **solo si `APP_DEBUG_MODE=true` en el `.env`**, se muestra debajo el
detalle crudo: código HTTP, cuerpo de la respuesta o mensaje de la excepción.

En release ese detalle **no se muestra nunca** — filtra información del backend
y no le sirve al usuario final.

**Cómo cumplirla:** usar `ApiStateView` (`lib/ui/shared/widgets/api_state.widget.dart`),
que ya implementa los tres estados y la regla de debug. No reimplementar a mano.

```dart
ApiStateView<List<Channel>>(
  state: channels,
  onRetry: _load,
  builder: (data) => ChannelsList(channels: data),
  emptyMessage: 'No hay canales en esta categoría.',
)
```

---

## Regla 2 — La configuración por ISP vive en el `.env`

Colores, hosts, nombre de la app y feature flags salen del `.env`, nunca
hardcodeados en el código. El proyecto es white-label: se reempaqueta por ISP.

Variables de fondo y acento ya definidas: `BACKGROUND_COLOR`, `ACTION_COLOR`.

⚠️ Pendiente conocido: `APP_NAME`, `APP_SIGN` y `APP_ICON` existen en el `.env`
pero **no están cableadas a nada nativo**. Ver `PENDIENTES.md`.

---

## Regla 3 — Los inputs son todos iguales

Todos los campos de entrada de la app —texto, contraseña, desplegables,
buscadores— comparten **el mismo tamaño, radio, relleno, tipografía y estados**
(normal, foco, error, deshabilitado).

**Son iguales salvo que se diga explícitamente lo contrario**, y esa excepción
queda anotada acá abajo con su motivo. Nadie decide una excepción por su cuenta
dentro de una pantalla: o está escrita en esta lista, o el campo usa el
componente compartido.

**Prohibido** definir el estilo de un campo dentro de una pantalla. Si un campo
necesita algo distinto, se agrega como variante del componente compartido, no
como excepción local.

### Excepciones vigentes

| Pantalla | Motivo |
|---|---|
| Chat (`tools/chat`) | Módulo Check Health, tiene su propio lenguaje visual. Decisión del equipo, ago 2026. |
| Wifi password (`tools/wifi_password`) | Ídem Check Health. |

Cualquier otro campo de la app usa `AppInput`.

**Cómo cumplirla:** usar el componente compartido de input. Nunca escribir
`InputDecoration` con `borderRadius`, `fillColor` o `contentPadding` propios
dentro de una pantalla.

**Señal de que la regla se está rompiendo:** ver `filled: false` o
`fillColor: Colors.transparent` en una pantalla. Eso significa que alguien está
peleando contra el tema global en vez de arreglarlo.

**Por qué:** en agosto 2026 convivían seis radios distintos (4, 10, 15, 30, 100
y sin borde) y cuatro fondos distintos, porque el `inputDecorationTheme` global
pintaba los campos de blanco sobre una app oscura y cada pantalla lo anulaba a
su manera.

Lo mismo aplica a botones, títulos y espaciados: **una definición compartida,
cero estilos sueltos en las pantallas.**

---

## Regla 4 — Nada de datos falsos presentados como reales

Si una funcionalidad todavía no tiene backend, **no se simula un éxito**.
O se deja apagada tras un feature flag, o se muestra explícitamente que es
un placeholder.

**Por qué:** el registro devolvía "¡Registro completado con éxito!" sin crear
ningún usuario. Ver `_registroSimulado` en `auth_http_repository.dart`.
