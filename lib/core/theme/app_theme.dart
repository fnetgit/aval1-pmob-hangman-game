import 'package:flutter/material.dart';

enum LetterState { available, correct, wrong, disabled }

class AppTheme {
  static const _seedColor = Color(0xFF4F46E5);

  static const _letterColors = {
    LetterState.available: (background: Color(0xFF4F46E5), foreground: Colors.white),
    LetterState.correct: (background: Color(0xFF15803D), foreground: Colors.white),
    LetterState.wrong: (background: Color(0xFFB91C1C), foreground: Colors.white),
    LetterState.disabled: (background: Color(0xFFE2E8F0), foreground: Color(0xFF64748B)),
  };

  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(seedColor: _seedColor);

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      ),
    );
  }

  static ButtonStyle letterButton(LetterState state) {
    final colors = _letterColors[state]!;

    return FilledButton.styleFrom(
      backgroundColor: colors.background,
      foregroundColor: colors.foreground,
      minimumSize: const Size.square(48),
      padding: EdgeInsets.zero,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}
