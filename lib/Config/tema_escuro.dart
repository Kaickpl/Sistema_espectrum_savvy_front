import 'package:flutter/material.dart';

class tema_escuro{
  static final ThemeData tema = ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF8B7CFF),
        onPrimary: Colors.white,
        secondary: Color(0xFF2783DC),
        onSecondary: Colors.black,
        tertiary: Color(0xFFB197FC),
        onTertiary: Colors.black,
        error: Color(0xFFEF5350),
        onError: Colors.white,
        surface: Color(0xFF121826),
        onSurface: Color(0xFFF9FAFB),
      ),
  );

}