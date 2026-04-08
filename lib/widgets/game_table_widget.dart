import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import 'card_widget.dart';
import 'gatekeeper_widget.dart';

/// Widget de la mesa de juego completa
class GameTableWidget extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onHit;
  final VoidCallback onStay;
  final VoidCallback? onUseTrumpCard;

  const GameTableWidget({
    super.key,
    required this.gameState,
    required this.onHit,
    required this.onStay,
    this.onUseTrumpCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF151515),
            Color(0xFF0A0A0A),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Área de The Gatekeeper
            Expanded(
              flex: 3,
              child: _buildGatekeeperArea(),
            ),
            // Área central (información de partida)
            _buildGameInfo(),
            // Área del jugador
            Expanded(
              flex: 3,
              child: _buildPlayerArea(),
            ),
            // Botones de acción
            if (gameState.phase == GamePhase.playerTurn) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildGatekeeperArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // The Gatekeeper
        GatekeeperWidget(
          gatekeeper: gameState.gatekeeper,
          showQuote: false,
          size: 100,
        ),
        const SizedBox(height: 16),
        // Mano de The Gatekeeper
        HandWidget(
          cards: gameState.gatekeeperPlayer.hand,
          hideFirst: gameState.phase == GamePhase.playerTurn,
          scale: 0.8,
        ),
        const SizedBox(height: 8),
        // Valor de la mano (oculto si es turno del jugador)
        _buildHandValue(
          gameState.gatekeeperPlayer,
          hidden: gameState.phase == GamePhase.playerTurn,
        ),
      ],
    );
  }

  Widget _buildGameInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Ronda actual
          _buildInfoChip(
            'RONDA',
            '${gameState.currentRound}/${gameState.totalRounds}',
          ),
          // Apuesta actual
          _buildInfoChip(
            'APUESTA',
            '${gameState.currentBet}',
            highlight: gameState.currentBet > 0,
          ),
          // Fragmentos del jugador
          _buildInfoChip(
            'FRAGMENTOS',
            '${gameState.player.fragments}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, {bool highlight = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: XITheme.textMuted,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: highlight ? XITheme.primary.withValues(alpha: 0.2) : XITheme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: highlight ? XITheme.primary : XITheme.textMuted.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: highlight ? XITheme.primary : XITheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Valor de la mano
        _buildHandValue(gameState.player, hidden: false),
        const SizedBox(height: 8),
        // Mano del jugador
        HandWidget(
          cards: gameState.player.hand,
          scale: 1.0,
        ),
        const SizedBox(height: 16),
        // Trump Card disponible
        if (gameState.playerTrumpCard != null && !gameState.playerTrumpCard!.isUsed)
          _buildTrumpCardButton(),
      ],
    );
  }

  Widget _buildHandValue(Player player, {required bool hidden}) {
    final value = player.handValue;
    final isBust = player.isBust;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isBust
            ? XITheme.error.withValues(alpha: 0.3)
            : XITheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        hidden ? '?' : (isBust ? 'BUST!' : '$value'),
        style: TextStyle(
          color: isBust ? XITheme.error : XITheme.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTrumpCardButton() {
    final trumpCard = gameState.playerTrumpCard!;
    return GestureDetector(
      onTap: onUseTrumpCard,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: XITheme.cardRed.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: XITheme.secondary, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: XITheme.secondary, size: 16),
            const SizedBox(width: 8),
            Text(
              trumpCard.name,
              style: const TextStyle(
                color: XITheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Botón HIT
          _ActionButton(
            label: 'HIT',
            onTap: onHit,
            isPrimary: false,
          ),
          // Botón STAY
          _ActionButton(
            label: 'STAY',
            onTap: onStay,
            isPrimary: true,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? XITheme.primary : XITheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPrimary ? XITheme.primaryLight : XITheme.textMuted,
            width: 2,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: XITheme.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isPrimary ? XITheme.background : XITheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

/// Widget para mostrar el resultado de la ronda
class RoundResultWidget extends StatelessWidget {
  final RoundResult result;
  final int playerValue;
  final int gatekeeperValue;
  final int fragmentsWon;
  final VoidCallback onContinue;

  const RoundResultWidget({
    super.key,
    required this.result,
    required this.playerValue,
    required this.gatekeeperValue,
    required this.fragmentsWon,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    Color color;

    switch (result) {
      case RoundResult.playerWins:
        title = 'VICTORIA';
        color = XITheme.success;
        break;
      case RoundResult.gatekeeperWins:
        title = 'DERROTA';
        color = XITheme.error;
        break;
      case RoundResult.tie:
        title = 'EMPATE';
        color = XITheme.warning;
        break;
      case RoundResult.ongoing:
        title = '';
        color = XITheme.textMuted;
        break;
    }

    return Container(
      color: XITheme.background.withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildScoreColumn('TÚ', playerValue),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'vs',
                    style: TextStyle(
                      color: XITheme.textMuted,
                      fontSize: 20,
                    ),
                  ),
                ),
                _buildScoreColumn('GATEKEEPER', gatekeeperValue),
              ],
            ),
            if (fragmentsWon != 0)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  fragmentsWon > 0
                      ? '+$fragmentsWon Fragmentos'
                      : '$fragmentsWon Fragmentos',
                  style: TextStyle(
                    color: fragmentsWon > 0 ? XITheme.success : XITheme.error,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onContinue,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: XITheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'CONTINUAR',
                  style: TextStyle(
                    color: XITheme.background,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreColumn(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: XITheme.textMuted,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: const TextStyle(
            color: XITheme.textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
