import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/presentation/providers/task_provider.dart';

class TaskListWidget extends ConsumerWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (_, index) {
        final task = tasks[index];
        return Dismissible(
          key: Key('${task.title}-$index'),
          direction: DismissDirection.endToStart,
          background: Container(color: Colors.red),
          confirmDismiss: (_) async {
            try {
              await ref.read(taskProvider.notifier).deleteTask(task.id);
              return true;
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка удаления: $e')));
              }
              return false;
            }
          },
          onDismissed: (_) {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: CheckboxListTile(
              value: task.isCompleted,
              onChanged: (_) => ref.read(taskProvider.notifier).toggleTask(task.id),
              title: Text(
                task.title,
                style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null),
              ),
            ),
          ),
        );
      },
    );
  }
}
