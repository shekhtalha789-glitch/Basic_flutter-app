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
test/
  widget_test.dart          # login validation + navigation tests
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
