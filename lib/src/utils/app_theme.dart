// lib/src/utils/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      // --- Colores base ---
      scaffoldBackgroundColor: Colors.grey[200], // Un fondo gris claro para el cuerpo
      primarySwatch: Colors.blue,

      // --- Tema de fuentes (TextTheme) ---
      // Establece Roboto como la fuente por defecto para toda la app.
      textTheme: GoogleFonts.robotoTextTheme(),

      // --- Estilos de widgets específicos ---
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary, // Color para íconos y texto del título
        titleTextStyle: GoogleFonts.passeroOne(
          fontSize: 22,
          color: AppColors.textPrimary,
        ),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surface, // Fondo blanco para el drawer
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textSecondary,
      ),

      bottomAppBarTheme: const BottomAppBarThemeData( // <-- Añade 'Data' aquí
        color: AppColors.background,
        surfaceTintColor: AppColors.background,
     ),

      iconTheme: const IconThemeData(
        color: AppColors.textSecondary, // Color por defecto para íconos
      ),
    );
  }
}