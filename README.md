# Intern Tasks — Flutter Development Internship

A single Flutter app built for the **DevelopersHub Flutter Development Interns Task**.
It bundles every week's learning objective into one runnable app: a login flow,
a counter, a to-do list, and a final task-management screen — all reachable from
a home "hub" screen.

The repo history is split into four commits, one per learning milestone, so each
topic from the task document can be reviewed independently.

## Tech

- **Flutter** 3.41 / **Dart** 3.11
- **State management:** `setState` (as required by the Week 2 objective — not a
  third-party state library, on purpose)
- **Local storage:** `shared_preferences`

## Getting started

```bash
flutter pub get
flutter run        # runs on a connected device/emulator
flutter test       # runs the widget tests
flutter analyze    # static analysis
```

## Project structure

```
lib/
  main.dart                 # app entry, theme, first screen
  screens/
    login_screen.dart       # Week 1 — login UI, validation, navigation
    home_screen.dart        # the hub reached after login
    counter_screen.dart     # Week 2 — counter (setState + persistence)
    todo_screen.dart        # Week 2 — to-do list (ListView + persistence)
test/
  widget_test.dart          # login validation + navigation tests
  counter_screen_test.dart  # counter increment/decrement/reset + persistence
  todo_screen_test.dart     # to-do add/delete + persistence
```

---

## Week 1 — Basic Flutter Development & UI Building

**Goal:** a basic app with a login screen and navigation to a home screen.

What's implemented:

- **Login UI** (`login_screen.dart`) built with `Column`, `Row` and `Container`:
  - Two `TextFormField`s for **email** and **password**.
  - A login button and a **"Forgot Password?"** `Text`.
- **Navigation** from login → home with `Navigator.push()`, passing the entered
  email to the `HomeScreen`.
- **Form validation:**
  - Email is checked against a proper email-format regex.
  - Password must not be empty.
- Widget tests cover empty-field errors, malformed email, and successful
  navigation.

### Note on `FlatButton`

The task document mentions `FlatButton`. That widget was **removed in Flutter
3.x** and no longer exists. This app uses `ElevatedButton` (and `TextButton` for
the reset action), which are its official replacements.

---

## Week 2 — Data Management & Persistent Storage

**Goal:** basic state management with `setState` and local persistence with
`SharedPreferences`. Reached from the home hub.

What's implemented:

- **Counter** (`counter_screen.dart`):
  - State managed with `setState` — Increase / Decrease / Reset.
  - Value saved to `SharedPreferences` on every change and restored on app
    restart (key `counter_value`).
- **To-Do List** (`todo_screen.dart`):
  - Add tasks via a `TextField` + button.
  - Tasks shown in a `ListView`; swipe a row or tap the trash icon to delete.
  - List persisted to `SharedPreferences` as a string list (key `todo_items`).
- **Home hub** (`home_screen.dart`) now lists each feature as a tappable card
  and navigates to it with `Navigator.push()`.
- Widget tests cover counter increment/decrement/reset and persistence, and
  to-do add/delete/empty-state and persistence (`SharedPreferences` mocked).
