import 'package:flutter/material.dart';

class tema_claro{
  static final ThemeData tema = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFAF89E4),
      onPrimary: Colors.black54,
      secondary: Color(0xFF6366F1),
      onSecondary: Colors.white,
      tertiary: Color(0xFF8B5CF6),
      onTertiary: Colors.white,
      error: Color(0xFFE53935),
      onError: Colors.white,
      surface: Color(0xFFF4F5FB),
      onSurface: Color(0xFF1F2937),
    ),
    scaffoldBackgroundColor: Color(0xFFE5E7EB),
    // essa sim eh a cor do fundo
  );
}