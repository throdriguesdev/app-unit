import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3B82F6), // Azul primário
        brightness: Brightness.light,
        primary: const Color(0xFF3B82F6),
        secondary: const Color(0xFF60A5FA),
        background: const Color(0xFFF3F4F6), // Fundo claro suave
      ),
      scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          color: const Color(0xFF1F2937), // Texto escuro para contraste
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.inter(
          color: const Color(0xFF1F2937),
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.inter(
          color: const Color(0xFF1F2937), // Cor escura para títulos de seção
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: GoogleFonts.inter(
          color: const Color(0xFF374151), // Cinza escuro para texto principal
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: const Color(0xFF6B7280), // Cinza médio para subtextos
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: const Color(0xFFFFFFFF), // Branco puro
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3B82F6),
        brightness: Brightness.dark,
        primary: const Color(0xFF3B82F6),
        secondary: const Color(0xFF60A5FA),
        background: const Color(0xFF1E293B), // Fundo escuro, azul-acinzentado
      ),
      scaffoldBackgroundColor: const Color(0xFF1E293B),
      useMaterial3: true,
      textTheme:
      GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          color: const Color(0xFFFFFFFF), // Branco puro para textos
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.inter(
          color: const Color(0xFFFFFFFF),
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.inter(
          color: const Color(0xFFFFFFFF),
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: GoogleFonts.inter(
          color: const Color(0xFFCBD5E1), // Cinza claro para texto principal
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: const Color(0xFF9CA3AF), // Cinza médio para subtextos
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: const Color(0xFF334155), // Azul escuro para cards
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
      ),
    );
  }
}
