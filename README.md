# EasyGold App

EasyGold App is a Flutter mobile application scaffold for a gold and customer-service platform. It provides the application shell, authentication and home routes, dependency injection, REST clients, generated data models, and service-oriented use cases for remote app configuration.

## Status and Scope

This project is under active development. It is currently a foundation for the mobile app rather than a finished gold-trading product: several screens are scaffold implementations, and the default widget test still comes from the Flutter template.

The repository is a good fit for contributors extending a Flutter app with a feature-first architecture, typed API clients, and generated model/dependency code. It is not yet a drop-in package or a production-readiness reference.

## Quick Start

From a clean checkout with Flutter `3.47.5` available through FVM:

```bash
fvm flutter pub get
fvm flutter run
```

Before running the app, create a local `.env` file as described below.

## Technology Stack

- Flutter `3.47.5` on the stable channel, managed with [FVM](https://fvm.app/)
- Dart SDK `^3.13.4`
- Dart/Flutter with Material UI
- `flutter_bloc` for state management
- `go_router` for navigation and route guards
- `get_it` and `injectable` for dependency injection
- `dio` and `retrofit` for HTTP clients
- `freezed` and `json_serializable` for immutable models and JSON mapping
- `dartz` for functional error handling with `Either`
- `shared_preferences` for local persistence
- `envied` for generated environment configuration
- `flutter_test` and `flutter_lints` for testing and static analysis

## Architecture

The app follows a feature-first, layered architecture:

```text
Presentation (pages, Cubits)
          |
       Use cases
          |
   Domain repositories
          |
 Data repositories / remote data sources
          |
     Retrofit + Dio API clients
```

Cross-cutting concerns live under `lib/core`, including dependency injection, networking, models, failures, shared widgets, and use-case abstractions. Feature-specific code lives under `lib/features`, currently including `auth` and `home`.

Application startup initializes the `GetIt` service locator before mounting `MyApp`. `GoRouter` starts at the splash route and redirects unauthenticated users to sign-in.

## Getting Started

### Prerequisites

- Flutter `3.47.5`
- FVM, or a local Flutter installation matching the version in `.fvmrc`
- Android Studio/Xcode and a configured emulator or physical device for mobile builds

### Setup

1. Clone the repository and enter the project directory.
2. Select the pinned Flutter SDK from [.fvmrc](.fvmrc):

   ```bash
   fvm use 3.47.5
   ```

3. Create a local `.env` file. The application currently expects these keys through [`EnvConfig`](lib/config/env_config.dart):

   ```dotenv
   SECRET_OTP=<your-development-otp-secret>
   BASE_END_POINT=<your-api-base-url>
   ```

   Keep `.env` local; environment files are excluded by `.gitignore`.

4. Install dependencies:

   ```bash
   fvm flutter pub get
   ```

5. Generate localization keys:

   ```bash
   flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart
   ```

6. Generate code after changing Retrofit clients, Injectable registrations, Envied configuration, or Freezed/JSON models:

   ```bash
   fvm dart run build_runner build --delete-conflicting-outputs
   ```

7. Run the app on a configured emulator or device:

   ```bash
   fvm flutter run
   ```

## Project Structure

```text
lib/
├── config/                 App routes, environment config, and themes
├── core/
│   ├── DI/                 GetIt and Injectable setup
│   ├── constants/          Shared enums and constants
│   ├── errors/             Exceptions and domain failures
│   ├── models/             Shared API models
│   ├── network/            Dio and Retrofit clients
│   ├── services/           Cross-cutting services and interceptors
│   ├── usecases/           Shared use-case contracts
│   └── widgets/            Reusable app widgets
├── features/
│   ├── auth/               Authentication Cubit and sign-in UI
│   └── home/               Home presentation, domain, and data layers
├── generated/              Generated asset helpers
└── main.dart               Application entry point
assets/images/              Image assets
android/                    Android host project
ios/                        iOS host project
test/                       Flutter widget and unit tests
```

See [`pubspec.yaml`](pubspec.yaml) for dependency versions and Flutter asset configuration.

## Key Features

- Flutter application shell with Material UI.
- Splash, sign-in, home, and not-found routes.
- Authentication-aware route redirection through `GoRouter`.
- Injectable/GetIt dependency registration for API clients, repositories, use cases, and persistence.
- Retrofit clients backed by Dio with a shared interceptor.
- Remote app configuration use cases for version availability, version details, bill backgrounds, titles, contacts, social media, and locations.
- Generated assets, environment configuration, JSON serialization, and immutable model support.

## Development Workflow

The repository does not currently contain a checked-in CI workflow, branching strategy, or contribution policy. A practical local workflow is:

```bash
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter analyze
fvm flutter test
```

Keep generated files generated, keep secrets out of source control, and make focused changes within the relevant feature or core layer. No formal branching strategy, CI badge, or release process is documented in the repository yet.

## Coding Standards

- Follow the Dart style enforced by `flutter_lints` and `analysis_options.yaml`.
- Prefer feature-local code under `lib/features` and reusable infrastructure under `lib/core`.
- Keep presentation, domain, and data responsibilities separate.
- Use repository interfaces and use cases at domain boundaries.
- Represent recoverable failures with the existing `Failure`/`Either` pattern.
- Do not edit generated files such as `*.g.dart`, `*.freezed.dart`, or generated Injectable configuration manually; regenerate them with build_runner.
- Do not commit `.env` files or credentials.

## Testing

Tests use Flutter's `flutter_test` package and live under `test/`. Run the suite with:

```bash
fvm flutter test
```

The current `test/widget_test.dart` is the default Flutter counter smoke test and does not yet match the current app UI, so it should be replaced with tests for routing, authentication state, home content, and data-layer behavior as those features are implemented.

## Contributing

1. Create a focused branch for your change.
2. Update generated code when changing annotated models, clients, or dependency registrations.
3. Run formatting, analysis, and tests before opening a pull request:

   ```bash
   fvm dart format lib test
   fvm flutter analyze
   fvm flutter test
   ```

4. Keep pull requests small, describe configuration changes, and never include secrets.

## License

No license file is currently included in the repository.
