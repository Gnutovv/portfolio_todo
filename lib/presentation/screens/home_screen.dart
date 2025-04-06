import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/presentation/providers/locale_provider.dart';
import 'package:todo/presentation/providers/task_provider.dart';
import 'package:todo/presentation/providers/theme_provider.dart';
import 'package:todo/presentation/widgets/add_task_dialog.dart';
import 'package:todo/presentation/widgets/task_list_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(themeProvider.notifier).loadTheme();
      ref.read(taskProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: Icon(ref.watch(themeProvider) == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => ref.read(localeProvider.notifier).toggleLanguage(),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final tasks = ref.watch(taskProvider);

          if (tasks.isEmpty) {
            return Center(child: Text(l10n.emptyList));
          }
          return TaskListWidget();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
