# Pendientes

## 1. Backend: flags de módulos del hub en `/api/inicio`

**Estado:** esperando confirmación del formato con backend/jefa.

**Qué se necesita:** la respuesta de `POST /api/inicio` (y `GET /{token}/inicio.json`) debe incluir dentro de `info` un objeto `modulos` con los productos que tiene contratados el cliente:

```json
"info": {
  "...": "...",
  "modulos": {
    "eventos": true,
    "iptv": true,
    "vod": false,
    "camaras": true,
    "club_descuentos": false,
    "check_health": true
  }
}
```

**Regla acordada:** el backend DEBE mandar estos flags. Si no vienen, la app **release** no muestra NINGÚN módulo (grid vacío). En debug se muestran todos sin importar la API.

**Dónde tocar cuando se confirme el formato real:** solo `lib/core/infraestructure/parsers/modulos_parser_v1.dart` (interfaz: `lib/core/domain/interfaces/modulos/modulos_parser.dart`). El resto del código consume la interfaz.

## 2. Carrusel de banners del home viejo crashea

**Estado:** detectado 2026-08-24 en dispositivo, no bloqueante.

`Unhandled Exception: Null check operator used on a null value` en
`carousel_slider/carousel_slider.dart:144` (`CarouselSliderState.getTimer`).
Ocurre al entrar al home antiguo. Si el home viejo se elimina en el rediseño de
IPTV, el problema desaparece solo — revisar recién después de esa limpieza.

## 3. Multicdn: tipo incompatible con el servidor nuevo

**Estado:** detectado 2026-08-24, no bloqueante.

Contra `oneplay.iptvperu.tv` el monitor de Multicdn falla con
`type 'int' is not a subtype of type 'bool'` ("Error Obteniendo URL").
El servidor devuelve un campo como entero donde la app espera booleano.
No rompe la reproducción: hay fallback a la URL original (`multiCdnUrl` vacío).
Revisar el DTO de Multicdn contra la respuesta real del servidor nuevo.
