import 'package:flutter/material.dart';

class tema_escuro{
  static final ThemeData tema = ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF6366F1),
      onPrimary: Colors.white, 
      secondary: Color(0xFFAF89E4),
      onSecondary: Colors.white,
      tertiary: Color(0xFF2A7FDC),
      onTertiary: Colors.white,
      error: Color(0xFFEF5350), 
      onError: Colors.white,
        surface: Color(0xFF1E293B), 
      onSurface: Color(0xFFF8FAFC), 
    ),
   
    scaffoldBackgroundColor: const Color(0xFF0F172A), 
  );

}