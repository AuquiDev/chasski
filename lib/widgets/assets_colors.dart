import 'package:flutter/material.dart';

class AppColors {
  // Colores principales (derivados del logo)
  static const Color primaryRed = Color(0xFFB71C1C); // Rojo del logo
  static const Color primaryWhite = Colors.white;    // Blanco del logo
  static const Color primaryBlack = Colors.black;    // Negro del logo

  // Colores de fondo
  static const Color backgroundLight = Color(0xFFF5F5F5); // Un blanco suave para fondos claros
  static const Color backgroundDark = Color(0xFF303030); // Un gris oscuro para fondos oscuros

  // Colores de texto
  static const Color textPrimary = Colors.black; // Color principal del texto
  static const Color textSecondary = Color(0xFF757575); // Color secundario del texto (gris)

  // Colores de título
  static const Color title = Colors.black; // Color del título (negro)
  static const Color titleAccent = Color(0xFFB71C1C); // Color del título con acento (rojo)

  // Colores de botones
  static const Color buttonPrimary = Color(0xFFB71C1C); // Color principal del botón (rojo)
  static const Color buttonSecondary = Color(0xFF757575); // Color secundario del botón (gris)

  // Colores adicionales (paleta complementaria)
  static const Color accentColor = Color(0xFF1565C0); // Azul oscuro para acentos
  static const Color successColor = Color(0xFF2E7D32); // Verde oscuro para éxito
  static const Color warningColor = Color(0xFFF9A825); // Amarillo para advertencias
  static const Color errorColor = Color(0xFFD32F2F); // Rojo oscuro para errores
}


//FUNSION QUE DEVULVE UN COLOR
Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexColor', radix: 16));
}
