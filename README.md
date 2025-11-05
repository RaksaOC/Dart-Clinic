## Dart Clinic – Hospital Management CLI

Command-line hospital management system built with Dart. The app provides two role-based portals (Doctor and Manager) that sit on top of a layered architecture (UI → Controllers → Services → Repositories → JSON data files). Doctors can manage their appointments, patients, and prescriptions, while managers coordinate rooms, admissions, and staffing.

### Highlights

-   **Doctor portal**: schedule, view, complete, and cancel appointments; review patients; issue prescriptions tied to completed visits.
-   **Manager portal**: administer rooms, admissions, doctors, managers, and patients; enforces one active admission per patient and room occupancy rules.
-   **Session-aware services**: singleton `SessionService` drives authentication and keeps portals scoped to the logged-in user.
-   **JSON-backed persistence**: repository layer serializes data into `lib/db/*.json`; UUIDs are used for new records while legacy seed data ships with human-readable IDs.
-   **Structured CLI experience**: interactive prompts powered by `prompts`, ANSI terminal helpers, and formatter utilities to render card-style menu options.

### Project Layout

```
bin/                Application entry point (`dart run bin/dart_clinic.dart`)
lib/
	ui/              Role-based CLI menus and flows
	domain/          Models + controllers that wrap services for the UI layer
	services/        Business logic (appointments, admissions, rooms, etc.)
	data/            Repository implementations targeting JSON storage
	utils/           Terminal helpers and display formatters
	db/              Seed data files consumed by repositories
test/               Placeholder for automated tests (currently empty)
```

### Prerequisites

-   Dart SDK `^3.9.2`
-   (Optional) Make sure your shell supports ANSI escape codes for clear-screen calls. Windows Terminal, PowerShell 7+, macOS Terminal, and most Linux terminals are all fine.

Install dependencies:

```sh
dart pub get
```

### Run the App

```sh
dart run bin/dart_clinic.dart
```

When the app starts you will be prompted to choose a portal. Use the sample credentials below or add your own records by editing the JSON files.

### Seed Credentials & Data

The project reads and writes JSON documents in `lib/db/`. Sample data covers managers, doctors, patients, rooms, appointments, prescriptions, and admissions. Every service writes back through its repository, so changes made at runtime persist to disk.

| Role    | Name          | Email                   | Password   |
| ------- | ------------- | ----------------------- | ---------- |
| Manager | Sok Vannak    | vannak.sok@clinic.kh    | manager123 |
| Manager | Sreyleak Chum | sreyleak.chum@clinic.kh | secret456  |
| Doctor  | Dara Sovann   | qw                      | qw         |
| Doctor  | Chenda Phan   | chenda.phan@clinic.kh   | heart456   |
| Doctor  | Piseth Nguon  | piseth.nguon@clinic.kh  | kids789    |

> Note: Although `sqlite3` is listed as a dependency, the current implementation persists to JSON files. Migrating to SQLite was planned but not yet completed.

### Development Commands

-   Lint: `dart analyze`
-   Tests: `dart test` (the test suite is currently just a scaffold)

### Extending the System

-   Add new services/controllers inside `lib/services` and `lib/domain/controllers` to encapsulate business rules before exposing them in the UI layer.
-   Repositories inherit from `RepositoryBase<T>`; override `toJson`/`fromJson` to plug in new entities.
-   When adding CLI flows, reuse `TerminalUI` for screen handling and `formatCardOptions` for consistent menu rendering.

### Known Gaps / TODOs

-   Admissions service does not yet synchronize admitted patient lists back to `PatientService.getAdmittedPatients` (method returns an empty collection).
-   No automated coverage beyond the empty placeholder test; critical workflows are manual.
-   Credentials are stored in plain text within JSON files; introduce hashing before production use.
