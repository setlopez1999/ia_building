# Planeado

## Pendiente para proxima sesion

### Prioridad alta

- [ ] **Probar en dispositivo fisico** (ZTE Android 11) - verificar que gaming monitor funcione o confirme que `Process.run('ping')` falla en Android
- [ ] **Migrar `Process.run('ping')` a paquete ICMP nativo** (`ping_discover_io` o RawSocket) para compatibilidad Android/iOS

### Prioridad media

- [ ] **Reemplazar datos mock del Home Screen** (SSID, metricas, ultimo diagnostico) por datos reales desde providers que conecten a `NetworkDiagnostic`
- [ ] **Escribir tests unitarios** para: domain use cases (`ProbeGamingServer`, `ProbeStreamingPlatform`) y data repositories
- [ ] **Reemplazar mockups restantes**: Diagnostico, Asistencia, Change Password, Dispositivos, Offline, Historial

### Prioridad baja

- [ ] Implementar tarjetas inactivas del Hub (Eventos, IPTV, VOD, Camaras, Club descuentos)
- [ ] Implementar modulo Streaming (actualmente comentado en HomeScreen)
- [ ] Migrar `lib/core/theme/` a usar `lib/utils/app_colors.dart` existente (evitar duplicacion)
