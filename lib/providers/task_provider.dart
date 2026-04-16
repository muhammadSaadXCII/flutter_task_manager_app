import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

enum TaskFilter { all, active, completed }

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  TaskFilter get filter => _filter;
  bool get isLoading => _isLoading;

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isDone).length;
  int get activeCount => _tasks.where((t) => !t.isDone).length;

  List<Task> get filteredTasks {
    switch (_filter) {
      case TaskFilter.active:
        return _tasks.where((t) => !t.isDone).toList();
      case TaskFilter.completed:
        return _tasks.where((t) => t.isDone).toList();
      case TaskFilter.all:
        return List.from(_tasks);
    }
  }

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];
    _tasks = taskList.map((t) => Task.fromJson(jsonDecode(t))).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = _tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  void addTask(String title) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    _tasks.insert(0, task);
    notifyListeners();
    _saveTasks();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    _saveTasks();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isDone: !_tasks[index].isDone);
      notifyListeners();
      _saveTasks();
    }
  }

  void updateTask(String id, String newTitle) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(title: newTitle.trim());
      notifyListeners();
      _saveTasks();
    }
  }

  void clearCompleted() {
    _tasks.removeWhere((t) => t.isDone);
    notifyListeners();
    _saveTasks();
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }
}
