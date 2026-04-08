import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/game_state.dart';
import '../../widgets/game_table_widget.dart';
import '../../data/characters.dart';
import 'betting_screen.dart';

/// Pantalla principal del juego
class GameScreen extends StatefulWidget {
  final GameState gameState;

  const GameScreen({super.key, required this.gameState});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameState _gameState;
  RoundResult? _lastResult;
  bool _showResult = false;
  bool _showStoryFragment = false;
  String? _currentStoryText;

  @override
  void initState() {
    super.initState();
    _gameState = widget.gameState;
    _initGame();
  }

  void _initGame() {
    // Si es modo historia, mostrar fragmento inicial
    if (_gameState.gameMode == GameMode.story &&
        _gameState.currentCharacterId != null) {
      _showStoryFragmentForRound();
    } else {
      // Ir a apuestas o empezar directamente
      if (_gameState.gameMode == GameMode.gambleFree) {
        // Sin apuestas, empezar ronda directamente
        _startRound();
      }
    }
  }

  void _showStoryFragmentForRound() {
    final character = allCharacters.firstWhere(
      (c) => c.id == _gameState.currentCharacterId,
      orElse: () => owen,
    );

    if (_gameState.currentRound <= character.fragments.length) {
      final fragment = character.fragments[_gameState.currentRound - 1];
      setState(() {
        _currentStoryText = fragment.content;
        _showStoryFragment = true;
      });
    } else {
      _startRound();
    }
  }

  void _onStoryFragmentComplete() {
    setState(() {
      _showStoryFragment = false;
      _currentStoryText = null;
    });

    if (_gameState.gameMode == GameMode.gambleFree) {
      _startRound();
    } else {
      // Mostrar pantalla de apuestas
      _showBettingScreen();
    }
  }

