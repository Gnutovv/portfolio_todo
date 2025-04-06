import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/data/models/theme_settings.dart';
import 'package:todo/presentation/providers/locale_provider.dart';
import 'package:todo/presentation/providers/theme_provider.dart';
import 'package:todo/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ThemeSettingsAdapter());
  Hive.registerAdapter(TaskAdapter());

  runApp(
    ProviderScope(
      child: Consumer(
        builder:
            (context, ref, _) => MaterialApp(
              home: const HomePage(),
              themeMode: ref.watch(themeProvider),
              theme: ThemeData(
                primaryColor: Colors.blue,
                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue, brightness: Brightness.light),
                floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.blue[600]),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.dark(primary: Colors.blueGrey, secondary: Colors.blueGrey[200]!),
              ),
              locale: ref.watch(localeProvider),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
      ),
    ),
  );
}
