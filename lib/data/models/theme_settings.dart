import 'package:hive/hive.dart';

part 'theme_settings.g.dart';

@HiveType(typeId: 1)
class ThemeSettings {
  @HiveField(0)
  final bool isDarkMode;

  ThemeSettings({required this.isDarkMode});
}
