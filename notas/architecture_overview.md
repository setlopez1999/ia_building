# Project Architecture Overview

This project follows a **Clean Architecture** pattern, ensuring a clear separation of concerns between business logic, data handling, and presentation.

## Core Layers

The project is organized into three main layers within the `lib/` directory:

### 1. Domain Layer (`lib/core/domain`)
The heart of the application. It contains the business rules and is independent of any external libraries or frameworks.
- **Entities**: Plain Dart classes (using Freezed) representing our data models (e.g., `User`, `Category`, `Channel`).
- **Repositories (Interfaces)**: Abstract definitions of the operations possible on our data.

### 2. Infrastructure Layer (`lib/core/infraestructure`)
Contains the concrete implementation of the Domain's repository interfaces.
- **Repositories (Implem)**: Implementation using libraries like `Dio` for HTTP requests or `SharedPreferences` for local storage.
- **DTOs**: Data Transfer Objects used to parse JSON from APIs before converting them to Domain Entities.

### 3. Application Layer (`lib/core/application`)
Mediates between the Domain and Infrastructure layers.
- **Use Cases**: Orchestrate the flow of data to and from the domain entities.
- **States**: Freezed Union types representing the possible states of an operation (e.g., `Initial`, `Loading`, `Success`, `Error`).

### 4. UI Layer (`lib/ui`)
The presentation layer where Flutter widgets live.
- **Screens**: Full pages of the application.
- **Providers**: Riverpod providers that bridge the gap between the UI and the Application/Infrastructure layers.
- **Shared**: Reusable widgets and theme configurations.

## Directory Structure

```text
lib/
├── config/             # App configuration (Router, Theme, Environments)
├── core/
│   ├── application/    # Business logic orchestration (States, UseCases)
│   ├── domain/         # Core business entities and repository interfaces
│   ├── infraestructure/ # External implementations (HTTP, Storage, DTOs)
│   └── shared/         # Common utilities and exceptions
└── ui/                 # Presentation layer (Screens, Providers, Widgets)
```

## Technology Stack

- **Flutter**: UI Framework.
- **Riverpod 3.0**: State management and dependency injection.
- **Freezed**: Code generation for immutable classes and union types.
- **Dio**: HTTP client for API communication.
- **fpdart**: Functional programming utilities (e.g., `Either` for error handling).
- **GoRouter**: Declarative routing system.
