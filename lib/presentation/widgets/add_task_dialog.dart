import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/presentation/providers/task_provider.dart';

void showAddTaskDialog(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(l10n.addTask),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: l10n.addTaskInstruction),
            autofocus: true,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  _addTask(context, ref, controller.text.trim());
                }
              },
              child: Text(l10n.addTaskShort),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(20),
        ),
  );
}

void _addTask(BuildContext context, WidgetRef ref, String text) {
  ref.read(taskProvider.notifier).addTask(text);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(AppLocalizations.of(context)!.taskAdded),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ),
  );
}
