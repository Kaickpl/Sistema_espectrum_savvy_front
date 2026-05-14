import 'package:flutter/material.dart';

class TemaClaro{
  static final ThemeData tema = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6366F1),
      onPrimary: const Color(0xFFFFFFFF),
      secondary: Color(0xFFAF89E4),
      onSecondary: Colors.white,
      tertiary: Color(0xFF2A7FDC),
      onTertiary: Color(0xFF66A3EF),
      error: Color(0xFFE53935),
      onError: Colors.white,
      surface: Color(0xFFF4F5FB),
      onSurface: Color(0xFF1F2937),
    ),
    scaffoldBackgroundColor: Color(0xFFE5E7EB),
    // essa sim eh a cor do fundo
  );
}