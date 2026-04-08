/// Constantes del juego XI

class GameConstants {
  // Valores del juego
  static const int maxHandValue = 21;
  static const int dealerStandValue = 17;
  static const int deckSize = 11;
  static const int storyRounds = 7;

  // Sistema de Fragmentos
  static const int baseFragmentsPerWin = 10;
  static const int fragmentsMultiplier = 2; // Doble al ganar apuesta
  static const int streakBonus = 5; // Bonus por racha de 3+

  // Sistema de Almas
  static const int soulsPerWinFreePlay = 5;
  static const int soulsPerWinGambleFree = 1;
  static const int soulsStreakBonus = 10;

  // Tiempos de cooldown
  static const int lossStreakCooldownMinutes = 5;
  static const int lossStreakThreshold = 5;

  // UI
  static const double cardAspectRatio = 2 / 3;
  static const int maxCardsInHand = 5;
}

class AppStrings {
  // Títulos
  static const String appTitle = 'XI';
  static const String storyMode = 'Story Mode';
  static const String freePlay = 'Free Play';
  static const String gambleFree = 'Gamble Free';
  static const String settings = 'Settings';
  static const String credits = 'Credits';

  // Acciones del juego
  static const String hit = 'HIT';
  static const String stay = 'STAY';
  static const String bet = 'BET';
  static const String newGame = 'NEW GAME';
  static const String continueGame = 'CONTINUE';

  // Resultados
  static const String youWin = 'YOU WIN';
  static const String youLose = 'YOU LOSE';
  static const String tie = 'TIE';
  static const String bust = 'BUST!';

  // The Gatekeeper
  static const String gatekeeperName = 'The Gatekeeper';
  static const String gatekeeperIntro =
      '"Juega. Gana suficiente... y quizás recuerdes cómo se siente respirar."';

  // Frases de intro
  static const String introLine1 = 'Moriste.';
  static const String introLine2 = 'No sabes cómo ni cuándo.';
  static const String introLine3 =
      'Solo despiertas frente a una mesa en el vacío absoluto,';
  static const String introLine4 =
      'con The Gatekeeper al otro lado barajando cartas sin mirarte.';
}

class AssetPaths {
  // Imágenes (placeholder por ahora)
  static const String imagesPath = 'assets/images/';
  static const String cardBack = '${imagesPath}card_back.png';
  static const String gatekeeper = '${imagesPath}gatekeeper.png';
  static const String table = '${imagesPath}table.png';

  // Audio (placeholder por ahora)
  static const String audioPath = 'assets/audio/';
  static const String bgmMenu = '${audioPath}bgm_menu.mp3';
  static const String bgmGame = '${audioPath}bgm_game.mp3';
  static const String bgmTense = '${audioPath}bgm_tense.mp3';
  static const String sfxCardDeal = '${audioPath}sfx_card_deal.mp3';
  static const String sfxCardFlip = '${audioPath}sfx_card_flip.mp3';
  static const String sfxWin = '${audioPath}sfx_win.mp3';
  static const String sfxLose = '${audioPath}sfx_lose.mp3';
}
