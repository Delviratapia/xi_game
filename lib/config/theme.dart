import 'package:flutter/material.dart';

/// Tema visual de XI
/// Estilo: Pixel art, elegante, minimalista y oscuro
/// Influencias: Hades, Darkest Dungeon, Undertale
class XITheme {
  // Colores principales
  static const Color background = Color(0xFF0D0D0D);
  static const Color backgroundLight = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF252525);

  // Colores de acento
  static const Color primary = Color(0xFFB8860B); // Dorado oscuro
  static const Color primaryLight = Color(0xFFDAA520);
  static const Color secondary = Color(0xFF8B0000); // Rojo sangre
  static const Color secondaryLight = Color(0xFFDC143C);

  // Colores de texto
  static const Color textPrimary = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textMuted = Color(0xFF666666);

  // Colores especiales
  static const Color cardBlue = Color(0xFF1E3A5F); // Reverso de cartas
  static const Color cardRed = Color(0xFF5F1E1E); // Cartas especiales/menú
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFF8F00);
  static const Color error = Color(0xFFC62828);

  // Colores de The Gatekeeper según humor
  static const Color gatekeeperBored = Color(0xFF4A4A4A);
  static const Color gatekeeperAttentive = Color(0xFF2A4A6A);
  static const Color gatekeeperIntense = Color(0xFF6A2A2A);
  static const Color gatekeeperKnowing = Color(0xFF4A2A6A);

  // Fuente pixel art (usar fuente personalizada después)
  static const String fontFamily = 'monospace';

  /// Tema principal de la aplicación
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
      ),
      fontFamily: fontFamily,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: background,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      cardTheme: const CardTheme(
        color: surface,
        elevation: 4,
        margin: EdgeInsets.all(8),
      ),
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),
      dividerTheme: const DividerThemeData(
        color: textMuted,
        thickness: 1,
      ),
    );
  }

  /// Tema con modo daltónico
  static ThemeData get colorBlindTheme {
    return darkTheme.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0077BB), // Azul en lugar de dorado
        secondary: Color(0xFFEE7733), // Naranja en lugar de rojo
        surface: surface,
        error: Color(0xFFCC3311), // Rojo más distinguible
      ),
    );
  }
}

/// Estilos de cartas
class CardStyles {
  static const double cardWidth = 80;
  static const double cardHeight = 120;
  static const double cardBorderRadius = 8;

  static BoxDecoration get cardBack {
    return BoxDecoration(
      color: XITheme.cardBlue,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      border: Border.all(color: XITheme.primary, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 8,
          offset: const Offset(2, 4),
        ),
      ],
    );
  }

  static BoxDecoration get cardFront {
    return BoxDecoration(
      color: XITheme.surface,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      border: Border.all(color: XITheme.textMuted, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 8,
          offset: const Offset(2, 4),
        ),
      ],
    );
  }

  static BoxDecoration get specialCard {
    return BoxDecoration(
      color: XITheme.cardRed,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      border: Border.all(color: XITheme.secondary, width: 2),
      boxShadow: [
        BoxShadow(
          color: XITheme.secondary.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

/// Animaciones
class XIAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration dramatic = Duration(milliseconds: 800);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve dramaticCurve = Curves.easeInOutCubic;
}
