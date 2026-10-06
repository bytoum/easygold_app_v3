# AGENTS.md

Flutter client app (Flutter 3.47.5 via FVM, Dart ^3.13.4). Prefix every command with `fvm`.
Overview, env keys, tech stack: [README.md](README.md). Not repeated here.
Client-only: no database, migrations, backend, CI, or git hooks in this repo.

## Setup

```bash
fvm flutter pub get
cp .env.example .env   # fill in locally; never print, commit, or paste .env values
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart -O lib/generated
```

Generated code is gitignored, so a fresh checkout does not compile until both codegen commands run.
Re-run `build_runner` after changing Freezed/JSON models, Retrofit clients, Injectable annotations, or `EnvConfig`.
Re-run the localization command after changing `assets/translations/*.json`.

## Required validation (before reporting done)

```bash
fvm dart format <changed files>     # not `lib test`: the tree is dirty, see Git
fvm flutter analyze
fvm flutter test
```

- Run codegen first. Stale generated code passes `analyze` but fails `test`.
- `analyze` skips generated files and `lib/config/env_config.dart`.
- `test/widget_test.dart` is the unmodified Flutter template and fails at its own assertions.
  Report it as pre-existing; do not fix it as a side effect.
- These three commands are the only gate. There is no CI.
- New tests: use `flutter_test` with `mocktail` and `bloc_test`. Neither mock library is in `pubspec.yaml` yet;
  add them to `dev_dependencies` with the first test that needs them.

## Architecture (reference feature: `lib/features/auth/**`)

- Layout: `lib/features/<feature>/{data,domain,presentation}`; shared code in `lib/core`; routes/themes/env in `lib/config`.
- Flow: Cubit -> `UseCase<R, P>` (`lib/core/usecases/usecase.dart`) -> abstract repository (domain)
  -> `*RepositoryImpl` -> `*RemoteDataSource` -> Retrofit client.
- Errors: data sources catch `DioException` and throw `ServerException`; repository impls catch
  `ServerException` and return `Left(ServerFailure)`; Cubits read the `Either` and do not catch.
  `CacheException` is thrown only by `StorageServiceImpl` and no repository handles it yet.
- DI: Injectable annotations (`@LazySingleton(as: ...)`, `@lazySingleton` for use cases, `@injectable` for Cubits).
  Third-party objects (Dio, storage, API clients) are registered only in `lib/core/DI/register_modules.dart`.
- Retrofit: a new client is `part of 'rest_client.dart'`, needs a matching `part` line in `rest_client.dart`,
  and a getter in `InjectionModule`. See `app_client.dart`, `auth_client.dart`.
- State: Freezed state class with `DataStatus` (`lib/core/constants/enums/data_status.dart`).
  Models in `lib/core/models` use Freezed + json_serializable.
- Routes: constant in `lib/config/routes/routes.dart`, then `GoRoute` in `app_router.dart`.
- UI imports `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`.
- Localization: 5 locales. All user-facing UI text goes through `LocaleKeys` (`lib/generated/locale_keys.g.dart`).
  Add every new key to all five `assets/translations/*.json`, then regenerate.
  Existing pages (`sign_in_page.dart`, `home_page.dart`) still hardcode English; migrate those strings when you touch them.
- Code uses Dart 3.13 syntax (`const new(...)`, `required this._field`). The analyzer accepts it; do not rewrite it.

## Never edit by hand

`*.g.dart`, `*.freezed.dart`, `*.config.dart`, `*.gen.dart`, `lib/generated/`. Regenerate instead.
All are gitignored; do not `git add -f` them. `.env*` is gitignored except `.env.example`.

## Security-sensitive: stop and ask before changing

- `lib/features/auth/**`, `lib/core/network/auth_client.dart`, `lib/core/services/storage_service.dart`,
  `lib/core/services/dio_interceptor_service.dart`.
- `EnvConfig` obfuscation is not encryption: every value ships in the app binary. Add no new secrets to it.
- Persist tokens on-device through `StorageService.writeSecureData` (Keychain/Keystore), never `SharedPreferences`.
  No code persists tokens yet; do not invent a scheme without instruction.
- Do not log request/response bodies, headers, tokens, or `UserModel` fields (`password`, `pinCode`).
  The interceptor logs method, path, and status only; keep it that way.
- `AuthCubit.signInWithPassword` sends placeholder `code`, `fmcToken`, `uuid` to the real endpoint (TODOs).
  Do not replace or "complete" them without instruction.
- The route auth guard in `app_router.dart` is commented out on purpose. Enabling it changes behavior.

## Known issues (do not copy these patterns)

- Risk: `AWS_ACCESS_KEY` / `AWS_SECRET_KEY` are compiled into the binary via `EnvConfig`
  (used by `S3AssetLoaderService`). Do not add AWS credentials or extend this path.

## Git

- Commits follow [Conventional Commits](https://www.conventionalcommits.org/), e.g. `feat(auth): add OTP sign-in`.
- Protected branches: `main`, `staging`, `development`. Never push to them directly; use PRs.
- New feature: branch from `development`. Hotfix: branch from `main`, PR targets `main`; after it lands, merge it back into `development` and `staging`. Staging PRs are opened from `development`.
- When `pubspec.yaml` dependencies change, commit `pubspec.lock` in the same commit.
- Do not commit, push, or open PRs unless asked. The tree is dirty: do not revert, stage, or reformat unrelated files.
- Never commit `.env`.

## Task-specific requirements

Belong in the task or PR description, not here: target feature, acceptance criteria, backend endpoint,
which locales need real copy.

## Completion report

End every task with:

- **Changed:** files and one-line reason each.
- **Ran:** each validation command and its result (pass/fail, error count). Say which were not run and why.
- **Codegen:** whether `build_runner`/localization generate ran, and whether generated files changed.
- **Pre-existing failures:** anything failing that you did not cause.
- **Security-sensitive files touched:** yes/no, which.
- **Needs human decision:** open questions or assumptions.
