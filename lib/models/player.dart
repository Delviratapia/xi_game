import 'card.dart';

/// Representa un jugador (el alma o The Gatekeeper)
class Player {
  final String name;
  final bool isGatekeeper;
  final List<XICard> hand;
  int fragments; // Moneda narrativa (Dark Souls style)
  int souls; // Para personalización en Free Play
  int fragmentsAtRisk; // Fragmentos que pueden perderse

  Player({
    required this.name,
    this.isGatekeeper = false,
    List<XICard>? hand,
    this.fragments = 0,
    this.souls = 0,
    this.fragmentsAtRisk = 0,
  }) : hand = hand ?? [];

  /// Calcula el valor de la mano
  /// Maneja el As como 1 u 11 automáticamente
  int get handValue {
    int total = 0;
    int aces = 0;

    for (final card in hand) {
      if (card.isAce) {
        aces++;
        total += 11;
      } else {
        total += card.value;
      }
    }

    // Ajustar ases si nos pasamos de 21
    while (total > 21 && aces > 0) {
      total -= 10;
      aces--;
    }

    return total;
  }

  /// Verifica si la mano se pasó de 21
  bool get isBust => handValue > 21;

  /// Verifica si tiene blackjack natural (21 con 2 cartas)
  bool get hasBlackjack => hand.length == 2 && handValue == 21;

  /// Agrega una carta a la mano
  void addCard(XICard card) {
    hand.add(card);
  }

  /// Limpia la mano para una nueva ronda
  void clearHand() {
    hand.clear();
  }

  /// Agrega fragmentos ganados
  void addFragments(int amount) {
    fragments += amount;
  }

  /// Pierde fragmentos
  bool loseFragments(int amount) {
    if (fragments >= amount) {
      fragments -= amount;
      return true;
    }
    return false;
  }

  /// Pone fragmentos en riesgo (sistema Dark Souls)
  void putFragmentsAtRisk(int amount) {
    if (fragments >= amount) {
      fragments -= amount;
      fragmentsAtRisk += amount;
    }
  }

  /// Recupera fragmentos en riesgo al ganar
  void recoverFragmentsAtRisk() {
    fragments += fragmentsAtRisk;
    fragmentsAtRisk = 0;
  }

  /// Pierde fragmentos en riesgo permanentemente
  void loseFragmentsAtRisk() {
    fragmentsAtRisk = 0;
  }

  @override
  String toString() => 'Player($name, hand: $hand, value: $handValue)';
}
