/// Sistema de apuesta de rondas según GDD v1.4
/// Cuando el jugador no tiene Fragmentos, apuesta rondas de la partida actual
class RoundBetSystem {
  int currentRound;
  int fragmentsAvailable;
  final int totalRounds;
  List<bool> fragmentsUnlocked;

  RoundBetSystem({
    this.currentRound = 1,
    this.fragmentsAvailable = 0,
    this.totalRounds = 7,
  }) : fragmentsUnlocked = List.filled(7, false);

  /// ¿Puede apostar Fragmentos normalmente?
  bool get canBetFragments => fragmentsAvailable > 0;

  /// ¿Puede apostar rondas? (solo si no está en ronda 1)
  bool get canBetRounds => currentRound > 1 && !canBetFragments;

  /// ¿Está en el límite de deuda? (ronda 1 sin Fragmentos)
  bool get isAtDebtLimit => currentRound == 1 && fragmentsAvailable == 0;

  /// Obtiene cuántas rondas debe apostar
  /// Ronda 7 = 2 rondas, resto = 1 ronda
  int get roundsToBet => currentRound == 7 ? 2 : 1;

  /// Ronda a la que retrocederá si pierde
  int get roundAfterLoss => (currentRound - roundsToBet).clamp(1, totalRounds);

  /// Mensaje de The Gatekeeper según la situación
  String get gatekeeperBetMessage {
    if (canBetFragments) {
      return '"¿Cuánto estás dispuesto a arriesgar?"';
    } else if (canBetRounds) {
      if (currentRound == 7) {
        return '"Ronda final... y sin nada que ofrecer. Apostemos dos rondas. Si pierdes, vuelves a la quinta."';
      }
      return '"Sin nada que ofrecer? Entonces apostemos algo más valioso. Tu tiempo aquí."';
    } else {
      // Límite de deuda
      return '"Ya no tienes nada que perder. Ni tiempo. Jugaremos por algo diferente."';
    }
  }

  /// Mensaje adicional explicando la apuesta de rondas
  String get roundBetExplanation {
    if (!canBetRounds) return '';

    if (currentRound == 7) {
      return 'Si pierdes: Retrocedes a ronda 5\nPierdes los fragmentos de ronda 6 y 7';
    }
    return 'Si pierdes: Retrocedes a ronda ${currentRound - 1}\nEl fragmento de esta ronda se bloquea';
  }

  /// Procesa una victoria
  void onRoundWon(int fragmentsEarned) {
    fragmentsUnlocked[currentRound - 1] = true;
    fragmentsAvailable += fragmentsEarned;

    if (currentRound < totalRounds) {
      currentRound++;
    }
  }

  /// Procesa una derrota con apuesta de rondas
  void onRoundLostWithRoundBet() {
    // Bloquear fragmentos de las rondas que se pierden
    for (int r = roundAfterLoss; r < currentRound; r++) {
      fragmentsUnlocked[r] = false;
    }

    // Retroceder
    currentRound = roundAfterLoss;
  }

  /// Procesa una derrota con apuesta de Fragmentos
  void onRoundLostWithFragmentBet(int fragmentsLost) {
    fragmentsAvailable -= fragmentsLost;
    if (fragmentsAvailable < 0) fragmentsAvailable = 0;
  }

  /// Procesa la derrota en límite de deuda (pierde acceso al final)
  bool onDebtLimitLoss() {
    // La partida termina sin final
    return false; // false = historia incompleta
  }

  /// ¿Ha desbloqueado el fragmento de una ronda específica?
  bool isFragmentUnlocked(int round) {
    if (round < 1 || round > totalRounds) return false;
    return fragmentsUnlocked[round - 1];
  }

  /// Obtiene el número de fragmentos desbloqueados
  int get unlockedFragmentsCount => fragmentsUnlocked.where((f) => f).length;

  /// ¿Puede acceder al final? (depende de rondas ganadas)
  String getEndingType() {
    final wins = unlockedFragmentsCount;
    if (wins >= 6) return 'A'; // Final bueno
    if (wins >= 4) return 'B'; // Final medio
    return 'C'; // Final malo
  }

  /// Reinicia el sistema para una nueva partida
  void reset() {
    currentRound = 1;
    fragmentsAvailable = 0;
    fragmentsUnlocked = List.filled(totalRounds, false);
  }

  @override
  String toString() {
    return 'RoundBetSystem(round: $currentRound/$totalRounds, fragments: $fragmentsAvailable, unlocked: $unlockedFragmentsCount)';
  }
}

/// Estados de apuesta posibles
enum BetType {
  fragments,    // Apuesta normal con Fragmentos
  rounds,       // Apuesta de rondas (sin Fragmentos)
  debtLimit,    // Límite de deuda (ronda 1 sin nada)
  none,         // Sin apuesta (Gamble Free)
}

/// Resultado de una ronda con apuesta
class RoundBetResult {
  final bool won;
  final BetType betType;
  final int fragmentsChange;
  final int? newRound;
  final List<int>? fragmentsLost;

  RoundBetResult({
    required this.won,
    required this.betType,
    this.fragmentsChange = 0,
    this.newRound,
    this.fragmentsLost,
  });
}
