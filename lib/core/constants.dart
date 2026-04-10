import 'package:flutter/material.dart';

/// Constantes globales del juego XI
/// Resolución lógica 320x180 escalado x4 = 1280x720
class XIConstants {
  // Resolución pixel art
  static const double gameWidth = 320;
  static const double gameHeight = 180;
  static const int scaleMultiplier = 4;
  static const int targetFps = 12;

  // Tiempos de intro (en segundos)
  static const double introTitleDuration = 1.5;
  static const double introHandsDuration = 0.5;
  static const double introCardsSeparation = 1.0;
  static const double introArcDuration = 0.3;
  static const double introRedCardDuration = 0.3;
  static const double introMenuDuration = 0.4;

  // Valores del juego
  static const int maxHandValue = 21;
  static const int dealerStandValue = 17;
  static const int deckSize = 11;
  static const int storyRounds = 7;

  // Sistema de Fragmentos
  static const int baseFragmentsPerWin = 10;
  static const int fragmentsMultiplier = 2;
  static const int streakBonus = 5;

  // Sistema de Almas
  static const int soulsPerWinFreePlay = 5;
  static const int soulsPerWinGambleFree = 1;
  static const int soulsStreakBonus = 10;

  // Cooldowns
  static const int lossStreakCooldownMinutes = 5;
  static const int lossStreakThreshold = 5;
}

/// Colores del juego XI
class XIColors {
  // Fondos
  static const Color background = Color(0xFF0D0D0D);
  static const Color backgroundLight = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF252525);

  // Acentos
  static const Color primary = Color(0xFFB8860B); // Dorado oscuro
  static const Color primaryLight = Color(0xFFDAA520);
  static const Color secondary = Color(0xFF8B0000); // Rojo sangre
  static const Color secondaryLight = Color(0xFFDC143C);

  // Texto
  static const Color textPrimary = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textMuted = Color(0xFF666666);

  // Cartas
  static const Color cardBlue = Color(0xFF1E3A5F);
  static const Color cardRed = Color(0xFF5F1E1E);

  // Estados
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFF8F00);
  static const Color error = Color(0xFFC62828);

  // Gatekeeper moods
  static const Color gatekeeperBored = Color(0xFF4A4A4A);
  static const Color gatekeeperAttentive = Color(0xFF2A4A6A);
  static const Color gatekeeperIntense = Color(0xFF6A2A2A);
  static const Color gatekeeperKnowing = Color(0xFF4A2A6A);

  // Nombres de personajes (para diálogos)
  static const Color owenName = Color(0xFFDAA520); // Dorado
  static const Color noraName = Color(0xFFB0C4DE); // Blanco frío
  static const Color gatekeeperName = Color(0xFF8B0000); // Rojo oscuro
}

/// Strings del juego
class XIStrings {
  static const String appTitle = 'XI';
  static const String storyMode = 'STORY';
  static const String freePlay = 'FREE PLAY';
  static const String gambleFree = 'GAMBLE FREE';
  static const String settings = 'SETTINGS';

  // Acciones
  static const String hit = 'HIT';
  static const String stay = 'STAY';
  static const String play = 'JUGAR';

  // Gatekeeper
  static const String gatekeeperIntro =
      '"Juega. Gana suficiente... y quizás recuerdes cómo se siente respirar."';
  static const String gatekeeperQuote =
      '"Todos llegan aquí tarde o temprano. Pero algunos tienen la opción de volver."';
}

/// Rutas de assets
class XIAssets {
  // Sprites
  static const String spritesPath = 'assets/sprites/';
  static const String charactersPath = '${spritesPath}characters/';
  static const String gatekeeperPath = '${spritesPath}gatekeeper/';
  static const String environmentsPath = '${spritesPath}environments/';
  static const String cardsPath = '${spritesPath}cards/';
  static const String uiPath = '${spritesPath}ui/';

  // Audio
  static const String musicPath = 'assets/audio/music/';
  static const String sfxPath = 'assets/audio/sfx/';

  // Story
  static const String storyPath = 'assets/story/';
}
