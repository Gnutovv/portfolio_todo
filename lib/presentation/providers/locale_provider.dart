import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ru'));

  void switchToRussian() => state = const Locale('ru');

  void switchToEnglish() => state = const Locale('en');

  void toggleLanguage() => state = state.languageCode == 'en' ? const Locale('ru') : const Locale('en');
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
