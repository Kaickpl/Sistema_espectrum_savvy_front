import 'package:flutter/material.dart';

class TemaClaro {
  static final ThemeData tema = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6366F1),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFAF89E4),
      onSecondary: Color(0xFF000000),
      tertiary: Color(0xFF66A3EF),
      onTertiary: Color(0xFF064485),
      error: Color(0xFF970804),
      onError: Color(0xFFFF6B6B),
      surface: Color(0xFF345085),
      onSurface: Color(0xFFA3A2A2),
      surfaceContainer: Color(0xFF9FB8F3),
    ),
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    // essa sim eh a cor do fundo
  );
}
