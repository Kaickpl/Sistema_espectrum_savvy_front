import 'package:flutter/material.dart';

class TemaEscuro {
  static final ThemeData tema = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      primary: Color(0xFF818CF8), // mais clara para destacar no fundo escuro
      onPrimary: Color(0xFF0F172A),
      secondary: Color(0xFFC4B5FD),
      onSecondary: Color(0xFFFFFFFF),
      tertiary: Color(0xFF60A5FA),
      onTertiary: Color(0xFF032DB6),
      error: Color(0xFF970804),
      onError: Color(0xFFFF6B6B),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF8FAFC),
      surfaceContainer: Color(0xFF345085),
    ),
    scaffoldBackgroundColor: Color(0xFF0F172A),
  );
}