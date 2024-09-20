# Flutter To-Do App

## Overview

The Flutter To-Do app allows users to list and store tasks, set reminders, and customize alert times. Users can choose the reminder time (e.g., 5 minutes before the task) and set the frequency for daily, weekly, monthly, or yearly repetition. The app includes theme switching between dark and light modes and is optimized for iOS devices, with smooth animations for an enhanced user experience.

## Features

- **Task Creation:** Add tasks with titles, descriptions, and due dates.
- **Reminders:** Set reminders with customizable time alerts (e.g., 5 minutes before, 1 hour before).
- **Repeat Options:** Choose the reminder frequency: none, daily, weekly, monthly, or yearly.
- **Theme Switching:** Easily switch between dark and light modes.
- **Animations:** Smooth animations throughout the app for a better user experience.
- **iOS Optimized:** Designed with iOS users in mind, providing a native-like experience.
  
## Installation

1. Clone the repository:
    ```bash
    git clone https:https://github.com/MohsenBahaj/To-Do-App
    cd flutter-todo-app
    ```

2. Install dependencies:
    ```bash
    flutter pub get
    ```

3. Run the app on your connected device or emulator:
    ```bash
    flutter run
    ```

## Usage

1. **Add a Task:**
    - Click the **+** button to add a new task.
    - Enter the task title and description.
    - Set the due date and time.

2. **Set a Reminder:**
    - When creating a task, choose a reminder time (e.g., 5 minutes before).
    - Select whether the reminder should repeat (daily, weekly, monthly, yearly, or none).

3. **Switch Themes:**
    - Go to the settings menu to toggle between dark and light themes.

4. **View Tasks:**
    - View your tasks in a list format, with upcoming reminders displayed prominently.

## State Management and Storage

This app utilizes the following technologies:

- **GetX:** For efficient state management, navigation, and reactive UI updates.
- **SQFlite:** Used as the local database to store tasks and reminders persistently on the user's device.
- **GetStorage:** To store user preferences, such as the selected theme (dark or light mode).
- **SharedPreferences:** For lightweight storage of user settings and app configurations that do not require a full database.

## Dependencies

Make sure to add these dependencies in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.1
  sqflite: ^2.0.0+4
  path_provider: ^2.0.2
  get_storage: ^2.0.3
  shared_preferences: ^2.0.6
