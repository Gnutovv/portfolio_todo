import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:todo/data/models/theme_settings.dart';

const _boxName = 'theme_settings';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  Box<ThemeSettings>? _themeBox;

  FutureOr<Box<ThemeSettings>> get _getBox async {
    _themeBox ??= await Hive.openBox<ThemeSettings>(_boxName);
    return _themeBox!;
  }

  Future<void> loadTheme() async {
    try {
      final box = await _getBox;
      final settings = box.get('settings', defaultValue: ThemeSettings(isDarkMode: false));
      state = settings!.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      debugPrint('Ошибка загрузки темы: $e');
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    try {
      final box = await _getBox;
      await box.put('settings', ThemeSettings(isDarkMode: newMode == ThemeMode.dark));
      state = newMode;
    } catch (e) {
      debugPrint('Ошибка сохранения темы: $e');
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
