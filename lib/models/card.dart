/// Representa una carta del mazo de XI
/// El mazo tiene exactamente 11 cartas únicas (1-11)
class XICard {
  final int value;
  final String name;
  final String narrativeRole;
  bool isFaceUp;

  XICard({
    required this.value,
    required this.name,
    required this.narrativeRole,
    this.isFaceUp = false,
  });

  /// El As puede valer 1 u 11 (como en blackjack)
  bool get isAce => value == 1;

  /// La carta 11 es la carta de The Gatekeeper
  bool get isGatekeeperCard => value == 11;

  /// Obtiene el valor efectivo de la carta
  /// Para el As, devuelve 11 por defecto (se ajusta en el cálculo de mano)
  int get effectiveValue => isAce ? 11 : value;

  /// Crea las 11 cartas del mazo
  static List<XICard> createDeck() {
    return [
      XICard(
        value: 1,
        name: 'As',
        narrativeRole: 'La carta más poderosa — representa la dualidad vida/muerte',
      ),
      XICard(
        value: 2,
        name: '2',
        narrativeRole: 'Las memorias del alma',
      ),
      XICard(
        value: 3,
        name: '3',
        narrativeRole: 'Las memorias del alma',
      ),
      XICard(
        value: 4,
        name: '4',
        narrativeRole: 'Las memorias del alma',
      ),
      XICard(
        value: 5,
        name: '5',
        narrativeRole: 'Las memorias del alma',
      ),
      XICard(
        value: 6,
        name: '6',
        narrativeRole: 'Las memorias del alma',
      ),
      XICard(
        value: 7,
        name: '7',
        narrativeRole: 'Las memorias del alma',
      ),
      XICard(
        value: 8,
        name: '8',
        narrativeRole: 'Las memorias del alma',
      ),
      XICard(
        value: 9,
        name: '9',
        narrativeRole: 'Las memorias del alma',
      ),
      XICard(
        value: 10,
        name: '10',
        narrativeRole: 'Las memorias del alma',
      ),
      XICard(
        value: 11,
        name: 'XI',
        narrativeRole: 'La carta de The Gatekeeper — el límite absoluto',
      ),
    ];
  }

  @override
  String toString() => 'XICard($name, value: $value)';
}
