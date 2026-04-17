# Task Management App

A modern, cross-platform task management application built with Flutter. This intuitive app helps you organize your daily tasks efficiently, with features for adding, editing, deleting, and tracking task completion. Built with a clean architecture using Provider for state management and Shared Preferences for local data persistence.

## ✨ Features

- **Task Management**: Add, edit, delete, and mark tasks as complete
- **Data Persistence**: Tasks are saved locally using Shared Preferences
- **Clean UI**: Modern Material Design interface
- **State Management**: Uses Provider pattern for efficient state handling

## 🎥 Demo

Watch the demo video to see the app in action:

https://github.com/user-attachments/assets/d16f72d6-50fc-4d47-a31e-3efd038813c3

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (version 3.0 or higher): [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (comes with Flutter)
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA with Flutter plugin
- **Device/Emulator**: Android/iOS emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/muhammadSaadXCII/flutter_task_manager_app.git
   cd flutter_task_manager_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📖 Usage

1. Launch the app on your device or emulator
2. Tap the "+" button to add a new task
3. Enter your task details and save
4. Mark tasks as complete by tapping the checkbox
5. Swipe or use the delete button to remove tasks
6. Use the filter tabs to view all, completed, or pending tasks

## 📦 Dependencies

- [flutter](https://flutter.dev/) - UI framework
- [shared_preferences](https://pub.dev/packages/shared_preferences) - Local data storage
- [provider](https://pub.dev/packages/provider) - State management

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── task.dart            # Task data model
├── providers/
│   └── task_provider.dart   # State management with Provider
├── screens/
│   └── task_home_screen.dart # Main screen
└── widgets/
    ├── filter_tabs.dart     # Task filtering tabs
    ├── stats_bar.dart       # Task statistics
    └── task_card.dart       # Individual task display
```
