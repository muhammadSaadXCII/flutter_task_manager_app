import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/stats_bar.dart';
import '../widgets/filter_tabs.dart';

class TaskHomeScreen extends StatelessWidget {
  const TaskHomeScreen({super.key});

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'What needs to be done?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.add_task),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context.read<TaskProvider>().addTask(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Task'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          context.read<TaskProvider>().addTask(controller.text);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Consumer<TaskProvider>(
            builder:
                (context, provider, _) =>
                    provider.completedCount > 0
                        ? IconButton(
                          icon: const Icon(Icons.cleaning_services_outlined),
                          tooltip: 'Clear completed',
                          onPressed: () {
                            provider.clearCompleted();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Completed tasks cleared'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        )
                        : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              if (provider.totalCount > 0) const StatsBar(),
              const FilterTabs(),
              Expanded(
                child:
                    provider.filteredTasks.isEmpty
                        ? _EmptyState(filter: provider.filter)
                        : AnimatedList(
                          key: GlobalKey<AnimatedListState>(),
                          initialItemCount: provider.filteredTasks.length,
                          padding: const EdgeInsets.only(top: 8, bottom: 100),
                          itemBuilder: (context, index, animation) {
                            if (index >= provider.filteredTasks.length) {
                              return const SizedBox.shrink();
                            }
                            final task = provider.filteredTasks[index];
                            return TaskCard(key: ValueKey(task.id), task: task);
                          },
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final TaskFilter filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = switch (filter) {
      TaskFilter.completed => (
        Icons.check_circle_outline_rounded,
        'No completed tasks',
        'Complete a task to see it here',
      ),
      TaskFilter.active => (
        Icons.pending_actions_rounded,
        'All tasks done!',
        'Great job! Add more tasks to keep going',
      ),
      TaskFilter.all => (
        Icons.task_alt_rounded,
        'No tasks yet',
        'Tap + to add your first task',
      ),
    };

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        builder: (_, value, child) => Opacity(opacity: value, child: child),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}
