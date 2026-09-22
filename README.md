# gastrack-app

GasTrack — Motorcycle Maintenance Tracker Mobile App built with Flutter (Android + iOS).

## Technology Stack

- **Framework:** Flutter 3.47.5 (Dart 3.13.4)
- **Platforms:** Android · iOS
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Backend:** [gastrack-ms](https://github.com/ilhamasy/gastrack-ms) (Golang REST API)

## Prerequisites

- Flutter 3.47.5+ (managed via [FVM](https://fvm.app/))
- Android Studio / Xcode for device/emulator builds
- A running instance of `gastrack-ms`

## Project Structure

```
lib/
  core/
    config/       # App configuration and environment
    network/      # HTTP client, interceptors
    storage/      # Local cache / persistent storage
    errors/       # Error types and handling
    routing/      # GoRouter configuration
    utils/        # Shared utilities
  data/
    models/       # API/DTO models
    datasources/  # Remote and local data sources
    repositories/ # Data layer implementations
  domain/
    entities/     # Domain entities
    repositories/ # Repository interfaces
    usecases/     # Business use cases
  features/
    dashboard/
      presentation/
      state/
    history/
      presentation/
      state/
    maintenance/
      presentation/
      state/
    settings/
      presentation/
      state/
  main.dart

test/
assets/
android/
ios/
```

## Local Setup

1. **Install FVM**
   ```bash
   brew install fvm
   ```

2. **Install Flutter via FVM**
   ```bash
   fvm install stable
   fvm global stable
   ```

3. **Clone the repo**
   ```bash
   git clone https://github.com/ilhamasy/gastrack-app.git
   cd gastrack-app
   ```

4. **Install dependencies**
   ```bash
   fvm flutter pub get
   ```

5. **Copy environment config**
   ```bash
   cp .env.example .env
   # Edit .env with your local API URL
   ```

6. **Run the app**
   ```bash
   fvm flutter run
   ```

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `API_BASE_URL` | Backend API base URL | `http://localhost:8080/api` |

> ⚠️ Never commit real credentials. Use `.env` locally (excluded by `.gitignore`).

## Architecture

```
UI (Widgets)
    ↓
State Management (Riverpod)
    ↓
Use Case / Domain
    ↓
Repository
    ↓
Remote Data Source (REST API) / Local Cache
```

- Widgets are presentation only — no business logic
- Business rules live in use cases and are enforced by the backend
- Maintenance calculations are authoritative on the backend
- Local cache provides resilience for read-only data

## Related Repositories

- **Backend API:** [gastrack-ms](https://github.com/ilhamasy/gastrack-ms) — Golang REST API
