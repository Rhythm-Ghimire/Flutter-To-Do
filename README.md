# Flutter To-Do

A simple, offline to-do app built with Flutter. Tasks are stored locally in a SQLite database, so they stay on the device between sessions.

**Tech stack:** Flutter, Dart, SQLite (`sqflite`)

## Features

- **Create, read, update, and delete** tasks (full CRUD).
- Three views from the bottom navigation bar: **Uncompleted**, **Completed**, and **All Tasks**.
- **Search** across all tasks.
- Confirmation dialogs before deleting a task or changing its status.
- Local storage with SQLite, so no internet connection or account is needed.

## Project structure

```
lib/
├── main.dart            App entry point and theme
├── todo_model.dart      Todo data model (id, title, isCompleted)
├── db_helper.dart       SQLite database setup and CRUD operations
├── todo_screen.dart     Main screen with the three task views
├── add_edit_dialog.dart Dialog for adding and editing tasks
├── delete_dialog.dart   Delete confirmation dialog
├── status_dialog.dart   Status-change confirmation dialog
└── search_screen.dart   Search delegate
```

## Getting started

**Prerequisites:** [Flutter SDK](https://docs.flutter.dev/get-started/install) and an emulator or physical device.

```bash
git clone https://github.com/Rhythm-Ghimire/Flutter-To-Do.git
cd Flutter-To-Do
flutter pub get
flutter run
```

## Possible improvements

- Add due dates and reminders.
- Add task categories and sorting.
- Add widget tests.

## Author

**Rhythm Kashyap Ghimire**
[GitHub](https://github.com/Rhythm-Ghimire)
