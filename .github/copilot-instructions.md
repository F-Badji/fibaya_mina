## Quick orientation for AI coding agents

This repository is a mobile-first service platform (Flutter frontend) with a Java Spring Boot backend. Use this doc to get productive quickly: what to open, how to run, and project-specific patterns to follow.

Most important paths
- Frontend (Flutter): `lib/` (entry points: `lib/main_client.dart`, `lib/main_prestataire.dart`, `lib/main_admin.dart`)
- Shared Flutter config and services: `lib/common/` (notably `lib/common/config.dart` and `lib/common/services/api_service.dart`)
- Backend (Spring Boot): `backend/` (entry: `backend/src/main/java/.../FibayaBackendApplication.java`, build: `backend/pom.xml`)
- Project scripts: `start.sh`, `stop.sh`, `setup_network.sh`

Big-picture architecture (what matters)
- Single repo mono-repo: Flutter clients (three apps) talk to one Spring Boot API at `http://localhost:8080/api` by default.
- Data flow: Flutter UI -> `lib/common/services/*` -> backend REST endpoints under `/api/*` (see `ApiService` for examples).
- Database: PostgreSQL used by backend; schema / seed scripts live under `database/` and backend uses `data.sql` / Hibernate to create tables.

Developer workflows (concrete commands)
- Start full local dev environment (macOS/Linux):
  1. Ensure prerequisites: Java 17+, Maven, Flutter, PostgreSQL, ADB (for Android emulator).
  2. From repo root run:
     - `./start.sh` — automated script that: checks Postgres, creates DB `Fibaya` (runs `database/setup.sql` if present), builds & runs backend (`mvn spring-boot:run`), runs Flutter (`flutter run lib/main_client.dart`) and configures forwarding.
  3. Stop everything: `./stop.sh`

- Backend-only:
  - Build: `cd backend && mvn clean package`
  - Run: `cd backend && mvn spring-boot:run` or `java -jar target/*.jar`

- Flutter-only:
  - Install deps: `flutter pub get`
  - Run client: `flutter run lib/main_client.dart`
  - For emulator networking: run `./setup_network.sh` to set `adb reverse tcp:8080 tcp:8080` so `http://localhost:8080` from emulator resolves to host.

Key project-specific conventions and patterns (do not invent alternatives)
- API base URL is stored in `lib/common/config.dart` as `AppConfig.baseApiUrl` and many services use it (e.g. `lib/common/services/api_service.dart`). Changing the backend port requires updating this or using environment config.
- Services in Flutter are plain static classes (see `ApiService`) that use `package:http` and return simple JSON/maps or booleans. Follow existing error handling: many methods catch exceptions and return safe defaults (`null`, `false`, or `{'exists': false}`).
- Backend uses Spring Boot + JPA. Lombok is used in model classes — make sure your IDE has Lombok enabled to avoid missing-symbol issues.

Integration points and cross-component communication
- Flutter -> Backend: HTTP REST calls to endpoints like `/api/services`, `/api/auth/*`. Inspect `lib/common/services/*` to find exact paths.
- Emulator networking: `setup_network.sh` and `start.sh` rely on `adb reverse` for Android emulator. For iOS simulator, `localhost` works directly.
- DB initialization: `start.sh` tries to run `database/setup.sql` and there is `backend/src/main/resources/data.sql` referenced in README; backend may also auto-create tables through Hibernate.

Files to open first when troubleshooting
- `lib/common/services/api_service.dart` — concrete example of how frontend calls backend and handles errors.
- `lib/common/config.dart` — change base API URL here for local/debug runs.
- `start.sh` / `stop.sh` — orchestrates dev environment and contains useful sequences (DB create, mvn build, flutter run).
- `backend/pom.xml` — dependency list and Java version (Java 17). Use this to discover Spring Boot version (3.2.0).

Editing and tests
- Small Flutter changes: run `flutter pub get` then `flutter run` against the appropriate `main_*.dart` entry file.
- Backend tests: Maven is configured; run `cd backend && mvn test` to run unit tests.

Typical pitfalls for AI edits
- Do not assume config injection: many strings are hard-coded (e.g., `AppConfig.baseApiUrl`). Update that single source rather than patching multiple service files.
- Lombok-generated methods may hide fields; when editing backend model classes, ensure you preserve Lombok annotations or add explicit getters/setters.
- When changing API endpoints, update all frontend callers under `lib/common/services`.

Example snippets to reference (copyable)
- Update API URL (Flutter): `lib/common/config.dart` -> set `baseApiUrl` to the running backend (e.g., `http://10.0.2.2:8080/api` when not using `adb reverse`).
- Check backend status used by `start.sh`: `curl http://localhost:8080/api/services`

If you change behavior or add features
- Run the full stack via `./start.sh`, exercise the flows in the client app (login/register -> list services -> booking) and verify backend endpoints using Postman or `curl`.

When uncertain, open these files for context before coding:
- `README.md`, `start.sh`, `stop.sh`, `setup_network.sh`, `backend/pom.xml`, `lib/common/config.dart`, `lib/common/services/api_service.dart`.

Feedback
- If any section is unclear or you'd like more examples (e.g., how models map to DB tables or where to add tests), tell me which area to expand.
