// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const Color background = Color(0xFF1E1E1E);
  static const Color primary = Color(0xFFECEC3D);
  static const Color secondary = Color(0xFF3D165C);
  static const Color accent = Color(0xFFD8292C);
  
  // Colores de texto
  static const Color textPrimary = Color(0xFFF2F2F2);
  static const Color textSecondary = Color(0xFF606060);
  static const Color textDark = Color(0xFF1E1E1E);
  
  // Colores de superficie y contenedores
  static const Color surfaceTransparent = Color(0x35606060);
  static const Color surfaceLight = Color(0xFFF2F2F2);
  static const Color surfaceDark = Color(0xFF2A2A2A);
  
  // Colores de entrada de texto
  static const Color inputBackground = Color(0xFFE0E0E0);
  static const Color inputHint = Colors.black54;
  static const Color inputText = Colors.black87;
  
  // Colores de sombra
  static const Color shadowColor = Color(0x3F000000);
  static const Color shadowDark = Color(0x25000000);
  
  // Estados
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  
  // Transparencias comunes
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  // Gradientes (si los necesitas en el futuro)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}