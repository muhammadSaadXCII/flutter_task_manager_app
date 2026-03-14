import 'dart:convert';
import '../models/task.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskHomeScreen extends StatefulWidget {
  const TaskHomeScreen({super.key});

  @override
  State<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends State<TaskHomeScreen> {
  List<Task> tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList();
    await prefs.setStringList('tasks', taskList);
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');

    if (taskList != null) {
      setState(() {
        tasks = taskList
            .map((task) => Task.fromJson(jsonDecode(task)))
            .toList();
      });
    }
  }

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
    saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
    saveTasks();
  }

  void showAddTaskDialog() {
    _taskController.clear();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: "Enter task title",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add"),
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  addTask(_taskController.text);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildTaskCard(int index) {
    final task = tasks[index];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isDone ? Colors.green : Colors.grey,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: task.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        onTap: () => toggleTask(index),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => deleteTask(index),
        ),
      ),
    );
  }

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.task_alt, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No Tasks Available",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Press + to add a new task",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: showAddTaskDialog),
        ],
      ),
      body: tasks.isEmpty
          ? emptyState()
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return buildTaskCard(index);
              },
            ),
    );
  }
}
