# Data Layer and Models Documentation

This document describes the data flow, model structure, and synchronization strategies used in the project.

## Modeling with Freezed

The project uses the `Freezed` library to handle immutability and JSON serialization. This ensures that data cannot be mutated unexpectedly once it enters the system.

### 1. Entities (`lib/core/domain/entities`)
Domain models represent the pure business data. They are defined as `@freezed` classes.
- **Immutability**: All fields are final.
- **Exhaustive Matching**: Enables using `.when()` for union types.

### 2. DTOs (`lib/core/infraestructure/dtos`)
Data Transfer Objects are used to bridge the gap between API responses and Domain Entities.
- **JSON Serialization**: Use `toJson/fromJson` patterns.
- **Decoupling**: API changes only affect the DTO; the rest of the app remains stable because it uses the Entity.

## Repository Pattern

The repository pattern is used to abstract the data source from the domain and UI layers.

### Interfaces (Domain)
Defined in `lib/core/domain/repositories`, these specify *what* operations can be performed.
```dart
abstract class AuthRepository {
  Future<Either<AppException, User>> login(String email, String password);
  Future<void> cleanSession();
}
```

### Implementations (Infrastructure)
Defined in `lib/core/infraestructure/repositories`, these specify *how* operations are performed.
- **HTTP**: Implementation using `Dio`.
- **LocalStorage**: Implementation using `SharedPreferences`.

## Synchronization and Data Flow

Data synchronization logic is encapsulated within **UseCases** or dedicated **Monitoring Providers**.

### 1. Repository Synchronization
In repositories like `AuthHttpRepository`, local and remote data are synchronized:
- When a user logins, the session is saved both in memory and in `SharedPreferences` (`saveSensitiveData`).
- On app launch, the `AuthProvider` attempts to `loadSession` from local storage.

### 2. Active Monitoring
Some providers implement high-frequency synchronization or monitoring:
- **Session Monitoring**: `AuthProvider` uses a `Timer.periodic` to refresh the session token every minute.
- **CDN Monitoring**: `MultiCDNProvider` periodically checks for the best content URL.

### 3. Error Handling (`fpdart`)
The project uses the `Either` type for error handling. instead of throwing exceptions, methods return a `Left(Failure)` or a `Right(Success)`.
- This forces the developer to handle both success and error cases explicitly.
- `AppException` is used as a unified custom failure type.
