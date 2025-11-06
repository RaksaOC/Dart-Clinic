## Dart Clinic – Hospital Management CLI

Command-line hospital management system built with Dart. The app provides two role-based portals (Doctor and Manager) implemented over a layered architecture (UI → Controllers → Services → Repositories → JSON data files). Doctors manage appointments, patients, and prescriptions; managers coordinate rooms, admissions, and staffing.

### Highlights

- Doctor portal: schedule, view, complete, and cancel appointments; review patients; issue prescriptions.
- Manager portal: manage rooms, admissions, doctors, managers, and patients; one active admission per patient; room occupancy enforced.
- Authentication: `SessionService` singleton; passwords stored as SHA‑256 hashes in JSON.
- Persistence: repositories read/write `lib/db/*.json`; all records use UUIDs (seed credentials below still work).
- CLI experience: interactive `prompts`, ANSI screen helpers, and card-style formatting for options.

### Project Layout

```
bin/                Application entry point (`dart run bin/dart_clinic.dart`)
lib/
  ui/               Role-based CLI menus and flows
  domain/           Models and controllers for the UI layer
  services/         Business logic (appointments, admissions, rooms, etc.)
  data/             Repository implementations for JSON storage
  utils/            Terminal helpers and display formatters
  db/               Seed data files consumed by repositories
test/               Unit tests per service (session, appointment, admission, etc.)
```

### Prerequisites

- Dart SDK `^3.9.2`
- (Optional) Make sure your shell supports ANSI escape codes for clear-screen calls. Windows Terminal, PowerShell 7+, macOS Terminal, and most Linux terminals are all fine.

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

The project reads and writes JSON documents in `lib/db/`. Sample data covers managers, doctors, patients, rooms, appointments, prescriptions, and admissions. Services write back via repositories, so changes made at runtime persist to disk. Passwords are hashed in the JSON files; use the plaintext values below to log in.

| Role    | Name        | Email                | Password |
| ------- | ----------- | -------------------- | -------- |
| Manager | Sok Vannak  | sokvannak@gmail.com  | 123      |
| Doctor  | Dara Sovann | darasovann@gmail.com | 123      |

### AI Usage (disclosure)

- Seed DB: assisted in generating initial JSON seed content.
- Controllers: helped scaffold boilerplate and map controller methods to existing service methods; business rules remain in services.
- Service layer: limited usage (≈15%) for algorithm hints and Dart syntax lookups; core domain logic designed and implemented by us.
- Models: designed manually.
- UI layer: significant assistance for prompt flows and formatting; we designed control-flow (loops, switches) and file organization.
- Repo layer: assited in generating boilerplate code, keys ref from the models, and file io operations. abstract, inheritence, generic type design was made by us.
- Utils: formatter boilerplate (card design) assisted; we designed the breakdown and integration. Terminal utility based on public ANSI examples.
- Tests: assisted in generating mock data scaffolding; test cases and assertions were designed by us.
