import 'card.dart';
import 'player.dart';
import 'gatekeeper.dart';
import 'trump_card.dart';

/// Modos de juego disponibles
enum GameMode {
  story,      // Narrativa lineal, 7 rondas
  freePlay,   // Partidas infinitas con sistema de apuestas
  gambleFree, // Sin riesgos, para pasar el tiempo
}

/// Fase actual del juego
enum GamePhase {
  betting,      // Eligiendo apuesta
  dealing,      // Repartiendo cartas
  playerTurn,   // Turno del jugador
  gatekeeperTurn, // Turno de The Gatekeeper
  resolution,   // Resolviendo ronda
  roundEnd,     // Mostrando resultado
}

/// Estado completo del juego
class GameState {
  // Jugadores
  final Player player;
  final Gatekeeper gatekeeper;
  final Player gatekeeperPlayer;

  // Mazo
  List<XICard> deck;
  List<XICard> discardPile;

  // Trump Cards
  List<TrumpCard> availableTrumpCards;
  TrumpCard? playerTrumpCard;
  TrumpCard? gatekeeperTrumpCard;

  // Estado de la partida
  GameMode gameMode;
  GamePhase phase;
  int currentRound;
  int totalRounds;
  int currentBet;
  int winStreak;

  // Historia
  String? currentCharacterId;
  int fragmentsUnlocked;

  GameState({
    required this.player,
    required this.gatekeeper,
    required this.gatekeeperPlayer,
    List<XICard>? deck,
    List<XICard>? discardPile,
    List<TrumpCard>? availableTrumpCards,
    this.playerTrumpCard,
    this.gatekeeperTrumpCard,
    this.gameMode = GameMode.freePlay,
    this.phase = GamePhase.betting,
    this.currentRound = 1,
    this.totalRounds = 7,
    this.currentBet = 0,
    this.winStreak = 0,
    this.currentCharacterId,
    this.fragmentsUnlocked = 0,
  })  : deck = deck ?? XICard.createDeck(),
        discardPile = discardPile ?? [],
        availableTrumpCards = availableTrumpCards ?? TrumpCard.createAll();

  /// Crea un nuevo estado de juego
  factory GameState.newGame({
    required GameMode mode,
    String? characterId,
  }) {
    return GameState(
      player: Player(name: 'Alma'),
      gatekeeper: Gatekeeper(),
      gatekeeperPlayer: Player(name: 'The Gatekeeper', isGatekeeper: true),
      gameMode: mode,
      currentCharacterId: characterId,
      totalRounds: mode == GameMode.story ? 7 : 999,
    );
  }

  /// Baraja el mazo
  void shuffleDeck() {
    deck = XICard.createDeck();
    deck.shuffle();
    discardPile.clear();
  }

  /// Reparte una carta del mazo
  XICard? dealCard({bool faceUp = true}) {
    if (deck.isEmpty) {
      // Rebarajar el descarte si el mazo está vacío
      if (discardPile.isNotEmpty) {
        deck = List.from(discardPile);
        discardPile.clear();
        deck.shuffle();
      } else {
        return null;
      }
    }
    final card = deck.removeLast();
    card.isFaceUp = faceUp;
    return card;
  }

  /// Inicia una nueva ronda
  void startRound() {
    // Limpiar manos
    player.clearHand();
    gatekeeperPlayer.clearHand();

    // Barajar mazo
    shuffleDeck();

    // Repartir cartas iniciales (2 cada uno)
    // Jugador: ambas boca arriba
    final playerCard1 = dealCard(faceUp: true);
    final playerCard2 = dealCard(faceUp: true);
    if (playerCard1 != null) player.addCard(playerCard1);
    if (playerCard2 != null) player.addCard(playerCard2);

    // Gatekeeper: una boca arriba, una boca abajo
    final gkCard1 = dealCard(faceUp: true);
    final gkCard2 = dealCard(faceUp: false); // Carta oculta
    if (gkCard1 != null) gatekeeperPlayer.addCard(gkCard1);
    if (gkCard2 != null) gatekeeperPlayer.addCard(gkCard2);

    // Asignar Trump Cards a partir de la ronda 2
    if (currentRound >= 2) {
      final available = availableTrumpCards.where((t) => !t.isUsed).toList();
      if (available.isNotEmpty) {
        available.shuffle();
        playerTrumpCard = available.first;
      }
    }

    phase = GamePhase.playerTurn;
  }

