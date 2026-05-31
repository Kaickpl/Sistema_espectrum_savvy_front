import 'package:flutter/material.dart';

class TemaClaro{
  static final ThemeData tema = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6366F1),
      onPrimary: const Color(0xFFFFFFFF),
      secondary: Color(0xFFAF89E4),
      onSecondary: Color(0xFF000000),
      tertiary: Color(0xFF66A3EF),
      onTertiary: Color(0xFF2A7FDC),
      error: Color(0xFF970804),
      onError: Color(0xFFFF6B6B),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFA3A2A2),
    ),
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    // essa sim eh a cor do fundo
  );
}