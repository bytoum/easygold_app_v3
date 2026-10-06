# EasyGold App

Flutter mobile app for a gold and customer-service platform. It currently provides the app shell, authentication, a home route, dependency injection, typed REST clients, and use cases for remote app configuration.

> **Status:** under active development. Several screens are scaffolds, and `test/widget_test.dart` is still the unmodified Flutter template test.

## Quick Start

Requires [FVM](https://fvm.app/) (Flutter `3.47.5`, pinned in [.fvmrc](.fvmrc)), plus Android Studio or Xcode with an emulator or device.

```bash
fvm use 3.47.5
cp .env.example .env          # then fill in the values (see Configuration)
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart -O lib/generated
fvm flutter run
```

## Configuration

Environment values are read from a local `.env` through [`EnvConfig`](lib/config/env_config.dart) (Envied, obfuscated at build time). Copy [.env.example](.env.example) and fill it in:

| Key | Required | Purpose |
| --- | --- | --- |
| `SECRET_OTP` | Yes | OTP secret for development |
| `BASE_END_POINT` | Yes | API base URL |
| `AWS_ACCESS_KEY`, `AWS_SECRET_KEY`, `AWS_BUCKET_NAME` | No | Load translations from S3 |
| `AWS_REGION` | No | S3 region (default `ap-southeast-1`) |

Re-run `build_runner` after changing `.env`. Never commit `.env` or credentials.

### Localization

Five locales are supported: `en-US`, `lo-LA`, `ko-KR`, `vi-VN`, `zh-CN`. Translations are loaded from S3 when AWS credentials are set, and fall back to the bundled files in `assets/translations/` if they are missing or the request fails. Add every new key to **all five** files, then regenerate the keys:

```bash
fvm dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart -O lib/generated
```

## Tech Stack

| Area | Packages |
| --- | --- |
| UI | `material_ui`, `flutter_form_builder`, `overlay_kit` |
| State | `flutter_bloc` (Cubits), `freezed` |
| Navigation | `go_router` |
| DI | `get_it`, `injectable` |
| Networking | `dio`, `retrofit`, `json_serializable` |
| Errors | `dartz` (`Either<Failure, T>`) |
| Storage / config | `shared_preferences`, `flutter_secure_storage`, `envied` |
| Localization | `easy_localization` |
| Push / cloud | `firebase_core`, `firebase_messaging`, `aws_signature_v4` |

## Architecture

Feature-first, layered:

```text
Presentation (pages, Cubits) → Use cases → Domain repositories → Data repositories / datasources → Retrofit + Dio
```

```text
lib/
├── config/        routes, env config, themes
├── core/          DI, constants, errors, extensions, models, network, services, usecases, utils, widgets
├── features/      auth, home (each: data / domain / presentation)
├── generated/     generated assets, fonts, locale keys
└── main.dart
assets/            fonts, images, translations
test/              tests
```

`main.dart` initializes `GetIt` (`configureDependencies`) before mounting `EasyLocalization` and `MyApp`. `GoRouter` starts at the splash route; routes are `/`, `/home` and `/sign-in` (`Routes.signUp` is declared but has no `GoRoute` yet). Authentication-based redirects are currently disabled in `app_router.dart`.

## Development

```bash
fvm dart format lib test
fvm flutter analyze
fvm flutter test
```

- Run `build_runner` after changing Freezed/JSON models, Retrofit clients, Injectable registrations, or Envied config.
- Don't hand-edit generated files (`*.g.dart`, `*.freezed.dart`, `*.config.dart`, `*.gen.dart`, `lib/generated/`).
- Keep presentation, domain, and data responsibilities separate; return `Either<Failure, T>` from use cases.
- Commits follow [Conventional Commits](https://www.conventionalcommits.org/) (e.g. `feat(auth): add OTP sign-in`). The first commits (`setup: ...`) predate this rule.
- Branches `main`, `staging` and `development` are protected. Branch new features from `development`, hotfixes from `main` (PR back to `main`, then merge it into `development` and `staging`), and open staging PRs from `development`.
- Commit `pubspec.lock` whenever dependencies change.
- All user-facing UI text goes through `LocaleKeys`.
- AI agents: see [AGENTS.md](AGENTS.md).

There is no CI workflow or release process yet.

## Known Gaps

- Firebase packages are installed, but no `google-services.json` or `GoogleService-Info.plist` is checked in.
- The default widget test doesn't match the app UI and should be replaced.

## License

No license file is currently included.
