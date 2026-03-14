# Flutter Task Manager App

A simple and intuitive task management application built with Flutter. This app allows you to keep track of your daily tasks with ease.

## Demo

<video src="assets/videos/task_manager%20demo%20video.mp4" width=100%>

## Features

*   **Add Tasks:** Quickly add new tasks to your to-do list.
*   **Delete Tasks:** Remove tasks that are no longer needed.
*   **Mark as Done:** Toggle the status of your tasks to keep track of your progress.
*   **Data Persistence:** Your tasks are saved locally on your device, so you won't lose them.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK: Make sure you have the Flutter SDK installed on your machine. For more information, see the [Flutter documentation](https://flutter.dev/docs/get-started/install).
*   An editor like Android Studio or VS Code with the Flutter plugin.

### Installation

1.  Clone the repo
    ```sh
    git clone https://github.com/your_username/flutter_task_manager_app.git
    ```
2.  Navigate to the project directory
    ```sh
    cd flutter_task_manager_app
    ```
3.  Install dependencies
    ```sh
    flutter pub get
    ```
4.  Run the app
    ```sh
    flutter run
    ```

## Dependencies

*   [flutter](https://flutter.dev/): The framework for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.
*   [shared_preferences](https://pub.dev/packages/shared_preferences): A Flutter plugin for reading and writing simple key-value pairs.

## Project Structure

```
/lib
|-- /models
|   |-- task.dart         # Model for individual tasks
|-- /screens
|   |-- task_home_screen.dart # Main screen with the task list
|-- main.dart             # App entry point
```