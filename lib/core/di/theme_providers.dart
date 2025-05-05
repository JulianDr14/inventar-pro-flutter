import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/theme/app_theme.dart';

final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.light);

final themeDataProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == ThemeMode.dark
      ? AppTheme.darkTheme
      : AppTheme.lightTheme;
});