  void _showBettingScreen() async {
    final bet = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => BettingScreen(
          maxBet: _gameState.player.fragments,
          currentFragments: _gameState.player.fragments,
          fragmentsAtRisk: _gameState.player.fragmentsAtRisk,
          isGambleFree: _gameState.gameMode == GameMode.gambleFree,
        ),
      ),
    );

    if (bet != null && bet > 0) {
      _gameState.setBet(bet);
    }
    _startRound();
  }

  void _startRound() {
    setState(() {
      _gameState.startRound();
      _showResult = false;
      _lastResult = null;
    });

    // Actualizar humor de The Gatekeeper
    _gameState.gatekeeper.updateMood(
      isGambleFree: _gameState.gameMode == GameMode.gambleFree,
      betAmount: _gameState.currentBet,
      fragmentsAtRisk: _gameState.player.fragmentsAtRisk,
      playerWon: false,
    );
  }

  void _onHit() {
    setState(() {
      _gameState.playerHit();
      if (_gameState.player.isBust) {
        _resolveRound();
      }
    });
  }

  void _onStay() {
    setState(() {
      _gameState.playerStay();
    });

    // Turno del Gatekeeper con delay para dramatismo
    Future.delayed(XIAnimations.slow, () {
      if (mounted) {
        setState(() {
          _gameState.gatekeeperPlay();
        });
        Future.delayed(XIAnimations.normal, () {
          if (mounted) {
            _resolveRound();
          }
        });
      }
    });
  }

  void _resolveRound() {
    final result = _gameState.resolveRound();
    setState(() {
      _lastResult = result;
      _showResult = true;
    });
  }

  void _onContinue() {
    if (_gameState.isGameOver) {
      // Mostrar final del juego
      _showGameOverScreen();
    } else {
      // Siguiente ronda
      _gameState.nextRound();
      if (_gameState.gameMode == GameMode.story) {
        _showStoryFragmentForRound();
      } else if (_gameState.gameMode == GameMode.gambleFree) {
        _startRound();
      } else {
        _showBettingScreen();
      }
    }
  }

  void _showGameOverScreen() {
    // Calcular el final basado en rondas ganadas
    int roundsWon = 0; // TODO: trackear esto en game_state

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: XITheme.surface,
        title: const Text(
          'FIN',
          style: TextStyle(
            color: XITheme.primary,
            fontSize: 32,
            letterSpacing: 4,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _gameState.gameMode == GameMode.story
                  ? 'Has completado la historia'
                  : 'Partida finalizada',
              style: const TextStyle(color: XITheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Fragmentos: ${_gameState.player.fragments}',
              style: const TextStyle(
                color: XITheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Almas: ${_gameState.player.souls}',
              style: const TextStyle(
                color: XITheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar dialog
              Navigator.pop(context); // Volver al menú
            },
            child: const Text('VOLVER AL MENÚ'),
          ),
        ],
      ),
    );
  }

  void _onUseTrumpCard() {
    final trumpCard = _gameState.playerTrumpCard;
    if (trumpCard == null || trumpCard.isUsed) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: XITheme.surface,
        title: Text(
          trumpCard.name,
          style: const TextStyle(color: XITheme.secondary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trumpCard.description,
              style: const TextStyle(color: XITheme.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              trumpCard.gatekeeperQuote,
              style: const TextStyle(
                color: XITheme.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _useTrumpCard();
            },
            child: const Text(
              'USAR',
              style: TextStyle(color: XITheme.secondary),
            ),
          ),
        ],
      ),
    );
  }

  void _useTrumpCard() {
    final trumpCard = _gameState.playerTrumpCard;
    if (trumpCard == null) return;

    setState(() {
      trumpCard.use();
      // TODO: Implementar efectos de cada Trump Card
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XITheme.background,
      body: Stack(
        children: [
          // Mesa de juego
          GameTableWidget(
            gameState: _gameState,
            onHit: _onHit,
            onStay: _onStay,
            onUseTrumpCard: _onUseTrumpCard,
          ),

          // Overlay de fragmento de historia
          if (_showStoryFragment && _currentStoryText != null)
            _buildStoryOverlay(),

          // Overlay de resultado
          if (_showResult && _lastResult != null)
            RoundResultWidget(
              result: _lastResult!,
              playerValue: _gameState.player.handValue,
              gatekeeperValue: _gameState.gatekeeperPlayer.handValue,
              fragmentsWon: _lastResult == RoundResult.playerWins
                  ? _gameState.currentBet * 2
                  : _lastResult == RoundResult.gatekeeperWins
                      ? -_gameState.currentBet
                      : 0,
              onContinue: _onContinue,
            ),

          // Botón de salir
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: XITheme.textMuted),
              onPressed: () => _showExitConfirmation(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryOverlay() {
    final character = allCharacters.firstWhere(
      (c) => c.id == _gameState.currentCharacterId,
      orElse: () => owen,
    );
    final fragment = character.fragments[_gameState.currentRound - 1];

    return Container(
      color: XITheme.background.withValues(alpha: 0.95),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            // Título del fragmento
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'RONDA ${_gameState.currentRound}: ${fragment.title}',
                style: TextStyle(
                  color: fragment.isPlotTwist ? XITheme.secondary : XITheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            // Contenido del fragmento
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _currentStoryText!,
                  style: const TextStyle(
                    color: XITheme.textPrimary,
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Botón continuar
            Padding(
              padding: const EdgeInsets.all(32),
              child: GestureDetector(
                onTap: _onStoryFragmentComplete,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: XITheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'JUGAR RONDA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: XITheme.background,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: XITheme.surface,
        title: const Text(
          '¿Abandonar partida?',
          style: TextStyle(color: XITheme.textPrimary),
        ),
        content: const Text(
          'Perderás el progreso de esta partida.',
          style: TextStyle(color: XITheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar dialog
              Navigator.pop(context); // Volver al menú
            },
            child: const Text(
              'SALIR',
              style: TextStyle(color: XITheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
