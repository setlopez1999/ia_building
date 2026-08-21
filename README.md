# tvapp

## Requisitos

- [FVM](https://fvm.app/) — Flutter Version Manager
- Flutter `3.35.7` (gestionado por FVM)
- Android SDK (para compilar APK)

## Setup inicial (primera vez o después de clonar)

```bash
fvm install                                                         # 1. Instalar Flutter 3.35.7
fvm flutter clean                                                    # 2. Limpiar build / .dart_tool
fvm flutter pub get                                                  # 3. Bajar dependencias
fvm dart run build_runner build --delete-conflicting-outputs         # 4. Generar freezed / g.dart
fvm flutter run                                                      # 5. Correr la app
```

> Los archivos `*.freezed.dart` y `*.g.dart` son auto-generados y no están en git.
> Debes generarlos localmente antes de correr la app (paso 4).

## Correr la app

```bash
fvm flutter run
```

## Compilar APK

```bash
# Debug
fvm flutter build apk --debug

# Release
fvm flutter build apk --release
```

## Regenerar código tras cambios en modelos

Cada vez que modifiques una clase `@freezed`, un provider `@riverpod`, o un DTO `@JsonSerializable`, vuelve a correr:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

O en modo watch durante desarrollo:

```bash
fvm dart run build_runner watch --delete-conflicting-outputs
```