  /// Jugador pide carta (Hit)
  bool playerHit() {
    if (phase != GamePhase.playerTurn) return false;

    final card = dealCard(faceUp: true);
    if (card != null) {
      player.addCard(card);
      if (player.isBust) {
        phase = GamePhase.resolution;
      }
      return true;
    }
    return false;
  }

  /// Jugador se planta (Stay)
  void playerStay() {
    if (phase != GamePhase.playerTurn) return;

    // Revelar carta oculta del Gatekeeper
    for (final card in gatekeeperPlayer.hand) {
      card.isFaceUp = true;
    }

    phase = GamePhase.gatekeeperTurn;
  }

  /// Turno del Gatekeeper (IA simple)
  void gatekeeperPlay() {
    if (phase != GamePhase.gatekeeperTurn) return;

    // IA básica: pide cartas hasta llegar a 17 o más
    while (gatekeeperPlayer.handValue < 17 && !gatekeeperPlayer.isBust) {
      final card = dealCard(faceUp: true);
      if (card != null) {
        gatekeeperPlayer.addCard(card);
      } else {
        break;
      }
    }

    phase = GamePhase.resolution;
  }

  /// Resuelve el resultado de la ronda
  RoundResult resolveRound() {
    if (phase != GamePhase.resolution) {
      return RoundResult.ongoing;
    }

    RoundResult result;

    if (player.isBust) {
      result = RoundResult.gatekeeperWins;
    } else if (gatekeeperPlayer.isBust) {
      result = RoundResult.playerWins;
    } else if (player.handValue > gatekeeperPlayer.handValue) {
      result = RoundResult.playerWins;
    } else if (player.handValue < gatekeeperPlayer.handValue) {
      result = RoundResult.gatekeeperWins;
    } else {
      result = RoundResult.tie;
    }

    // Aplicar resultados de apuesta
    _applyBetResult(result);

    // Actualizar estado de The Gatekeeper
    gatekeeper.updateAfterRound(result == RoundResult.playerWins);

    phase = GamePhase.roundEnd;
    return result;
  }

  void _applyBetResult(RoundResult result) {
    switch (result) {
      case RoundResult.playerWins:
        // Gana el doble de la apuesta
        player.addFragments(currentBet * 2);
        // Recupera fragmentos en riesgo
        player.recoverFragmentsAtRisk();
        winStreak++;
        // Bonus por racha
        if (winStreak >= 3) {
          player.souls += 10; // Bonus de Almas
        }
        break;
      case RoundResult.gatekeeperWins:
        // Pierde la apuesta (ya se descontó)
        // Pierde fragmentos en riesgo
        player.loseFragmentsAtRisk();
        winStreak = 0;
        break;
      case RoundResult.tie:
        // Devuelve la apuesta
        player.addFragments(currentBet);
        break;
      case RoundResult.ongoing:
        break;
    }
  }

  /// Prepara la siguiente ronda
  void nextRound() {
    currentRound++;
    currentBet = 0;
    phase = GamePhase.betting;
  }

  /// Establece la apuesta actual
  void setBet(int amount) {
    if (amount <= player.fragments) {
      player.loseFragments(amount);
      currentBet = amount;
    }
  }

  /// Verifica si el juego terminó
  bool get isGameOver {
    if (gameMode == GameMode.story) {
      return currentRound > totalRounds;
    }
    return false;
  }

  /// Obtiene las Almas ganadas en la partida
  int getSoulsReward() {
    if (gameMode == GameMode.gambleFree) {
      return 1; // Muy pocas Almas
    }
    // Recompensa variable para maximizar retención
    final base = 5 + (winStreak * 2);
    final variance = DateTime.now().millisecond % 5;
    return base + variance;
  }
}

/// Resultado de una ronda
enum RoundResult {
  playerWins,
  gatekeeperWins,
  tie,
  ongoing,
}
